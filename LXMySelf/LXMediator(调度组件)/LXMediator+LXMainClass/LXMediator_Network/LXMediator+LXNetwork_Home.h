//
//  LXMediator+LXNetwork_Home.h
//  LXMySelf
//
//  Created by qijia on 16/9/12.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXMediator.h"

@interface LXMediator (LXNetwork_Home)

-(id)LXNetwork_home:(NSDictionary *)params success:(void(^)(id responseObject))success failed:(void(^)(NSError *error))failed;

@end
