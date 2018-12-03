//
//  LCSPTimingTaskService.m
//  Base_Tool_Lib
//
//  Created by Mony on 2017/5/3.
//  Copyright © 2017年 LCSP. All rights reserved.
//

#import "LCSPTimingTaskService.h"

@interface LCSPTimingTaskService()

@property (strong, nonatomic) NSTimer *globalTimer;
@property (strong, nonatomic) NSMutableArray *oneSecondArr;
@property (strong, nonatomic) NSMutableArray *twoSecondsArr;
@property (strong, nonatomic) NSMutableArray *threeSecondsArr;
@property (strong, nonatomic) NSMutableArray *fiveSecondsArr;
@property (strong, nonatomic) NSMutableArray *tenSecondsArr;
@property (strong, nonatomic) NSMutableArray *fifteenSecondsArr;
@property (strong, nonatomic) NSMutableArray *globalIdArr;
@property (strong, nonatomic) NSMutableDictionary *globalDic;

@end

@implementation LCSPTimingTaskService

- (instancetype)init {
    return [[self class] service];
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        self.oneSecondArr = [NSMutableArray array];
        self.twoSecondsArr = [NSMutableArray array];
        self.threeSecondsArr = [NSMutableArray array];
        self.fiveSecondsArr = [NSMutableArray array];
        self.tenSecondsArr = [NSMutableArray array];
        self.fifteenSecondsArr = [NSMutableArray array];
        self.globalIdArr = [NSMutableArray array];
        self.globalDic = [NSMutableDictionary dictionary];
        [self createTimer];
    }
    return self;
}

+ (LCSPTimingTaskService *)service {
    static LCSPTimingTaskService *serviceObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceObj = [[LCSPTimingTaskService alloc] initPrivate];
    });
    return serviceObj;
}

