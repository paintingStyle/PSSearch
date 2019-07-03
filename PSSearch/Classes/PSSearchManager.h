//
//  PSSearchManager.h
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import <Foundation/Foundation.h>
@class PSSearchEntity;

typedef NS_ENUM(NSUInteger, MatchType) {
	
	MatchTypeChinese,  // 中文完全匹配
	MatchTypeComplate, // 拼音全拼匹配
	MatchTypeInitial,  // 拼音简拼匹配
};

NS_ASSUME_NONNULL_BEGIN

@interface PSSearchResult : NSObject

/** 高亮范围 */
@property (nonatomic, assign) NSRange highlightedRange;
/** 匹配类型 */
@property (nonatomic, assign) MatchType matchType;

@end

@interface PSSearchManager : NSObject

/** 添加解析的单个数据源,id标识符是为了防止重名 */
- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier;
- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier index:(NSInteger)index;
	
/** 获取已解析的数据源 */
- (NSArray *)getInitializedDataSource;

/**
 搜索数据
 
 @param keyWord 关键字
 @param searchEntity 搜索实例
 @return PSSearchResult
 */
- (PSSearchResult *)searchResultWithKeyWord:(NSString *)keyWord
							   searchEntity:(PSSearchEntity *)searchEntity;

/**
 搜索数据(是否区分大小写)

 @param keyWord 关键字
 @param searchEntity 搜索实例
 @param caseSensitive 是否区分大小写
 @return PSSearchResult
 */
- (PSSearchResult *)searchResultWithKeyWord:(NSString *)keyWord
							   searchEntity:(PSSearchEntity *)searchEntity
							  caseSensitive:(BOOL)caseSensitive;

@end

NS_ASSUME_NONNULL_END
