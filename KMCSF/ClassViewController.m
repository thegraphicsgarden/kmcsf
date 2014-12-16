//
//  ClassViewController.m
//  KMCSF
//
//  Created by Jason Bryant on 11/29/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController () {
    __block NSMutableArray *classArray;
}
@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UILabel *classDateTime;
@property (weak, nonatomic) IBOutlet UITableView *classesTable;
@property (weak, nonatomic) IBOutlet UIButton *directionsBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *classBkgImg;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dharmaWheel;

@property (nonatomic) BOOL classSelected;
@property (strong, nonatomic) NSIndexPath *curIndexPath;
@property (strong, nonatomic) NSMutableArray *icons;

@end

@implementation ClassViewController {
    NSString *shareClassTitle;
    NSString *shareLocation;
    NSString *shareDate;
    NSString *shareStartTime;
    NSString *shareEndTime;
}
#pragma mark - Social Media Sharing
- (IBAction)shareAction:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"Going to Kadampa Meditation Center San Francisco's %@ - %@ to %@ at %@\n---\nJoin Me!\n", shareClassTitle, shareStartTime, shareEndTime, shareLocation]];
        [controller addURL:[NSURL URLWithString:@"http://meditationinsanfrancisco.org/what-expect-class"]];
        [controller addImage:[UIImage imageNamed:@"logo"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)openInMaps:(id)sender {
    shareLocation = [shareLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *addressString = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", shareLocation];
    NSURL *url = [NSURL URLWithString:addressString];
    [[UIApplication sharedApplication] openURL:url];
}

-(BOOL)isDateToday:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [todayString isEqualToString:dateString];
}
-(BOOL)isDateTomorrow:(NSDate *)date {
    NSDate *tomorrow =  [[NSDate date] dateByAddingTimeInterval:60*60*24]; //seconds*minutes*hours in one day
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *tomorrowString = [dateFormatter stringFromDate:tomorrow];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [tomorrowString isEqualToString:dateString];
}

- (void)fetchGoogleCalendarEvents {
    classArray = [[NSMutableArray alloc] init];
    
    //https://www.googleapis.com/calendar/v3/calendars/kadampasf.org_5os4fme6k6m03o1mn6irgk12e0@group.calendar.google.com/events?maxResults=9&singleEvents=true&orderBy=startTime&timeMin=2014-12-03T00:00:00Z&timeMax=2014-12-31T23:59:59Z&key=AIzaSyCAvx7Ryfq8RFSOf-Lg0eAzMYW3cq4Cqls
    
    //Setup URI for Google Calendar API
    NSString *calendarID = @"kadampasf.org_5os4fme6k6m03o1mn6irgk12e0@group.calendar.google.com";
    NSString *key = @"AIzaSyCAvx7Ryfq8RFSOf-Lg0eAzMYW3cq4Cqls";
    NSInteger maxResults = 9;
    NSString *singleEvents = @"true";
    NSString *orderBy = @"startTime";
    
    //Getting today's date and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateToday = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timeToday = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/%@/events?&maxResults=%tu&singleEvents=%@&orderBy=%@&timeMin=%@T%@-08:00&key=%@", calendarID, maxResults, singleEvents, orderBy, dateToday, timeToday, key];
    //NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
    {
        ClassItem *menuItem = [[ClassItem alloc] init];
        if (data.length > 0 && connectionError == nil)
        {
            NSDictionary *classInfo = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
            NSMutableArray *classes = [classInfo objectForKey:@"items"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateTimeString =  @"";
            NSString *tempTitle = @"";
            
             for(int i = 0; i < [classes count]; i++){
                 menuItem = [[ClassItem alloc] init];
                 tempTitle = [classes[i] objectForKey:@"summary"];
                 menuItem.title = [tempTitle stringByReplacingOccurrencesOfString:@"with" withString:@"\nwith"];
                 menuItem.location = [classes[i] objectForKey:@"location"];

                 dateTimeString = [[classes[i] objectForKey:@"start"] objectForKey:@"dateTime"];
                 dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                 dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"-08:00" withString:@""];
                 menuItem.startTime = [dateFormatter dateFromString:dateTimeString];
                 
                 dateTimeString = [[classes[i] objectForKey:@"end"] objectForKey:@"dateTime"];
                 dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                 dateTimeString = [dateTimeString stringByReplacingOccurrencesOfString:@"-08:00" withString:@""];
                 menuItem.endTime = [dateFormatter dateFromString:dateTimeString];
                 
                 menuItem.isToday = [self isDateToday:menuItem.startTime];
                 menuItem.isTomorrow = [self isDateTomorrow:menuItem.startTime];
                 
                 [classArray addObject: menuItem];
             }
            //update the table view with the new data
            [self.classesTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
            [Display fadeInView:self.classTitle toAlpha:1.0];
            [Display fadeInView:self.classDateTime toAlpha:1.0];
            [Display fadeInView:self.classesTable toAlpha:1.0];
        } else {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry. Could not retrieve class information. Connection Error." message:@"Try again later." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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
    
    self.classSelected = NO;
    
    //Set fonts for the labels
    [Display setHeaderLabelFont:self.classTitle withFont:@"MuseoSans-900"];
    [Display setSubHeaderLabelFont:self.classDateTime withFont:@"MuseoSans-700"];
    [Display setSubHeaderLabelFont:self.loadingLabel withFont:@"MuseoSans-700"];
    
    //Set allocate, initiate, and populate icons array with two buttons
    self.icons = [[NSMutableArray alloc] init];
    [self.icons addObject:self.shareBtn];
    [self.icons addObject:self.directionsBtn];
    
    //Set table to transparent background
    [self.classesTable setBackgroundColor:[UIColor clearColor]];
    
    //Transparent Title and Datetime labels
    [self.classTitle setAlpha:0.0f];
    [self.classDateTime setAlpha:0.0f];
    [self.classesTable setAlpha:0.0f];
    
    //Show loading wheel
    [self.loadingLabel setAlpha:1.0f];
    [self.dharmaWheel setAlpha:1.0f];
    
    [Display bounceInViewScale:self.loadingLabel];
    [Display bounceInViewScale:self.dharmaWheel];
    
    //Rotate the loading wheel of dharma
    [Display runSpinAnimationOnView:self.dharmaWheel duration:5.0 rotations:.25 repeat:HUGE_VALF];
    
    //Fetch Google Calendar Events
    [self fetchGoogleCalendarEvents];
    
    self.directionsBtn.hidden = self.shareBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return classArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Display setTableCellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*static NSString *CellIdentifier = @"classCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];*/
    
    CustomSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customSubtitleCell"];
    if(!cell) {
        [self.classesTable registerNib:[UINib nibWithNibName:@"CustomSubtitleCell"bundle:nil] forCellReuseIdentifier:@"customSubtitleCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"customSubtitleCell"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
    
    ClassItem *current = [classArray objectAtIndex:indexPath.row];

    //cell.textLabel.text = @"testing";
    cell.title.text = [NSString stringWithFormat: @"%@", current.title];
    cell.subTitle.text = [NSString stringWithFormat: @"%@", current.location];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!self.classSelected) {
        CGFloat diff = 0.05;
        for(NSUInteger i = 0; i < [self.icons count]; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, diff*i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [Display bottomUpBounceIn:[self.icons objectAtIndex:i]];
            });
        }
        self.classSelected = YES;
    }
    self.curIndexPath = indexPath;
    
    ClassItem *current = [classArray objectAtIndex:indexPath.row];
    
    //Setup and Deliver the Quote, Author, and (if needed) text
    self.classTitle.text = [NSString stringWithFormat:@"%@", [current title]];
    
    //Getting today's date and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *classStart;
    if([current isToday]) {
        [dateFormatter setDateFormat:@"h:mm a"];
        classStart = [dateFormatter stringFromDate:[current startTime]];
        classStart = [NSString stringWithFormat:@"Today at %@", classStart];
        self.classDateTime.text = [NSString stringWithFormat:@"%@ at\n%@", classStart, [current location]];
    } else if([current isTomorrow]) {
        [dateFormatter setDateFormat:@"h:mm a"];
        classStart = [dateFormatter stringFromDate:[current startTime]];
        classStart = [NSString stringWithFormat:@"Tomorrow at %@", classStart];
        self.classDateTime.text = [NSString stringWithFormat:@"%@ at\n%@", classStart, [current location]];
    } else {
        [dateFormatter setDateFormat:@"EEEE, MMMM d 'at' h:mm a"];
        classStart = [dateFormatter stringFromDate:[current startTime]];
        self.classDateTime.text = [NSString stringWithFormat:@"%@ at\n%@", classStart, [current location]];
    }
    shareClassTitle = [current title];
    shareLocation = [current location];
    shareStartTime = classStart;
    
    [dateFormatter setDateFormat:@"h:mm a"];
    shareEndTime = [dateFormatter stringFromDate:[current endTime]];
}

@end
