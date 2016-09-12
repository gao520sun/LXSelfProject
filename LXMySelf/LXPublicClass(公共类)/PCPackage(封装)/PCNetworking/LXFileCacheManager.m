//
//  LXFileCacheManager.m
//  TCP
//
//  Created by qijia on 16/8/23.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import "LXFileCacheManager.h"

#define bundleIdentifier ([[NSBundle mainBundle]bundleIdentifier])
#define CacheFileName(fileName) ([NSString stringWithFormat:@"%@-%@",bundleIdentifier,fileName])
//#define CacheFilePath(dict,fileName) ([dict stringByAppendingPathComponent:CacheFileName(fileName)])
#define CacheFilePath(dict,fileName) ([dict stringByAppendingPathComponent:fileName])

#define tempData @"tempData.plist"
@interface LXFileCacheManager(){
     NSString *_cacheDirectory;
    NSString *filename;
}
@end

@implementation LXFileCacheManager

static LXFileCacheManager * file = NULL;
+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        file =  [[[self class] alloc] init];
    });
    return file;
}
-(instancetype)init{
    if(self = [super init]){
        _cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [self creat];
    }
    return self;
}


-(void)creat{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    
    filename=[path stringByAppendingPathComponent:tempData];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filename]){//判断文件是否存在，存在不创建
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    
}

-(BOOL)saveTempFiles:(NSString *)tempFile url:(NSString *)url{
    NSLog(@"temp ..%@",tempFile);
    NSLog(@"url...%@",url);
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if(!dic){
        dic = [[NSMutableDictionary alloc]init];
    }
    [dic setObject:tempFile forKey:url];
    BOOL b = [dic writeToFile:filename atomically:YES];
    return b;
}


-(BOOL)saveResumeData:(NSData *)data key:(NSString *)keyUrl{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if(!dic){
        dic = [[NSMutableDictionary alloc]init];
    }
    [dic setObject:data forKey:keyUrl];
    BOOL b = [dic writeToFile:filename atomically:YES];
    return b;
}

-(BOOL)deleteResumeDatakey:(NSString *)keyUrl{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if([dic.allKeys containsObject:keyUrl]){
        [dic removeObjectForKey:keyUrl];
    }else{
        NSLog(@"plist中没有报存数据");
        return YES;
    }
    BOOL b = [dic writeToFile:filename atomically:YES];
    return b;
}

-(id)getPlistContent:(NSString *)keyUrl{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    return [dic objectForKey:keyUrl];
}

-(NSMutableDictionary *)getAllPlistContent{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    return dic;
}

-(BOOL)fileTempExistsAtPath:(NSString *)filePath{
    BOOL b = [[NSFileManager defaultManager]fileExistsAtPath:filePath];
    return b;
}


#pragma mark 缓存文件操作

/**
 *  返回该应用的所有缓存
 *
 *  @return 缓存列表
 */
-(NSArray *)getCacheFiles{
    NSArray *arr = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:_cacheDirectory error:nil];
//    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:0];
//    if(arr != nil && arr.count > 0){
//        for (NSString *s in arr) {
//            if([s hasPrefix:bundleIdentifier]){
//                [ma addObject:s];
//            }
//        }
//    }
    return arr;
}

-(NSString *)getFilePath:(NSString *)file{
     NSString *pa = [NSString stringWithFormat:@"%@/%@",_cacheDirectory,file];
    return pa;
}

-(NSArray*)getCacheDirectory:(NSString *)directoryName{
    NSMutableArray* array = [NSMutableArray array];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString *pa = [NSString stringWithFormat:@"%@/%@",_cacheDirectory,directoryName];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:pa error:nil];
    
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [pa stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

-(BOOL)directoryIsExist:(NSString *)directoryName{
    if(directoryName == nil || [@""isEqualToString:directoryName]){
        return NO;
    }
    NSString *path = CacheFilePath(_cacheDirectory,directoryName);
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}


-(BOOL)directoryFileIsExist:(NSString *)directoryName fileName:(NSString *)fileName{
    if((directoryName == nil || [@""isEqualToString:directoryName] )&& (fileName == nil || [@""isEqualToString:fileName])  ){
        return NO;
    }
    NSString *df =[NSString stringWithFormat:@"%@/%@",directoryName,fileName];
    NSString *path = CacheFilePath(_cacheDirectory,df);
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

-(BOOL)deleteDirectory:(NSString *)directoryName{
   return [[NSFileManager defaultManager]removeItemAtPath:CacheFilePath(_cacheDirectory,directoryName) error:nil];
}

-(BOOL)deleteDirectoryFile:(NSString *)directoryName fileName:(NSString *)fileName{
    NSString *df =[NSString stringWithFormat:@"%@/%@",directoryName,fileName];
    return [[NSFileManager defaultManager]removeItemAtPath:CacheFilePath(_cacheDirectory,df) error:nil];
}

//获取已下载的文件大小
-(unsigned long long)directorySizeName:(NSString *)keyUrl{
    signed long long fileSize = 0;
    NSData *data = [self getPlistContent:[keyUrl lastPathComponent]];
    fileSize = data.length;
    return fileSize;
}
@end
