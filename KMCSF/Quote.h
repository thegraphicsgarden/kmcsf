//
//  Quote.h
//  KMCSF
//
//  Created by Jason Bryant on 11/21/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (nonatomic) NSString *quotation;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *text;
@property (nonatomic) NSMutableArray *relatedDelusions;
@property (nonatomic) NSDate *date;
@property (nonatomic, assign) BOOL seen;

@end
