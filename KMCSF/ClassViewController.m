//
//  ClassViewController.m
//  KMCSF
//
//  Created by Jason Bryant on 11/29/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)fetchGoogleCalendarEvents {
    //NSURL *url = [NSURL URLWithString:@"http://rest-service.guides.spring.io/greeting"];
    //NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/calendar/v3/calendars/ctg55s18drd0o31tl898kking4/events?key=AIzaSyCLxD6-kNTFihDdlK3AK6-i_rlfDIDUX24"];
    
    NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/calendar/v3/calendars/kadampasf.org_5os4fme6k6m03o1mn6irgk12e0@group.calendar.google.com/events?singleEvents=true&key=AIzaSyCAvx7Ryfq8RFSOf-Lg0eAzMYW3cq4Cqls"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             //NSLog(@"%@", [[greeting objectForKey:@"id"] stringValue]);
             //NSLog(@"%@", [greeting objectForKey:@"content"]);
             NSLog(@"in");
             NSLog(@"%@", greeting);
         }
     }];
    NSLog(@"test");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchGoogleCalendarEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
