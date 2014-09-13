//
//  QuoteViewController.m
//  KMC
//
//  Created by Jason Bryant on 9/7/14.
//  Copyright (c) 2014 Jason Bryant. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *quoteImage;
@property (weak, nonatomic) IBOutlet UILabel *quoteText;

@end

@implementation QuoteViewController {
    NSDictionary *quoteDetails;
    NSArray *quoteDates;
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
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Quotes" withExtension:@"plist"];
    //load the plist into the dictionary
    quoteDetails = [NSDictionary dictionaryWithContentsOfURL:url];
    //create an array with just the keys
    quoteDates = quoteDetails.allKeys;

    //Load Today's Quote
    //NSString *contents = [ [self quoteText] text];
    //NSString *message = [NSSTring stringWithFormat:@"Hello, %@", contents];
    //self.quoteText = @"Testing this out";
    [self.quoteText setText: @"Testing"];
    
    //Load Bkg
    UIImage *image = [UIImage imageNamed:@"laughing"];
    [self.quoteImage setImage:image];
    
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
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Retrieve Image
    UIImage *myImage = [UIImage imageNamed:@"Quotes"];
    [cell.imageView setImage:myImage];
    
    cell.textLabel.text = quoteDates[indexPath.row];
    cell.detailTextLabel.text = quoteDetails[quoteDates[indexPath.row]];
    
    return cell;
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
