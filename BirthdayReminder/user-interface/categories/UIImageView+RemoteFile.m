//
//  UIImageView+RemoteFile.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 10/4/15.
//  Copyright © 2015 project year six. All rights reserved.
//

#import "UIImageView+RemoteFile.h"
#import <objc/runtime.h>

#pragma mark DownloadHelper
//A helper class for handling data download events and storing data progressively as it downloads for an image file
@protocol DownloadHelperDelegate <NSObject>

-(void)didCompleteDownloadForURL:(NSString *)url withData:(NSMutableData *)data;

@end

//We create a new instance of DownloadHelper whenever an image view needs to begin downloading a new remote image file.
@interface DownloadHelper : NSObject

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,assign) id<DownloadHelperDelegate> delegate;

@end

@implementation DownloadHelper

@synthesize url = _url;
@synthesize data = _data;
@synthesize connection = _connection;
@synthesize delegate = _delegate;

-(void) connection: (NSURLConnection*) connection didReceiveData:(nonnull NSData *)data{
    //add the new bytes of data to our existing mutable data container
    [self.data appendData:data];
}

//will notifiy its owning image view via a delegate callback method didCompleteDownloadForURL
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //done downloading data - process completed!
    [self.delegate didCompleteDownloadForURL:self.url withData:self.data];
}

-(void) cancelConnection {
    if(self.connection){
        [self.connection cancel];
        [self setConnection:nil];
    }
}

-(void) dealloc
{
    [self cancelConnection];
}

@end

#pragma mark ImageCache
@interface  ImageCache : NSObject

@property (nonatomic,strong) NSMutableDictionary *cache;
-(UIImage *) cachedImageForURL:(NSString *)url;
-(void) storeCachedImage:(UIImage *)image forURL:(NSString *)url;
@end

@implementation ImageCache

@synthesize cache =_cache;
-(id) init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

-(NSMutableDictionary *) cache{
    if(_cache == nil){
        _cache = [NSMutableDictionary dictionary];
    }
    return _cache;
}

-(void)clearCache
{
    [self.cache removeAllObjects];
}

-(void) storeCachedImage:(UIImage *)image forURL:(NSString *)url {
    self.cache[url] = image;
}

-(UIImage *) cachedImageForURL:(NSString *)url{
    return self.cache[url];
}

@end


@interface UIImageView(RemoteFileHidden)

@property (nonatomic,strong,setter= setUrl:) NSString *url;
@property (nonatomic,strong,setter= setDownloadHelper:) DownloadHelper *downloadHelper;

@end

@implementation UIImageView(RemoteFileHidden)

@dynamic url;
@dynamic downloadHelper;

static char kImageUrlObjectKey;
static char kImageDownloadHelperObjectKey;

+ (ImageCache *)imageCache{
    static ImageCache *_imageCache;
    
    //return a singleton instance of ImageCache
    if(_imageCache == nil){
        _imageCache = [[ImageCache alloc] init];
    }
    return _imageCache;
}

-(NSString *)url {
    return (NSString *)objc_getAssociatedObject(self, &kImageUrlObjectKey);
}

-(void)setUrl:(NSString *)url{
    objc_setAssociatedObject(self, &kImageUrlObjectKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DownloadHelper *)downloadHelper{
    DownloadHelper *helper = (DownloadHelper *)objc_getAssociatedObject(self, &kImageDownloadHelperObjectKey);
    
    if(helper == nil) {//lazy loading of the helper class
        helper = [[DownloadHelper alloc]init];
        //when the helper finishes downloading the remote image data it will call it's delegate (this image view)
        helper.delegate = self;
        self.downloadHelper = helper;
    }
    
    return helper;
}

-(void) setDownloadHelper:(DownloadHelper *)downloadHelper {
    objc_setAssociatedObject(self, &kImageDownloadHelperObjectKey, downloadHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)dealloc{
    if(self.url !=nil){
        [self.downloadHelper cancelConnection];
    }
}

#pragma mark DownloadHelperDelegate

-(void)didCompleteDownloadForURL:(NSString *)url withData:(NSMutableData *)data{
    //handles the downloaded image data turns it into an image instance and saves it into the ImageCache singleton
    
    UIImage *image = [UIImage imageWithData:data];
    
    if(image == nil){ //something didn't work out - data may be corrupted or a bad url
        NSLog(@"DownloadHelperDelegate - Something didn't work with download of image: image == nil");
        return;
    }
    
    //cache the image
    ImageCache *imageCache = [UIImageView imageCache];
    [imageCache storeCachedImage:image forURL:url];
    
    //update the placeholder image display for this UIImageView
    self.image = image;
}

@end

#pragma mark RemoteFile implementation
@implementation UIImageView (RemoteFile)


-(void)setImageWithRemoteFileURL:(NSString *)urlString placeHolderImage:(UIImage *)placeHolderImage{
    if(self.url != nil && [self.url isEqualToString:urlString]){
        //if the url matches the existing url then ignore it
        return;
    }
    //in case of reuse of the UIImageView i.e. in a Table view cell, cancel any existing file download
    [self.downloadHelper cancelConnection];
    
    self.url = urlString;
    
    //get a reference to the image cache singleton
    ImageCache *imageCache = [UIImageView imageCache];
    
    UIImage *image = [imageCache cachedImageForURL:urlString];
    //check it we've already got a cached version of the image
    if(image) {
        self.image = image;
        return;
    }
    
    //no cached version so start downloading the remote file
    self.image = placeHolderImage;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.downloadHelper.url = urlString;
    //set the download helper as the delegate of the data download updates
    self.downloadHelper.connection = (NSURLConnection *)[[NSURLConnection alloc] initWithRequest:request delegate:self.downloadHelper startImmediately:YES];
    if(self.downloadHelper.connection){
        //create an empty mutable data container to add the data bytes to
        self.downloadHelper.data = [NSMutableData data];
    }
}

@end

