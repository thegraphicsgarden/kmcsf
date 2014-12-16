//
//  MeditationViewController.h
//  KMCSF
//
//  Created by Jason Bryant on 12/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Display.h"

@interface MeditationViewController : UIViewController {

    NSTimer *timer;

    //to play chime when finished meditating
    SystemSoundID PlaySoundID;
}

@end
