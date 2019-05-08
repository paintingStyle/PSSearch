//
//  PSSearchTools.h
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import <Foundation/Foundation.h>
#import "PinYin4Objc.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSSearchTools : NSObject

/** 判断传入的字符串是否是纯中文 */
+ (BOOL)isChinese:(NSString *)string;
/** 判断传入的字符串是否包含英文 */
+ (BOOL)includeChinese:(NSString *)string;
/** 获取传入字符串的第一个拼音字母 */
+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat;
	
/** 获取格式化器 */
+ (HanyuPinyinOutputFormat *)getOutputFormat;
/** 是为英文字符串 */
+ (BOOL)isEnglishCharactersWithString:(NSString *)string;

/** 排序规则 */
+ (NSArray *)sortingRules;
	
@end

NS_ASSUME_NONNULL_END
