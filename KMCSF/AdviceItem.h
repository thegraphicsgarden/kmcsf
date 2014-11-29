//
//  AdviceItem.h
//  KMCSF
//
//  Created by Jason Bryant on 9/14/14.
//  Copyright (c) 2014 The Graphics Garden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"

@interface AdviceItem : NSObject

@property (nonatomic) NSString *delusion;
@property (nonatomic) NSMutableArray *synonyms;
@property (nonatomic) NSMutableArray *quotes;
@property (nonatomic) UIColor *bkgColor;

@end
