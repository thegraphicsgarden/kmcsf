//
//  ClassItem.h
//  KMCSF
//
//  Created by Jason Bryant on 11/29/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassItem : NSObject

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *title;
//@property (nonatomic) NSString *description;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;

@property (nonatomic) BOOL isToday;
@property (nonatomic) BOOL isTomorrow;

@end
