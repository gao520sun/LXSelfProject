//
//  LXMediator+LXNetwork_Home.m
//  LXMySelf
//
//  Created by qijia on 16/9/12.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXMediator+LXNetwork_Home.h"
#define NetworkHome @"Network_Home"
#define home @"home"
@implementation LXMediator (LXNetwork_Home)

-(id)LXNetwork_home:(NSDictionary *)params success:(void(^)(id responseObject))success failed:(void(^)(NSError *error))failed {
       id  task= [self performTarget:NetworkHome
                              action:home
                              params:@{@"params":@{@"userId":@"1d25641272864b0d9d40c0d10e886d1f"},
                                       @"url":@"http://qafjzl.haoyisheng.com/hys-mgp/app/fd/fmSign/signApply",
                                       @"success":success,
                                       @"failed":failed}];
    
    return task;
}


@end
