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
@property (weak, nonatomic) IBOutlet UIImageView *homeBkgImg;
@property (weak, nonatomic) IBOutlet UIButton *classesBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *inspirationBtn;
@property (weak, nonatomic) IBOutlet UIButton *adviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *timerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *wheelDetail;

@end

@implementation HomeViewController {
    NSDictionary *menuItemDetails;
    NSArray *menuItemNames;
    BOOL menuAnimated;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)makeMenuItemsReady {
    NSMutableArray *icons = [[NSMutableArray alloc] init];
    
    self.classesBtn.hidden = YES;
    [icons addObject:self.classesBtn];
    self.inspirationBtn.hidden = YES;
    [icons addObject:self.inspirationBtn];
    self.adviceBtn.hidden = YES;
    [icons addObject:self.adviceBtn];
    self.timerBtn.hidden = YES;
    [icons addObject:self.timerBtn];
    
    CGFloat diff = .05;
    for(NSUInteger i = 0; i < [icons count]; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, diff*i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [Display bottomUpBounceIn:[icons objectAtIndex:i]];
        });
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuAnimated = NO;
    [self makeMenuItemsReady];
    menuAnimated = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    menuAnimated = NO;
    [self.logo setAlpha:0.0f];
    [self.wheelDetail setAlpha:0.0];
    self.classesBtn.hidden = self.inspirationBtn.hidden = self.adviceBtn.hidden = self.timerBtn.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [self.logo setAlpha:0.0];
    [self.wheelDetail setAlpha:0.0];
    [Display fadeInView:self.logo toAlpha:1.0];
    [Display fadeInView:self.wheelDetail toAlpha:0.05];
    if(!menuAnimated) {
        [self makeMenuItemsReady];
        menuAnimated = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
