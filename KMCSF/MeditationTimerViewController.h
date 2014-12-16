//
//  MeditationTimerViewController.h
//  KMCSF
//
//  Created by Jason Bryant on 9/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MeditationTimerViewController : UIViewController
{
    NSTimer *countdownTimer;
    int secondsCount;
    
    NSDate *userTimeChosen;
    
    //manage timer
    BOOL isRunning;
    BOOL wasPaused;
    
    //to play chime when finished meditating
    SystemSoundID PlaySoundID;
}

@end
