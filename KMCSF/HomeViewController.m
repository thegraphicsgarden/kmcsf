//
//  HomeViewController.m
//  KMC
//
//  Created by Jason Bryant on 9/7/14.
//  Copyright (c) 2014 Jason Bryant. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    NSMutableArray *homeItemsArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UITableView *homeTable;

@end

@implementation HomeViewController {
    NSDictionary *menuItemDetails;
    NSArray *menuItemNames;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.homeTable.rowHeight = 61;
    self.homeTable.alwaysBounceVertical = NO;
    self.homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.homeTable setBackgroundColor:[UIColor clearColor]];
    homeItemsArray = [[NSMutableArray alloc] init];
    
    HomeItem *menuItem = [[HomeItem alloc] init];
    menuItem.title = @"Upcoming Classes/Retreats";
    menuItem.subtitle = @"Find a Solution";
    menuItem.imageName = @"Calendar";
    menuItem.bkgColor = [UIColor colorWithRed: 216.0/255.0 green: 243.0/255.0 blue: 1.0 alpha: .6];
    [homeItemsArray addObject:menuItem];
    
    menuItem = [[HomeItem alloc] init];
    menuItem.title = @"Inspirational Quotes";
    menuItem.subtitle = @"True Wisdom";
    menuItem.imageName = @"Quotes";
    menuItem.bkgColor = [UIColor colorWithRed: 140.0/255.0 green: 221.0/255.0 blue: 1.0 alpha: .6];
    [homeItemsArray addObject:menuItem];
    
    menuItem = [[HomeItem alloc] init];
    menuItem.title = @"Good Advice";
    menuItem.subtitle = @"Wise Words for Any Problem";
    menuItem.imageName = @"Advice";
    menuItem.bkgColor = [UIColor colorWithRed: 0 green: 179.0/255.0 blue: 1.0 alpha: .6];
    [homeItemsArray addObject:menuItem];
    
    menuItem = [[HomeItem alloc] init];
    menuItem.title = @"Meditation Timer";
    menuItem.subtitle = @"Be the Solution";
    menuItem.imageName = @"Timer";
    menuItem.bkgColor = [UIColor colorWithRed: 0 green: 141.0/255.0 blue: 201.0/255.0 alpha: .6];
    [homeItemsArray addObject:menuItem];
    
    //Load Bkg
    UIImage *image = [UIImage imageNamed:@"sf"];
    [self.homeImage setImage:image];
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    [self.logo setImage:logoImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return homeItemsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Retrieve Image
    HomeItem *current = [homeItemsArray objectAtIndex:indexPath.row];
    UIImage *myImage = [UIImage imageNamed: [current imageName] ];
    [cell.imageView setImage:myImage];
    
    cell.textLabel.text = [current title];
    cell.detailTextLabel.text = [current subtitle];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = [current bkgColor];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*NSString *segueIdentifier = @"quotes";//or whatever logic you need to determined the appropriate identifier
    id sender = self;//or whatever object you want to be the sender
    [self performSegueWithIdentifier:segueIdentifier sender:sender];*/
    
    switch (indexPath.row) {
        case 0: [self performSegueWithIdentifier:@"upcomingClasses" sender:self]; break;
        case 1: [self performSegueWithIdentifier:@"quotes" sender:self]; break;
        case 2: [self performSegueWithIdentifier:@"goodAdvice" sender:self]; break;
        case 3: [self performSegueWithIdentifier:@"meditationTimer" sender:self]; break;
        default: break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"quotes"]) {
        //preparation
        QuoteViewController *destViewController = segue.destinationViewController;
    } else if ([[segue identifier] isEqualToString:@"meditationTimer"]) {
        //other preparation
        QuoteViewController *destViewController = segue.destinationViewController;
    }
}
*/

@end
