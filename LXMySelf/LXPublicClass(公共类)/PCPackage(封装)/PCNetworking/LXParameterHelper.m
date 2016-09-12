//
//  LXParameterHelper.m
//  TCP
//
//  Created by qijia on 16/8/22.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXParameterHelper.h"

@implementation LXParameterHelper
static LXParameterHelper * parm = NULL;
+(instancetype)parameterHelper{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parm =  [[[self class] alloc] init];
    });
    return parm;
}

-(void)LX_description{
    NSLog(@"网络请求数据类型:\n URL :%@ \n head:%@ \n Parameter: %@ \n method: %d \n",self.url,self.header,self.parameter,self.httpMethod);
}

@end
