//
//  PSSearchEntity.h
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import <Foundation/Foundation.h>
#import "PSSearchTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface PSSearchEntity : NSObject

/** 唯一标识符 */
@property (nonatomic, copy) NSString *identifier;
/** 搜索索引 */
@property (nonatomic, assign) NSInteger index;
/** 人物名称，如：张飞 */
@property (nonatomic, copy) NSString *name;
/** 拼音全拼（小写）如：@"zhangfei" */
@property (nonatomic, copy) NSString *completeSpelling;
/** 拼音首字母（小写）如：@"zf" */
@property (nonatomic, copy) NSString *initialString;

/**
 拼音全拼（小写）位置，如：@"0,0,0,0,1,1,1,1,2,2,2"
 w a n g p e n g f e i
 */
@property (nonatomic, copy) NSString *pinyinLocationString;
/** 拼音首字母拼音（小写）数组字符串位置，如@"0,1,2" */
@property (nonatomic, copy) NSString *initialLocationString;
/** 高亮位置 */
@property (nonatomic, assign) NSInteger highlightLoaction;
/** 关键字范围 */
@property (nonatomic, assign) NSRange textRange;
/** 匹配类型 */
@property (nonatomic, assign) NSInteger matchType;


// 以下四个属性为多音字的适配，暂时只支持双多音字
/** 是否包含多音字 */
@property (nonatomic, assign) BOOL isContainPolyPhone;
/** 第二个多音字 拼音全拼（小写） */
@property (nonatomic, copy) NSString *polyPhoneCompleteSpelling;
/** 第二个多音字 拼音首字母（小写）*/
@property (nonatomic, copy) NSString *polyPhoneInitialString;
/** 第二个多音字 拼音全拼（小写）位置 */
@property (nonatomic, copy) NSString *polyPhonePinyinLocationString;
/** 第二个多音字 拼音首字母拼音（小写）数组字符串位置 */

+ (instancetype)searchEntityWithIdentifier:(NSString *)identifier
								   andName:(NSString *)name
				adnHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat;
	
@end

NS_ASSUME_NONNULL_END
