//
//  QuoteViewController.m
//  KMC
//
//  Created by Jason Bryant on 9/7/14.
//  Copyright (c) 2014 Jason Bryant. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController () {
    __block NSMutableArray *inspirationArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *quoteImage;
@property (weak, nonatomic) IBOutlet UILabel *inspirationTitle;
@property (weak, nonatomic) IBOutlet UITableView *quoteTable;
@property (weak, nonatomic) IBOutlet UILabel *inspirationQuote;
@property (weak, nonatomic) IBOutlet UILabel *inspirationDate;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dharmaWheel;

@property (weak, nonatomic) NSIndexPath *curIndexPath;
@property (strong, nonatomic) NSArray *tags;

@end

@implementation QuoteViewController {
    __block NSMutableArray *quoteArray;
    NSDictionary *quoteDetails;
    NSArray *quoteDates;
}

-(NSString *)stripHashtagsFrom:(NSString *)string withTags:(NSArray *)hashTags{
    for(int i = 0; i < [hashTags count]; i++){
        string = [string stringByReplacingOccurrencesOfString:hashTags[i] withString:@""];
    }
    return string;
}
-(NSString *)outputDateString:(QuoteItem *)item {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d"];
    return [NSString stringWithFormat:@"from %@", [dateFormatter stringFromDate:[item date]] ];
}
-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

-(void)fetchFacebookPosts {
    quoteArray = [[NSMutableArray alloc] init];
    
    /* make the API call @"/164313873599055/posts"*/
    //https://www.facebook.com/feeds/page.php?format=json&id=164313873599055
    
    NSString *pageId = @"164313873599055";
    NSString *urlString = [NSString stringWithFormat:@"https://www.facebook.com/feeds/page.php?format=json&id=%@", pageId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.tags = [[NSArray alloc] initWithObjects:@"#meditation", nil];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         QuoteItem *menuItem = [[QuoteItem alloc] init];
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *fbFeed = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:NULL];
             NSMutableArray *entries = [fbFeed objectForKey:@"entries"];
             
             NSString *content, *dateTimeString;
             BOOL initial = YES;
             for(int i = 0; i < [entries count]; i++){
                 content = [self stringByStrippingHTML:[entries[i] objectForKey:@"content"]];
                 if([content rangeOfString:self.tags[0]].location == NSNotFound) {
                     //No posts found with hashtag value
                 } else {
                     menuItem = [[QuoteItem alloc] init];
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                     
                     menuItem.quote = content;
                     
                     dateTimeString = [entries[i] objectForKey:@"published"];
                     dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                     dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];
                     menuItem.date = [dateFormatter dateFromString:dateTimeString];
                     
                     if(initial){
                         self.inspirationQuote.text = [self stripHashtagsFrom:[menuItem quote] withTags:self.tags];
                         self.inspirationDate.text = [self outputDateString:menuItem];
                         initial = NO;
                     }
                     [quoteArray addObject:menuItem];
                 }
             }
             [self.quoteTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
             
             //Fade in labels now that we have the data we need
             [Display fadeInView:self.inspirationTitle toAlpha:1.0];
             [Display fadeInView:self.inspirationDate toAlpha:1.0];
             [Display fadeInView:self.inspirationQuote toAlpha:1.0];
             [Display fadeInView:self.quoteTable toAlpha:1.0];
             
             //Share button appear and compensate by 600 for initial start off of
             self.shareBtn.hidden = NO;
             [Display bottomUpBounceIn:self.shareBtn];
         } else {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry. Could not retrieve quotes. Connection Error." message:@"Try again later." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
             [alertView show];
         }
         //Loaded so hide load wheel
         [Display fadeOutView:self.loadingLabel];
         [Display fadeOutView:self.dharmaWheel];
         [Display bounceOutViewScale:self.loadingLabel];
         [Display bounceOutViewScale:self.dharmaWheel];
         [Display runSpinAnimationOnView:self.dharmaWheel duration:5.0 rotations:.25 repeat:0];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Settting up Header(s)
    [Display setHeaderLabelFont:self.inspirationTitle withFont:@"MuseoSans-900"];
    [Display setSubHeaderLabelFont:self.inspirationDate withFont:@"MuseoSans-700"];
    [Display setBodyLabelFont:self.inspirationQuote withFont:@"MuseoSans-300"];
    [Display setSubHeaderLabelFont:self.loadingLabel withFont:@"MuseoSans-700"];
    
    //Transparent Labels
    [self.inspirationTitle setAlpha:0.0f];
    [self.inspirationDate setAlpha:0.0f];
    [self.inspirationQuote setAlpha:0.0f];
    [self.quoteTable setAlpha:0.0f];
    
    //Show loading wheel
    [self.loadingLabel setAlpha:1.0f];
    [self.dharmaWheel setAlpha:1.0f];
    
    [Display bounceInViewScale:self.loadingLabel];
    [Display bounceInViewScale:self.dharmaWheel];
    
    //Rotate the loading wheel of dharma
    [Display runSpinAnimationOnView:self.dharmaWheel duration:5.0 rotations:.25 repeat:HUGE_VALF];

    //Hide button before loading posts
    self.shareBtn.hidden = YES;
    
    //Make Table bkg transparent
    [self.quoteTable setBackgroundColor:[UIColor clearColor]];
    
    [self fetchFacebookPosts];
}

-(void)setupMenuData {
    //Load and style the adviceArray with JSON file
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Inspirations" ofType:@"json"];
    NSDictionary* inspirationsDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                                 options:kNilOptions
                                                                   error:&err];

    quoteArray = [[NSMutableArray alloc] init];
    QuoteItem *menuItem = [[QuoteItem alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    for(NSDictionary *theQuote in inspirationsDic) {
        menuItem = [[QuoteItem alloc] init];
        menuItem.date = [dateFormatter dateFromString: theQuote[@"date"]];
        menuItem.quote = theQuote[@"quote"];
        menuItem.author = theQuote[@"author"];
        menuItem.text = theQuote[@"text"];
       
        [quoteArray addObject:menuItem];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Social Media Sharing
- (IBAction)shareAction:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@\n\n---\nInspirational Quote from Kadampa Meditation Center San Francisco's iPhone App", self.inspirationQuote.text] ];
        [controller addURL:[NSURL URLWithString:@"https://www.facebook.com/KMCSanFrancisco"]];
        [controller addImage:[UIImage imageNamed:@"logo"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

#pragma mark - Table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return quoteArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Display setTableCellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customSubtitleCell"];
    if(!cell) {
        [self.quoteTable registerNib:[UINib nibWithNibName:@"CustomSubtitleCell"bundle:nil] forCellReuseIdentifier:@"customSubtitleCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"customSubtitleCell"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM dd"];
    
    QuoteItem *current = [quoteArray objectAtIndex:indexPath.row];
    cell.title.text = [current quote];
    cell.subTitle.text = [dateFormatter stringFromDate:[current date]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.curIndexPath = indexPath;
    QuoteItem *current = [quoteArray objectAtIndex:indexPath.row];
    self.inspirationQuote.text = [self stripHashtagsFrom:[current quote] withTags:self.tags ];
    self.inspirationDate.text = [self outputDateString:current];
}

@end
