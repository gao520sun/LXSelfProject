//
//  LXTarget_Network_Home.m
//  LXMySelf
//
//  Created by qijia on 16/9/12.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXTarget_Network_Home.h"
#import "LXNetworkServiceHelper.h"
@interface LXTarget_Network_Home()
@property (nonatomic,copy) LXRequestSuccess success;
@property (nonatomic,copy) LXRequestFailed failed;
@property (nonatomic,copy) LXProgress prgress;
@property (nonatomic,copy) NSString* url;
@property (nonatomic,strong) NSDictionary* paramsDic;
@end
@implementation LXTarget_Network_Home
-(void)paramsHelper:(NSDictionary *)params{
    self.success   = [params objectForKey:@"success"];
    self.failed    = [params objectForKey:@"failed"];
    self.prgress   = [params objectForKey:@"progress"];
    self.url       = [params objectForKey:@"url"];
    self.paramsDic = [params objectForKey:@"params"];
}

-(id)LXAction_home:(NSDictionary *)params{
    NSURLSessionTask *task = [[LXNetworkServiceHelper sharedManager]lx_serviceWithUrl:self.url params:self.paramsDic modelObject:nil requestType:LX_GET request:self.success progress:self.prgress failed:self.failed];
    
    return task;
}



















@end
