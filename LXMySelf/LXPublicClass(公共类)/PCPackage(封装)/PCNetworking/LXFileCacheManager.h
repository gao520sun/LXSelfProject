//
//  LXFileCacheManager.h
//  TCP
//
//  Created by qijia on 16/8/23.
//  Copyright © 2016年 qijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXFileCacheManager : NSObject
+(instancetype)sharedManager;


-(BOOL)saveTempFiles:(NSString *)tempFile url:(NSString *)url;

-(BOOL)saveResumeData:(NSData *)data key:(NSString *)keyUrl;

-(BOOL)deleteResumeDatakey:(NSString *)keyUrl;

-(id)getPlistContent:(NSString *)keyUrl;

-(NSMutableDictionary *)getAllPlistContent;

-(unsigned long long)directorySizeName:(NSString *)keyUrl;

-(BOOL)fileTempExistsAtPath:(NSString *)filePath;

/**
 *  获取所有缓存
 *
 *  @return 返回缓存列表
 */
-(NSArray *)getCacheFiles;


-(NSString *)getFilePath:(NSString *)file;
/**
 *  获取目录下所有子文件
 *
 *  @param directoryName 目录名字
 *
 *  @return 返回列表
 */
-(NSArray*)getCacheDirectory:(NSString *)directoryName;


/**
 *  目录是否存在
 *
 *  @param directoryName 目录名字
 *
 *  @return 是否存在
 */
-(BOOL)directoryIsExist:(NSString *)directoryName;

/**
 *  目录中的文件是否存在
 *
 *  @param directoryName 目录名字
 *  @param fileName      文件名字
 *
 *  @return 是否存在
 */
-(BOOL)directoryFileIsExist:(NSString *)directoryName fileName:(NSString *)fileName;

/**
 *  删除缓存目录
 *
 *  @param directoryName 目录名字
 *
 *  @return 是否删除成功
 */
-(BOOL)deleteDirectory:(NSString *)directoryName;

/**
 *  删除缓存目录文件
 *
 *  @param directoryName 目录名字
 *  @param fileName      文件名字
 *
 *  @return 是否删除成功
 */
-(BOOL)deleteDirectoryFile:(NSString *)directoryName fileName:(NSString *)fileName;

@end
