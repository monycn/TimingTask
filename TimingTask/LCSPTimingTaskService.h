//
//  LCSPTimingTaskService.h
//  Base_Tool_Lib
//
//  Created by Mony on 2017/5/3.
//  Copyright © 2017年 LCSP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LCSPTimingTaskSecondType) {
    LCSPTimingTaskSecondTypeOne,
    LCSPTimingTaskSecondTypeTwo,
    LCSPTimingTaskSecondTypeThree,
    LCSPTimingTaskSecondTypeFive,
    LCSPTimingTaskSecondTypeTen,
    LCSPTimingTaskSecondTypeFifteen,
};

@interface LCSPTimingTaskService : NSObject

+ (LCSPTimingTaskService *)service;
- (NSInteger)addGlobalFunctionQueueType:(LCSPTimingTaskSecondType)type parent:(id)parentObj selectorName:(NSString *)selectorName withObj:(id)obj;
- (void)deleteGlobalWithGlobalId:(NSInteger)globalId;
- (void)addGlobalFunctionQueueType:(LCSPTimingTaskSecondType)type parent:(id)parentObj identification:(NSString *)identification selectorName:(NSString *)selectorName withObj:(id)obj;
- (void)deleteGlobalWithIdentification:(NSString *)identification;

@end
