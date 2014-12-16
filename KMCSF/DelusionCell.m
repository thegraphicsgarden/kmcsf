//
//  DelusionCell.m
//  KMCSF
//
//  Created by Jason Bryant on 12/12/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import "DelusionCell.h"

@implementation DelusionCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.delusionLabel.textColor = [UIColor whiteColor];
    [Display setTableCellFont:self.delusionLabel withFont:@"MuseoSans-900"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
