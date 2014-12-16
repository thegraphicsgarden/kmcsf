//
//  Display.m
//  KMCSF
//
//  Created by Jason Bryant on 12/12/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "Display.h"

static CGFloat deviceScreenWidth;

@implementation Display {
    NSInteger _compactWidth;
}

-(id)init {
    self = [super init];
    if(self) {
        //initialize anything here
    }
    return self;
}

//Functions to set fonts and sizes
+(void)setHeaderLabelFont:(UILabel *)label withFont:(NSString *)font {
    deviceScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fontSize = (deviceScreenWidth <= 320) ? 25 : 45;
    [label setFont:[UIFont fontWithName:font size:fontSize]];
}

+(void)setSubHeaderLabelFont:(UILabel *)label withFont:(NSString *)font {
    deviceScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fontSize = (deviceScreenWidth <= 320) ? 20 : 30;
    [label setFont:[UIFont fontWithName:font size:fontSize]];
}
+(void)setBodyLabelFont:(UILabel *)label withFont:(NSString *)font {
    deviceScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fontSize = (deviceScreenWidth <= 320) ? 20 : 35;
    [label setFont:[UIFont fontWithName:font size:fontSize]];
}
+(void)setTableCellFont:(UILabel *)label withFont:(NSString *)font {
    deviceScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat fontSize = (deviceScreenWidth <= 320) ? 14 : 30;
    [label setFont:[UIFont fontWithName:font size:fontSize]];
}
+(NSUInteger)setTableCellHeight {
    deviceScreenWidth = [UIScreen mainScreen].bounds.size.width;
    return (deviceScreenWidth <= 320) ? 50 : 100;
}

/********************************/
/*          Animations          */
/********************************/

//Bounce in Buttons
+ (void)bottomUpBounceIn:(UIView *)btn {
    JNWSpringAnimation *translate = [JNWSpringAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.damping = 30;
    translate.stiffness = 396.89;
    translate.mass = 3.6;
    translate.fromValue = @(600);
    translate.toValue = @(0);
    [btn.layer addAnimation:translate forKey:translate.keyPath];
    btn.hidden = NO;
    btn.transform = CGAffineTransformTranslate(btn.transform, 0, 0);
}

//Bouncing the scales for Labels and Images
+ (void)bounceInViewScale:(UIView *)view {
    /*JNWSpringAnimation *scale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
    scale.damping = 20.0;
    scale.stiffness = 300.0;
    scale.mass = 6.0;
    scale.fromValue = @(0.5);
    scale.toValue = @(1.0);
    [view.layer addAnimation:scale forKey:scale.keyPath];
    view.transform = CGAffineTransformTranslate(view.transform, 1.0, 1.0);*/
    
    POPSpringAnimation *scale = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scale.toValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.2)];
    scale.springBounciness = 20.0f; // Between 0-20
    scale.springSpeed = 1.0f; // Between 0-20
    [view pop_addAnimation:scale forKey:@"scale"];
}
+ (void)bounceOutViewScale:(UIView *)view {
    JNWSpringAnimation *scale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
    scale.damping = 68.78;
    scale.stiffness = 338.62;
    scale.mass = 2.31;
    scale.fromValue = @(1.0);
    scale.toValue = @(0.01);
    [view.layer addAnimation:scale forKey:scale.keyPath];
    view.transform = CGAffineTransformTranslate(view.transform, 0.01, 0.01);
}

// Spin an Image for loading with the dharma wheel graphic
+ (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//Fading IN and OUT for Labels and Images
+(void)fadeInView:(UIView *)view toAlpha:(CGFloat)alpha {
    [view setAlpha:0.0f];
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.alpha = alpha;
                     } completion:NULL];
}
+(void)fadeOutView:(UIView *)view {
    [view setAlpha:1.0f];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.alpha = 0.0f;
                     } completion:NULL];
}

+(void)showMyFonts {
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

@end

