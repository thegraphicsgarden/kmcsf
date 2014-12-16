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
NSInteger userStartTimeInMinutes = 0;   //minutes
NSInteger currentTimeInSeconds = 0;     //seconds
NSInteger currentMinutes = 0;
NSInteger currentSeconds = 0;
NSInteger minTime = 0.0;                  //minutes
NSInteger maxTime = 60;                 //minutes
CGFloat scrollFactor = 20.0;

CGPoint startLocation;

BOOL countingDown = NO;

@interface MeditationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dharmaWheel;
@property (weak, nonatomic) IBOutlet UIButton *playPause;
@property (weak, nonatomic) IBOutlet UIButton *cancel;


@property (strong, nonatomic) NSMutableArray *icons;

@end

@implementation MeditationViewController


/********************************/
/* Setting Timer                */
/********************************/
- (void)updateTimeLabelAtStart:(NSInteger)time {
    self.timeLabel.text = [NSString stringWithFormat:@"%zd:00",time];
}
- (IBAction)setTimer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    CGFloat percentChange = (startLocation.y - touchLocation.y)/startLocation.y;
    
    userStartTimeInMinutes = scrollFactor*(percentChange) + lastUserTime;
    
    if (userStartTimeInMinutes < minTime ) {
        userStartTimeInMinutes = minTime;
    } else if (userStartTimeInMinutes > maxTime) {
        userStartTimeInMinutes = maxTime;
    }
    currentTimeInSeconds = 60*userStartTimeInMinutes;
    [self updateTimeLabelAtStart:userStartTimeInMinutes];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    lastUserTime = userStartTimeInMinutes;
    UITouch *touch = [[event allTouches] anyObject];
    startLocation = [touch locationInView:self.view];
}

/********************************/
/* Cancelling Timer             */
/********************************/
- (IBAction)cancelTimer:(id)sender {
    [timer invalidate];
    currentTimeInSeconds = userStartTimeInMinutes = 0.0;;
    [self updateTimeLabelAtStart:currentTimeInSeconds];
    countingDown = NO;
}

/********************************/
/* Starting/Pausing Timer       */
/********************************/
-(void)timeCompleted {
    [timer invalidate];
    AudioServicesPlaySystemSound(PlaySoundID);
    NSString *completeMessage = [NSString stringWithFormat:@"%zd Minute Meditation Complete",userStartTimeInMinutes];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:completeMessage message:@"Well Done!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
    [alertView show];
}
- (void)updateTimeDisplay {
    currentSeconds = currentTimeInSeconds%60;
    currentMinutes = currentTimeInSeconds/60;
    self.timeLabel.text = [NSString stringWithFormat:@"%zd:%.2zd",currentMinutes,currentSeconds];
}
- (void)startTimer {
    currentTimeInSeconds--;
    [self updateTimeDisplay];
    if(currentTimeInSeconds <=0) {
        [self timeCompleted];
    }
}
- (IBAction)playPauseTimer:(id)sender {
    if(userStartTimeInMinutes > minTime) {
        if(!countingDown) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        } else {
            [timer invalidate];
        }
        countingDown = !countingDown;
    }
}

/********************************/
/* View Did Load                */
/********************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [Display fadeInView:self.timeLabel toAlpha:1];
    [Display fadeInView:self.dharmaWheel toAlpha:.15];
    self.playPause.hidden = YES;
    self.cancel.hidden = YES;
    
    self.icons = [[NSMutableArray alloc] init];
    [self.icons addObject:self.playPause];
    [self.icons addObject:self.cancel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGFloat diff = 0.15;
        for(NSUInteger i = 0; i < [self.icons count]; i++) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, diff*i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [[self.icons objectAtIndex:i] setHidden:NO];
                [Display bottomUpBounceIn:[self.icons objectAtIndex:i]];
            });
        }
    });
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bell1" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &PlaySoundID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
