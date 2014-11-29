//
//  ColorPalette.m
//  KMCSF
//
//  Created by Jason Bryant on 9/16/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette 

-(id)init
{
    self = [super init];
    if (self) {
        _themeBlue = [UIColor colorWithRed: 0 green: 179.0/255.0 blue: 1.0 alpha: 1];
        _buttonBlue = [UIColor colorWithRed: 0 green: 141.0/255.0 blue: 201.0/255.0 alpha: .73];
        _buttonBlack = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: .73];
        
        _menuBlue0 = [UIColor colorWithRed: 216.0/255.0 green: 243.0/255.0 blue: 1.0 alpha: 1]; //.6
        _menuBlue1 = [UIColor colorWithRed: 140.0/255.0 green: 221.0/255.0 blue: 1.0 alpha: 1];
        _menuBlue2 = [UIColor colorWithRed: 0 green: 179.0/255.0 blue: 1.0 alpha: 1];
        _menuBlue3 = [UIColor colorWithRed: 0 green: 141.0/255.0 blue: 201.0/255.0 alpha: 1];
    }
    return self;
}
@end