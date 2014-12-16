//
//  CustomSubtitleCell.h
//  KMCSF
//
//  Created by Jason Bryant on 12/13/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Display.h"

@interface CustomSubtitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
