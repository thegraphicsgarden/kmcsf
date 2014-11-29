//
//  QuoteViewController.m
//  KMC
//
//  Created by Jason Bryant on 9/7/14.
//  Copyright (c) 2014 Jason Bryant. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController () {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *quoteImage;
@property (weak, nonatomic) IBOutlet UITableView *quoteTable;
@property (weak, nonatomic) IBOutlet UILabel *inspirationQuote;

@end

@implementation QuoteViewController {
    NSMutableArray *quoteArray;
    NSDictionary *quoteDetails;
    NSArray *quoteDates;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.quoteTable.rowHeight = 61;
    self.quoteTable.alwaysBounceVertical = NO;
    self.quoteTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupMenuData];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Quotes" withExtension:@"plist"];
    //load the plist into the dictionary
    quoteDetails = [NSDictionary dictionaryWithContentsOfURL:url];
    //create an array with just the keys
    quoteDates = quoteDetails.allKeys;

    //Load Today's Quote
    self.inspirationQuote.textColor = [UIColor whiteColor];
    self.inspirationQuote.text = @"Select a topic below to find good advice for difficult circumstances.";
    self.inspirationQuote.numberOfLines = 0;
    self.inspirationQuote.frame = CGRectMake(20,20,200,800);
    [self.inspirationQuote sizeToFit];
    
    //Load Bkg
    UIImage *image = [UIImage imageNamed:@"laughing"];
    [self.quoteImage setImage:image];
    
}
-(void)setupMenuData {
    //Load and style the adviceArray with JSON file
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Inspirations" ofType:@"json"];
    NSDictionary* inspirationsDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                                 options:kNilOptions
                                                                   error:&err];
    
    ColorPalette *palette = [[ColorPalette alloc] init];
    quoteArray = [[NSMutableArray alloc] init];
    QuoteItem *menuItem = [[QuoteItem alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    NSInteger colorCt = 0;
    for(NSDictionary *theQuote in inspirationsDic) {
        menuItem = [[QuoteItem alloc] init];
        menuItem.date = [dateFormatter dateFromString: theQuote[@"date"]];
        menuItem.quote = theQuote[@"quote"];
        menuItem.author = theQuote[@"author"];
        menuItem.text = theQuote[@"text"];
        //NSLog(@"%@",menuItem.date);
        switch(colorCt%4){
            case 0: menuItem.bkgColor = palette.menuBlue0; break;
            case 1: menuItem.bkgColor = palette.menuBlue1; break;
            case 2: menuItem.bkgColor = palette.menuBlue2; break;
            case 3: menuItem.bkgColor = palette.menuBlue3; break;
            default: menuItem.bkgColor = palette.menuBlue0; break;
        }
        colorCt++;
        [quoteArray addObject:menuItem];
    }
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
    return quoteDetails.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"quoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
    
    //Retrieve Image
    //UIImage *myImage = [UIImage imageNamed:@"Quotes"];
    //[cell.imageView setImage:myImage];
    
    QuoteItem *current = [quoteArray objectAtIndex:indexPath.row];
    NSComparisonResult dateComparison = [[NSDate date] compare:[current date] ];
    //NSLog(@"%d",dateComparison);
    if(dateComparison==NSOrderedSame) {
        cell.textLabel.text = @"Today";
    } else {
        cell.textLabel.text = [dateFormatter stringFromDate:[current date]];
    }
    cell.detailTextLabel.text = [current quote];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [current bkgColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.curIndexPath = indexPath;
    QuoteItem *current = [quoteArray objectAtIndex:indexPath.row];

    self.inspirationQuote.text = [NSString stringWithFormat:@"%@", [current quote]];
    //self.adviceTitle.text = [NSString stringWithFormat:@"Good Advice for %@", current.delusion];
    
    //NSLog(@"%d", wasSeen);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
