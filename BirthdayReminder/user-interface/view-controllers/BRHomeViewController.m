//
//  BRHomeViewController.m
//  BirthdayReminder
//
//  Created by Brian Laskey on 7/18/15.
//  Copyright (c) 2015 project year six. All rights reserved.
//

#import "BRHomeViewController.h"
#import "BRBirthdayDetailViewController.h"
#import "BRBirthdayEditViewController.h"
#import "BRDBirthday.h"
#import "BRDModel.h"
#import "BRBirthdayTableViewCell.h"
#import "BRStyleSheet.h"

@interface BRHomeViewController ()
//Data reference
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL hasFriends;
@end

@implementation BRHomeViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.hasFriends = [self.fetchedResultsController.fetchedObjects count] > 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCachedBirthdaysDidUpdate:) name:BRNotificationCachedBirthdaysDidUpdate object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BRNotificationCachedBirthdaysDidUpdate object:nil];
}


-(void)handleCachedBirthdaysDidUpdate:(NSNotification *)notification {
    //if the cache updates simply reload the table view
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BRStyleSheet styleLabel:self.importLabel withType:BRLabelTypeLarge];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindActionMethodName:(UIStoryboardSegue *) segue {
    NSLog(@"unwindBackToHomeViewController!");
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    //celebrity birthday data from plist file
    /*
    if(self) {
        NSString* pListPath = [[NSBundle mainBundle] pathForResource:@"birthdays" ofType:@"plist"];
        NSArray *nonMutableBirthdays = [NSArray arrayWithContentsOfFile:pListPath];
        
        
        
        BRDBirthday *birthday;
        NSDictionary *dictionary;
        NSString *name;
        NSString *pic;
        NSString *pathForPic;
        NSData *imageData;
        NSDate *birthdate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSString *uid;
        NSMutableArray *uids = [NSMutableArray array];
        for(int i=0;i<[nonMutableBirthdays count];i++){
            dictionary = [nonMutableBirthdays objectAtIndex:i];
            uid = dictionary[@"name"];
            [uids addObject:uid];
        }
        NSMutableDictionary *existingEntities = [[BRDModel sharedInstance] getExistingBirthdaysWithUIDs:uids];
        
        NSManagedObjectContext *context = [BRDModel sharedInstance].managedObjectContext;
        
        for (int i=0; i<[nonMutableBirthdays count]; i++) {
            dictionary = [nonMutableBirthdays objectAtIndex:i];
            
            uid = dictionary[@"name"];
            
            birthday = existingEntities[uid];
            
            if(birthday){
                //birthday already exists
            }else{
                birthday = [NSEntityDescription insertNewObjectForEntityForName:@"BRDBirthday" inManagedObjectContext:context];
                existingEntities[uid] = birthday;
                birthday.uid = uid;
            }
            name = dictionary[@"name"];
            pic = dictionary[@"pic"];
            pathForPic = [[NSBundle mainBundle] pathForResource:pic ofType:nil];
            imageData = [NSData dataWithContentsOfFile:pathForPic];
            birthdate = dictionary[@"birthdate"];
            birthday.name = name;
            birthday.imageData = imageData;
            
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthdate];
            //new literals sysntax, same as
            //birthday.birthDay = [[NSNumber numberWithInt:components.day];
            birthday.birthDay = @(components.day);
            birthday.birthMonth = @(components.month);
            birthday.birthYear = @(components.year);
            [birthday updateNextBirthdayAndAge];
            
        }
        [[BRDModel sharedInstance] saveChanges];
    }
     */
    return self;
}

-(void) setHasFriends:(BOOL)hasFriends{
    _hasFriends = hasFriends;
    self.importView.hidden = _hasFriends;
    self.tableView.hidden = !_hasFriends;
    
    if(self.navigationController.topViewController == self){
        [self.navigationController setToolbarHidden:!_hasFriends animated:NO];
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    BRDBirthday *birthday = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    BRBirthdayTableViewCell *brTableCell = (BRBirthdayTableViewCell *)cell;
    brTableCell.birthday = birthday;
    //if(birthday.imageData ==nil){
    //    brTableCell.iconView.image = [UIImage imageNamed:@"icon-birthday-cake.png"];
    //}else{
    //    brTableCell.iconView.image = [UIImage imageWithData:birthday.imageData];
    //}
    
    //set background for the table cell to an image
    UIImage *backgroundImage = (indexPath.row == 0) ? [UIImage imageNamed:@"table-row-background.png"] : [UIImage imageNamed:@"table-row-icing-background.png"];
    brTableCell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
                                                                                                    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Segues
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //this method is invoked for any segue transition from the home screen
    NSString *identifier = segue.identifier;
    NSLog(@"Segue: %@",identifier);
    if([identifier isEqualToString:@"BirthdayDetail"]){
        //First get the data
        NSIndexPath *selectedIndePath = self.tableView.indexPathForSelectedRow;
        BRDBirthday *birthday = [self.fetchedResultsController objectAtIndexPath:selectedIndePath];
        
        BRBirthdayDetailViewController *birthdayDetailViewController = segue.destinationViewController;
        birthdayDetailViewController.birthday = birthday;
    }else if([identifier isEqualToString:@"AddBirthday"]){
        //Add a new birthday dictionary to the array of birthdays
        NSManagedObjectContext *context = [BRDModel sharedInstance].managedObjectContext;
        BRDBirthday *birthday = [NSEntityDescription insertNewObjectForEntityForName:@"BRDBirthday" inManagedObjectContext:context];
        [birthday updateWithDefaults];
        
        UINavigationController *navigationController = segue.destinationViewController;
        
        BRBirthdayEditViewController *birthdayEditViewController = (BRBirthdayEditViewController *) navigationController.topViewController;
        birthdayEditViewController.birthday = birthday;
    }
}

#pragma mark Fetched Results Controller to keep track of the Core Data BRDBirthday managed objects

-(NSFetchedResultsController *)fetchedResultsController{
    
    if(_fetchedResultsController==nil){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //access the single managed object context through model singleton
        NSManagedObjectContext *context = [BRDModel sharedInstance].managedObjectContext;
        
        //fetch request requires entity description - we're only interested in BRDBirthday managed objects
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BRDBirthday" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        //auto-generated block
        // Specify criteria for filtering which objects to fetch
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"format string", arguments];
        //[fetchRequest setPredicate:predicate];
        
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nextBirthday"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController.delegate = self;
        
        
        NSError *error = nil;
        
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _fetchedResultsController;
}

#pragma mark NSFetchedResultsControllerDelegate

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //the fetched results changed
}

- (IBAction)importFromAddressBookTapped:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportAddressBook"];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)importFromFacebookTapped:(id)sender {
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ImportFacebook"];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}
@end
