//
//  GoodAdviceViewController.m
//  KMCSF
//
//  Created by Jason Bryant on 9/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "GoodAdviceViewController.h"

@interface GoodAdviceViewController () {
    NSMutableArray *adviceArray;
    NSString *initialAdviceQuote;
}
@property (weak, nonatomic) IBOutlet UIImageView *adviceBkgImg;
@property (weak, nonatomic) IBOutlet UITableView *adviceTable;
@property (weak, nonatomic) IBOutlet UILabel *adviceQuote;
@property (weak, nonatomic) IBOutlet UILabel *adviceTitle;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (nonatomic) BOOL adviceSelected;
@property (strong, nonatomic) NSIndexPath *curIndexPath;

@end

@implementation GoodAdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adviceSelected = NO;
    self.shareBtn.hidden = YES;
    [Display setHeaderLabelFont:self.adviceTitle withFont:@"MuseoSans-900"];
    [Display setBodyLabelFont:self.adviceQuote withFont:@"MuseoSans-300"];
    [Display fadeInView:self.adviceTitle toAlpha:1.0];
    [Display fadeInView:self.adviceQuote toAlpha:1.0];
    [Display fadeInView:self.adviceTable toAlpha:1.0];
    [Display fadeInView:self.promptLabel toAlpha:1.0];
    
    [self.adviceTable setBackgroundView:nil];
    [self.adviceTable setBackgroundColor:[UIColor clearColor]];
    
    [self setupMenuData];
    
    //Load Quote
    self.adviceQuote.textColor = [UIColor whiteColor];
    self.adviceQuote.text = @"Select a topic below to find good advice for difficult circumstances.";
    self.adviceQuote.numberOfLines = 0;
    self.adviceQuote.frame = CGRectMake(20,20,200,800);
    [self.adviceQuote sizeToFit];
}
-(void)setupMenuData {
    //Load and style the adviceArray with JSON file
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Delusions" ofType:@"json"];
    NSDictionary* delusionsDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                                 options:kNilOptions
                                                                   error:&err];
    
    adviceArray = [[NSMutableArray alloc] init];
    AdviceItem *menuItem = [[AdviceItem alloc] init];
    Quote *curQuote = [[Quote alloc] init];
    
    for (NSDictionary *theDelusion in delusionsDic ) {
        menuItem = [[AdviceItem alloc] init];
        menuItem.delusion = theDelusion[@"delusion"];
        menuItem.synonyms = theDelusion[@"synonyms"];
        menuItem.quotes = [[NSMutableArray alloc] init];
        for(NSDictionary *theQuote in theDelusion[@"quotes"]) {
            curQuote = [[Quote alloc] init];
            curQuote.quotation = theQuote[@"quote"];
            curQuote.author = theQuote[@"author"];
            curQuote.text = theQuote[@"text"];
            curQuote.seen = NO;
            curQuote.relatedDelusions = theQuote[@"related-delusions"];
            [menuItem.quotes addObject:curQuote];
        }
        [adviceArray addObject:menuItem];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Social Media Sharing
- (IBAction)shareAction:(id)sender {
    //NSLog(@"share");
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"%@\n\n---\n %@ from Kadampa Meditation Center San Francisco's iPhone App", self.adviceQuote.text, self.adviceTitle.text] ];
        [controller addURL:[NSURL URLWithString:@"http://meditationinsanfrancisco.org"]];
        [controller addImage:[UIImage imageNamed:@"logo"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}


#pragma mark - Table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return adviceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Display setTableCellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DelusionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"delusionCell"];
    if(!cell) {
        [self.adviceTable registerNib:[UINib nibWithNibName:@"DelusionCell"bundle:nil] forCellReuseIdentifier:@"delusionCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"delusionCell"];
    }
    
    AdviceItem *current = [adviceArray objectAtIndex:indexPath.row];
    cell.delusionLabel.text = [current delusion];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!self.adviceSelected) {
        self.shareBtn.hidden = NO;
        [Display bottomUpBounceIn:self.shareBtn];
        self.adviceSelected = YES;
    }
    self.curIndexPath = indexPath;
    AdviceItem *current = [adviceArray objectAtIndex:self.curIndexPath.row];
    int lowerBound = 0;
    NSUInteger upperBound = [current.quotes count];
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    bool wasSeen = [[[adviceArray objectAtIndex:self.curIndexPath.row] quotes][rndValue] seen];
    
    int seenCt = 0;
    while (wasSeen) {
        rndValue++;
        seenCt++;
        if (rndValue >= [current.quotes count]) rndValue = 0;
        wasSeen = [[[adviceArray objectAtIndex:self.curIndexPath.row] quotes][rndValue] seen];
        if(seenCt == [current.quotes count]) { //reset all quotes as unseen
            for(int i = 0; i < seenCt; i++) {
                [[[adviceArray objectAtIndex:self.curIndexPath.row] quotes][i] setSeen:NO];
            }
        }
    }
    [[[adviceArray objectAtIndex:self.curIndexPath.row] quotes][rndValue] setSeen:YES];
    self.adviceQuote.text = [NSString stringWithFormat:@"%@\n- %@", [current.quotes[rndValue] quotation], [current.quotes[rndValue] author]];
    self.adviceTitle.text = [NSString stringWithFormat:@"Good Advice for %@", current.delusion];
}

#pragma mark - Shake Gesture
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
        //[self showAlert];
        [self changeAdvice];
}
-(IBAction)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello World" message:@"This is my first app!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
    [alertView show];
}
-(void)changeAdvice {
    [self tableView:self.adviceTable didSelectRowAtIndexPath:self.curIndexPath];
}

@end
