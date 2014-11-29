//
//  QuoteItem.h
//  KMCSF
//
//  Created by Jason Bryant on 11/28/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuoteItem : NSObject

@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *quote;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *text;
@property (nonatomic) UIColor *bkgColor;

@end
