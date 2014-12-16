//
//  MeditationViewController.m
//  KMCSF
//
//  Created by Jason Bryant on 12/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "MeditationViewController.h"

CGFloat deltaTime = 0;
CGFloat lastUserTime = 0;
CGFloat userStartTime = 0.0;    //minutes
CGFloat minTime = 0.0;          //minutes
CGFloat maxTime = 60.0;         //minutes
CGFloat scrollFactor = 20.0;

CGPoint startLocation;

BOOL countingDown = NO;

@interface MeditationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dharmaWheel;

@property (weak, nonatomic) IBOutlet UIButton *playPause;


@property (strong, nonatomic) NSMutableArray *icons;

@end

@implementation MeditationViewController


/********************************/
/* Setting Timer                */
/********************************/
- (void)updateTimeLabel:(NSInteger)time {
    self.timeLabel.text = [NSString stringWithFormat:@"%d:00",time];
}
- (IBAction)setTimer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    CGFloat percentChange = (startLocation.y - touchLocation.y)/startLocation.y;
    
    userStartTime = scrollFactor*(percentChange) + lastUserTime;
    
    if (userStartTime < minTime ) {
        userStartTime = minTime;
    } else if (userStartTime > maxTime) {
        userStartTime = maxTime;
    }
    [self updateTimeLabel:(NSInteger)userStartTime];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastUserTime = userStartTime;
    UITouch *touch = [[event allTouches] anyObject];
    startLocation = [touch locationInView:self.view];
}

/********************************/
/* Starting/Cancelling Timer    */
/********************************
- (IBAction)cancelTimer:(id)sender {
    countingDown = NO;
    
    NSLog(@"cancelled");
}*/


/********************************/
/* Starting/Cancelling Timer    */
/********************************/
- (void)startTimer {
    NSLog(@"starting");
}
- (void)pauseTimer {
    NSLog(@"paused");
}

- (IBAction)playPauseTimer:(id)sender {
    if(userStartTime > minTime) {
        if(!countingDown) {
            [self startTimer];
        } else {
            [self pauseTimer];
        }
        countingDown = !countingDown;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [Display fadeInView:self.timeLabel toAlpha:1];
    [Display fadeInView:self.dharmaWheel toAlpha:.15];
    self.playPause.hidden = YES;
    [self.icons addObject:self.playPause];
    [Display bottomUpBounceIn:self.playPause];
    /*NSLog(@"%@",NSStringFromCGRect(self.dharmaWheel.frame));
    [self.dharmaWheel setAlpha:1.0];

    NSLog(@"2");
    self.pauseResume.hidden = YES;
    self.icons = [[NSMutableArray alloc] init];
    [self.icons addObject:self.pauseResume];
    
    NSLog(@"3");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGFloat diff = 0.15;
        for(NSUInteger i = 0; i < [self.icons count]; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, diff*i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [[self.icons objectAtIndex:i] setHidden:NO];
                [Display bottomUpBounceIn:[self.icons objectAtIndex:i]];
            });
        }
    });
    NSLog(@"4");*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
