//
//  CustomSubtitleCell.m
//  KMCSF
//
//  Created by Jason Bryant on 12/13/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "CustomSubtitleCell.h"

@implementation CustomSubtitleCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    /*[self.window addConstraint:[NSLayoutConstraint constraintWithItem:self.title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.window attribute:NSLayoutAttributeTop multiplier:10.0 constant:20]];*/
    
    self.title.textColor = [UIColor whiteColor];
    self.title.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subTitle.textColor = [UIColor whiteColor];
    [Display setTableCellFont:self.title withFont:@"MuseoSans-900"];
    [Display setTableCellFont:self.subTitle withFont:@"MuseoSans-500"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
