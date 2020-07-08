//
//  PSSearchEntity.m
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import "PSSearchEntity.h"

@implementation PSSearchEntity

+ (instancetype)searchEntityWithIdentifier:(NSString *)identifier
								  andName:(NSString *)name
				adnHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)pinyinFormat
							 caseSensitive:(BOOL)caseSensitive {
	
	NSString *nameKey = (caseSensitive ? name:[name lowercaseString]); // 默认不区分大小写，以小写为基准搜索
	PSSearchEntity *searchEntity = [[PSSearchEntity alloc] init];
	
	// 拼音全拼
	NSMutableString *completeSpelling = [[NSMutableString alloc] init];
	NSMutableString *polyPhoneCompleteSpelling;
	
	// 首字母所组成的字符串
	NSString *initialString = @"";
	NSString *polyPhoneInitialString;
	// 全拼拼音数组
	NSMutableArray *completeSpellingArray = [[NSMutableArray alloc] init];
	NSMutableArray *polyPhoneCompleteSpellingArray;
	// 拼音首字母的位置数组
	NSMutableArray *pinyinFirstLetterLocationArray = [[NSMutableArray alloc] init];
	
	for (NSInteger i = 0; i < nameKey.length; i++) {
		NSRange range = NSMakeRange(i, 1);
		NSString *hanyuChar = [nameKey substringWithRange:range];
		NSString *mainPinyinStrOfChar;
		NSString *polyPhonePinyinStrOfChar;
		BOOL isPolyPhoneChar = NO;
		
		/** 将单个汉字转化为拼音的类方法
		 *  name : 需要转换的汉字
		 *  pinyinFormat : 拼音的格式化器
		 *  @"" :  seperator 分隔符
		 */
		NSArray *pinyinStrArrayOfChar = [PinyinHelper getFormattedHanyuPinyinStringArrayWithChar:[nameKey characterAtIndex:i] withHanyuPinyinOutputFormat:pinyinFormat];
		// 获取每个字符所对应的拼音数组，如果包含多音字，则匹配
		if ((nil != pinyinStrArrayOfChar) && ((int) [pinyinStrArrayOfChar count] > 0)) {
			mainPinyinStrOfChar = [pinyinStrArrayOfChar objectAtIndex:0];
			if (pinyinStrArrayOfChar.count > 1) {
				polyPhonePinyinStrOfChar = [pinyinStrArrayOfChar objectAtIndex:1];
				searchEntity.isContainPolyPhone = YES;
				isPolyPhoneChar = YES;
			}
		}
		
		if (nil != mainPinyinStrOfChar) {
			if (searchEntity.isContainPolyPhone) {
				NSString *appendString = isPolyPhoneChar ? polyPhonePinyinStrOfChar : mainPinyinStrOfChar;
				if (polyPhoneCompleteSpelling.length) {
					[polyPhoneCompleteSpelling appendString:appendString];
				} else {
					polyPhoneCompleteSpelling = [NSMutableString stringWithFormat:@"%@%@", completeSpelling, appendString];
				}
			}
			[completeSpelling appendString:mainPinyinStrOfChar];
			// 如果该字符是中文
			if ([PSSearchTools isChinese:hanyuChar]) {
				// 获取该字符的第一个拼音字母，如 wang 的 firstLetter 就是 w
				NSString *firstLetter = [mainPinyinStrOfChar substringToIndex:1];
				
				// 多音字的处理
				if (searchEntity.isContainPolyPhone) {
					// 获取该字符多音字的第一个拼音字母
					NSString *targetStringOfChar = isPolyPhoneChar ? polyPhonePinyinStrOfChar : mainPinyinStrOfChar;
					NSString *targetFirstLetter = [targetStringOfChar substringToIndex:1];
					
					//                NSString *pinyinString = [PinyinHelper toHanyuPinyinStringWithNSString:hanyuChar withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
					/** 获取该 多音字 字符的拼音在整个字符串中的位置 */
					
					for (NSInteger j= 0 ;j < targetStringOfChar.length ; j++) {
						if (!polyPhoneCompleteSpellingArray.count) {
							polyPhoneCompleteSpellingArray = [completeSpellingArray mutableCopy];
						}
						[polyPhoneCompleteSpellingArray addObject:@(i)];
					}
					// 拼接 多音字 首字母字符串
					if (polyPhoneInitialString.length) {
						polyPhoneInitialString = [polyPhoneInitialString stringByAppendingString:targetFirstLetter];
					} else {
						polyPhoneInitialString = [initialString stringByAppendingString:targetFirstLetter];
					}
					
				}
				
				/** 获取该字符的拼音在整个字符串中的位置，如 "wang peng fei"
				 * "wang" 对应的四个拼音字母是 0,0,0,0,
				 * "peng" 对应的四个拼音字母是 1,1,1,1
				 * "fei"  对应的三个拼音字母是 2,2,2
				 */
				for (NSInteger j= 0 ;j < mainPinyinStrOfChar.length ; j++) {
					[completeSpellingArray addObject:@(i)];
				}
				// 拼接首字母字符串，如 "王鹏飞" 对应的首字母字符串就是 "wpf"
				initialString = [initialString stringByAppendingString:firstLetter];
				// 拼接首字母位置字符串，如 "王鹏飞" 对应的首字母位置就是 "0,1,2"
				[pinyinFirstLetterLocationArray addObject:@(i)];
			}
		} else {
			// 如果包含多音字，需要对多音字进行额外处理
			if (searchEntity.isContainPolyPhone) {
				[polyPhoneCompleteSpelling appendFormat:@"%C",[nameKey characterAtIndex:i]];
				[polyPhoneCompleteSpellingArray addObject:@(i)];
				polyPhoneInitialString = [polyPhoneInitialString stringByAppendingString:hanyuChar];
			}
			[completeSpelling appendFormat:@"%C",[nameKey characterAtIndex:i]];
			[completeSpellingArray addObject:@(i)];
			[pinyinFirstLetterLocationArray addObject:@(i)];
			initialString = [initialString stringByAppendingString:hanyuChar];
		}
	}
	
	searchEntity.name = name;
	searchEntity.identifier = identifier;

	if (caseSensitive) {
		searchEntity.completeSpelling = completeSpelling;
		searchEntity.initialString = initialString;
	}else {
		searchEntity.completeSpelling = [completeSpelling lowercaseString];
		searchEntity.initialString = [initialString lowercaseString];
	}
	
	searchEntity.pinyinLocationString = [completeSpellingArray componentsJoinedByString:@","];
	searchEntity.initialLocationString = [pinyinFirstLetterLocationArray componentsJoinedByString:@","];
	if (searchEntity.isContainPolyPhone) {
		if (caseSensitive) {
			searchEntity.polyPhoneCompleteSpelling = polyPhoneCompleteSpelling;
			searchEntity.polyPhoneInitialString = polyPhoneInitialString;
		}else {
			searchEntity.polyPhoneCompleteSpelling = [polyPhoneCompleteSpelling lowercaseString];
			searchEntity.polyPhoneInitialString = [polyPhoneInitialString lowercaseString];
		}
		searchEntity.polyPhonePinyinLocationString = [polyPhoneCompleteSpellingArray componentsJoinedByString:@","];
	}
	
	return searchEntity;
}
	
@end