- (NSInteger)addGlobalFunctionQueueType:(LCSPTimingTaskSecondType)type parent:(id)parentObj selectorName:(NSString *)selectorName withObj:(id)obj {
    if (selectorName == nil || [selectorName isEqualToString:@""]) {
        return -1;
    }
    if (parentObj == nil) {
        return -1;
    }
    if (obj == nil) {
        return -1;
    }
    [self timerStop];
    static NSInteger globalId = 0;
    globalId++;
    switch (type) {
        case LCSPTimingTaskSecondTypeOne:
            [self.oneSecondArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        case LCSPTimingTaskSecondTypeTwo:
            [self.twoSecondsArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        case LCSPTimingTaskSecondTypeThree:
            [self.threeSecondsArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        case LCSPTimingTaskSecondTypeFive:
            [self.fiveSecondsArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        case LCSPTimingTaskSecondTypeTen:
            [self.tenSecondsArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        case LCSPTimingTaskSecondTypeFifteen:
            [self.fifteenSecondsArr addObject:@{@"globalId":@(globalId),@"parentObj":parentObj,@"selector":selectorName,@"obj":obj}];
            break;
        default:
            break;
    }
    [self.globalIdArr addObject:@{@"globalId":@(globalId),@"type":@(type)}];
    [self timerResum];
    return globalId;
}

- (void)deleteGlobalWithGlobalId:(NSInteger)globalId {
    [self timerStop];
    NSDictionary *dic = nil;
    for (int i = 0; i < self.globalIdArr.count; i++) {
        dic = self.globalIdArr[i];
        NSInteger number = [dic[@"globalId"] integerValue];
        if (number == globalId) {
            break;
        }
    }
    LCSPTimingTaskSecondType type = [dic[@"type"] integerValue];
    switch (type) {
        case LCSPTimingTaskSecondTypeOne:
            [self deleteSelectorObjWithGlobalId:globalId array:self.oneSecondArr];
            break;
        case LCSPTimingTaskSecondTypeTwo:
            [self deleteSelectorObjWithGlobalId:globalId array:self.twoSecondsArr];
            break;
        case LCSPTimingTaskSecondTypeThree:
            [self deleteSelectorObjWithGlobalId:globalId array:self.threeSecondsArr];
            break;
        case LCSPTimingTaskSecondTypeFive:
            [self deleteSelectorObjWithGlobalId:globalId array:self.fiveSecondsArr];
            break;
        case LCSPTimingTaskSecondTypeTen:
            [self deleteSelectorObjWithGlobalId:globalId array:self.tenSecondsArr];
            break;
        case LCSPTimingTaskSecondTypeFifteen:
            [self deleteSelectorObjWithGlobalId:globalId array:self.fifteenSecondsArr];
            break;
        default:
            break;
    }
}

- (void)addGlobalFunctionQueueType:(LCSPTimingTaskSecondType)type parent:(id)parentObj identification:(NSString *)identification selectorName:(NSString *)selectorName withObj:(id)obj {
    if (identification == nil || identification.length <= 0) {
        NSAssert(false, @"identification must set");
    }
    NSInteger globalId = [self addGlobalFunctionQueueType:type parent:parentObj selectorName:selectorName withObj:obj];
    if ([self.globalDic valueForKey:identification]) {
        [self deleteGlobalWithIdentification:identification];
    }
    [self.globalDic setValue:@(globalId) forKey:identification];
}

- (void)deleteGlobalWithIdentification:(NSString *)identification {
    if (identification == nil || identification.length <= 0) {
        NSAssert(false, @"identification must set");
    }
    if ([self.globalDic valueForKey:identification] != nil) {
        NSInteger globalId = [[self.globalDic valueForKey:identification] integerValue];
        [self deleteGlobalWithGlobalId:globalId];
    }
}

- (void)createTimer {
    self.globalTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    static int secondNum = 0;
    
    [self oneSecondFunction];
    if (secondNum % 2 == 0) {
        [self twoSecondsFunction];
    }
    if (secondNum % 3 == 0) {
        [self threeSecondsFunction];
    }
    if (secondNum % 5 == 0) {
        [self fiveSecondsFunction];
    }
    if (secondNum % 10 == 0) {
        [self tenSecondsFunction];
    }
    if (secondNum % 15 == 0) {
        [self fifteenSecondsFunction];
    }
    if (secondNum == 30) {
        secondNum = 0;
    }
    secondNum++;
}

- (void)deleteSelectorObjWithGlobalId:(NSInteger)globalId array:(NSMutableArray *)array {
    NSMutableArray *selectorArr = [array copy];
    for (int i = 0; i < selectorArr.count; i++) {
        NSDictionary *dic = selectorArr[i];
        NSInteger number = [dic[@"globalId"] integerValue];
        if (number == globalId) {
            [array removeObject:dic];
            break;
        }
    }
    [self timerResum];
}

- (void)oneSecondFunction {
    for (int i = 0; i < self.oneSecondArr.count; i++) {
        [self excuteSelectorWithDic:self.oneSecondArr[i]];
    }
}

- (void)twoSecondsFunction {
    for (int i = 0; i < self.twoSecondsArr.count; i++) {
        [self excuteSelectorWithDic:self.twoSecondsArr[i]];
    }
}

- (void)threeSecondsFunction {
    for (int i = 0; i < self.threeSecondsArr.count; i++) {
        [self excuteSelectorWithDic:self.threeSecondsArr[i]];
    }
}

- (void)fiveSecondsFunction {
    for (int i = 0; i < self.fiveSecondsArr.count; i++) {
        [self excuteSelectorWithDic:self.fiveSecondsArr[i]];
    }
}

- (void)tenSecondsFunction {
    for (int i = 0; i < self.tenSecondsArr.count; i++) {
        [self excuteSelectorWithDic:self.tenSecondsArr[i]];
    }
}

- (void)fifteenSecondsFunction {
    for (int i = 0; i < self.fifteenSecondsArr.count; i++) {
        [self excuteSelectorWithDic:self.fifteenSecondsArr[i]];
    }
}

- (void)excuteSelectorWithDic:(NSDictionary *)dic {
    id parentObj = dic[@"parentObj"];
    NSString *selectorName = dic[@"selector"];
    id obj = dic[@"obj"];
    if ([parentObj respondsToSelector:NSSelectorFromString(selectorName)]) {
        [parentObj performSelector:NSSelectorFromString(selectorName) withObject:obj];
    }
}

- (void)timerStop {
    [self.globalTimer setFireDate:[NSDate distantFuture]];
}

- (void)timerResum {
    [self.globalTimer setFireDate:[NSDate distantPast]];
}

@end
