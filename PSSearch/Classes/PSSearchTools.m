//
//  PSSearchTools.m
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import "PSSearchTools.h"
#import "PSSearchEntity.h"

@implementation PSSearchTools

+ (BOOL)isChinese:(NSString *)string {
	NSString *match = @"(^[\u4e00-\u9fa5]+$)";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
	return [predicate evaluateWithObject:string];
}
	
+ (BOOL)includeChinese:(NSString *)string {
	for (int i=0; i< [string length];i++) {
		int a =[string characterAtIndex:i];
		if ( a >0x4e00&& a <0x9fff){
			return YES;
		}
	}
	return NO;
}


+ (NSString *)transform2Pinyin:(NSString *)str {
	
	if (!str || !str.length) {
		return nil;
	}
	
	if (![self isChineseFirst:str] && ![self isEnglishFirst:str]) {
		return str;
	}
	
	NSMutableString *english = [str mutableCopy];
	// 先转换为带声调的拼音
	CFStringTransform((__bridge CFMutableStringRef)english, NULL, kCFStringTransformMandarinLatin, NO);
	// 去掉重音和变音符号
	CFStringTransform((__bridge CFMutableStringRef)english, NULL, kCFStringTransformStripCombiningMarks, NO);
	//去除两端空格和回车 中间空格不用去，用以区分不同汉字
	[english stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// 统一使用小写
	return [english lowercaseString];
}

+ (BOOL)isChineseFirst:(NSString *)str {
	if (!self || !str.length) {
		return NO;
	}
	
	int utfCode = 0;
	void *buffer = &utfCode;
	NSRange range = NSMakeRange(0, 1);
	BOOL b = [str getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
	if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)){
		return YES;
	}else{
		return NO;
	}
}

+ (BOOL)isEnglishFirst:(NSString *)str {
	
	if (!self || !str.length) {
		return NO;
	}
	
	NSString *firstString = [str substringToIndex:1];
	NSString *regular = @"^[A-Za-z]+$";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
	
	return [predicate evaluateWithObject:firstString];
}

	
+ (NSString *)firstCharactor:(NSString *)aString withFormat:(HanyuPinyinOutputFormat *)pinyinFormat {
	NSString *pinYin = [PinyinHelper toHanyuPinyinStringWithNSString:aString withHanyuPinyinOutputFormat:pinyinFormat withNSString:@""];
	return [pinYin substringToIndex:1];
}
	
	// 获取格式化器
+ (HanyuPinyinOutputFormat *)getOutputFormat {
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

+ (BOOL)isEnglishCharactersWithString:(NSString *)string {
	
	if (!string) {
		return NO;
	}
	
	for (int i=0; i<string.length; i++) {
		NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
		NSString *regular = @"^[A-Za-z]+$";
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
		if (![predicate evaluateWithObject:s]) {
			return NO;
		}
	}
	return YES;
}
	
+ (NSArray *)sortingRules {
	// 按照 matchType 顺序排列，即优先展示 中文，其次是全拼匹配，最后是拼音首字母匹配
	NSSortDescriptor *desType = [NSSortDescriptor sortDescriptorWithKey:@"matchType" ascending:YES];
	// 优先显示 高亮位置索引靠前的搜索结果
	NSSortDescriptor *desLocation = [NSSortDescriptor sortDescriptorWithKey:@"highlightLoaction" ascending:YES];
	return @[desType,desLocation];
}
	
@end

