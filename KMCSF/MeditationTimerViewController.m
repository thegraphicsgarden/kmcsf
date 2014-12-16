//
//  MeditationTimerViewController.m
//  KMCSF
//
//  Created by Jason Bryant on 9/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "MeditationTimerViewController.h"

@interface MeditationTimerViewController () {
    int userChosenTime;
}
@property (weak, nonatomic) IBOutlet UIImageView *dharmaWheel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplay;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIImageView *dial;


@property (weak, nonatomic) IBOutlet UIButton *startCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseResumeBtn;

@end

@implementation MeditationTimerViewController
-(void) timerRun {
    secondsCount = secondsCount - 1;
    
    int seconds = secondsCount % 60;
    int minutes = (secondsCount / 60) % 60;
    int hours = secondsCount / 3600;
    
    NSString *timerOutput = [NSString stringWithFormat:@"%1d:%.2d:%.2d", hours, minutes, seconds];
    self.timeDisplay.text = timerOutput;
    
    if(secondsCount <= 0) {
        [countdownTimer invalidate];
        countdownTimer = nil;
        AudioServicesPlaySystemSound(PlaySoundID);
        isRunning = NO;
        wasPaused = NO;
        [self getAndDisplayTimePickerInfo];
        [self.startCancelBtn setTitle:@"BEGIN" forState:UIControlStateNormal];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Meditation Complete" message:@"Well Done!" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
        [alertView show];
    }
}

-(void) setTimer {
     countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

-(void)getAndDisplayTimePickerInfo {
    NSDate *chosen = [self.timePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"m"];
    NSString *minutes = [formatter stringFromDate:chosen];
    [formatter setDateFormat:@"H"];
    NSString *hours = [formatter stringFromDate:chosen];
    secondsCount = ([minutes intValue]*60) + ([hours intValue]*3600);
    userChosenTime = secondsCount;
    NSString *timerOutput = [NSString stringWithFormat:@"%.1d:%.2d:00", [hours intValue], [minutes intValue] ];
    self.timeDisplay.text = timerOutput;

}
- (IBAction)setTime:(id)sender {
    if(!isRunning) {
        [self getAndDisplayTimePickerInfo];
    }
}
- (IBAction)startCancel:(id)sender {
    if(isRunning ) { //user has hit cancel after hitting start
        [sender setTitle:@"BEGIN" forState:UIControlStateNormal];
        [countdownTimer invalidate];
        secondsCount = userChosenTime;
        [self.pauseResumeBtn setTitle:@"PAUSE" forState:UIControlStateNormal];
        isRunning = NO;
        [self getAndDisplayTimePickerInfo];
    }
    else if(!wasPaused) { //user has hit start and was not paused
        [self setTimer];
        [sender setTitle:@"CANCEL" forState:UIControlStateNormal];
        isRunning = YES;
    }
    else { //user has hit cancel while paused
        [sender setTitle:@"BEGIN" forState:UIControlStateNormal];
        [self.pauseResumeBtn setTitle:@"PAUSE" forState:UIControlStateNormal];
        [self getAndDisplayTimePickerInfo];
        isRunning = NO;
        wasPaused = NO;
    }
}
- (IBAction)pauseResume:(id)sender {
    if(isRunning) { //user has paused
        [sender setTitle:@"RESUME" forState:UIControlStateNormal];
        [countdownTimer invalidate];
        isRunning = NO;
        wasPaused = YES;
    }
    else if(secondsCount != userChosenTime) { //user has resumed
        [sender setTitle:@"PAUSE" forState:UIControlStateNormal];
        [self setTimer];
        isRunning = YES;
        wasPaused = NO;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    self.timeDisplay.hidden = NO;
    
    //Graphics
    self.timePicker.backgroundColor = [UIColor whiteColor];
    
    [self.startCancelBtn setTitle:@"START" forState:UIControlStateNormal];
    [self.pauseResumeBtn setTitle:@"PAUSE" forState:UIControlStateNormal];
    
    self.timeDisplay.textColor = [UIColor whiteColor];
    
    self.timePicker.tintColor = [UIColor whiteColor];
    self.timePicker.backgroundColor = [UIColor clearColor];
    
    self.startCancelBtn.backgroundColor = [UIColor blackColor];
    [self.startCancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.pauseResumeBtn.backgroundColor = [UIColor blackColor];
    [self.pauseResumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bell1" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &PlaySoundID);
    
    secondsCount = 60; //default is one minute
    [self getAndDisplayTimePickerInfo];
    
    isRunning = NO;
    wasPaused = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - picker
/* DID SELECT ROW-ISH?*/
/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
        
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
