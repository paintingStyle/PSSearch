//
//  SPAppDelegate.m
//  PSSearch
//
//  Created by paintingStyle on 05/08/2019.
//  Copyright (c) 2019 paintingStyle. All rights reserved.
//

#import "SPAppDelegate.h"
#import <PinyinHelper.h>
#import <HanyuPinyinOutputFormat.h>

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
//	NSString *name =  @"啊卡卡卡";
//		NSArray *pinyinStrArrayOfChar = [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:[name characterAtIndex:0] withHanyuPinyinOutputFormat:[self getOutputFormat]];
//	
    return YES;
}

- (HanyuPinyinOutputFormat *)getOutputFormat {
    HanyuPinyinOutputFormat *pinyinFormat = [[HanyuPinyinOutputFormat alloc] init];
    /** 设置大小写
     *  CaseTypeLowercase : 小写
     *  CaseTypeUppercase : 大写
     */
    [pinyinFormat setCaseType:CaseTypeLowercase];
    /** 声调格式 ：如 王鹏飞
     * ToneTypeWithToneNumber : 用数字表示声调 wang2 peng2 fei1
     * ToneTypeWithoutTone    : 无声调表示 wang peng fei
     * ToneTypeWithToneMark   : 用字符表示声调 wáng péng fēi
     */
    [pinyinFormat setToneType:ToneTypeWithoutTone];
    /** 设置特殊拼音ü的显示格式：
     * VCharTypeWithUAndColon : 以U和一个冒号表示该拼音，例如：lu:
     * VCharTypeWithV         : 以V表示该字符，例如：lv
     * VCharTypeWithUUnicode  : 以ü表示
     */
    [pinyinFormat setVCharType:VCharTypeWithV];
    return pinyinFormat;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
