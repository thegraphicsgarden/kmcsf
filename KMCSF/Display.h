//
//  Display.h
//  KMCSF
//
//  Created by Jason Bryant on 12/12/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNWSpringAnimation.h"

@interface Display : NSObject

//Set Fonts and Sizes
+(void)setHeaderLabelFont:(UILabel *)label withFont:(NSString *)font;
+(void)setSubHeaderLabelFont:(UILabel *)label withFont:(NSString *)font;
+(void)setBodyLabelFont:(UILabel *)label withFont:(NSString *)font;
+(void)setTableCellFont:(UILabel *)label withFont:(NSString *)font;
+(NSUInteger)setTableCellHeight;


//Animation
+ (void)bottomUpBounceIn:(UIView *)btn;
+ (void)bounceInViewScale:(UIView *)view;
+ (void)bounceOutViewScale:(UIView *)view;
+ (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
+(void)fadeInView:(UIView *)view toAlpha:(CGFloat)alpha;
+(void)fadeOutView:(UIView *)view;

//Check Fonts
+(void)showMyFonts;

@end
