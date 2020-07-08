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

/// 是否区分大小写
@property (nonatomic, assign) BOOL caseSensitive;

/** 添加解析的单个数据源,id标识符是为了防止重名 */
- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier;
- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier index:(NSInteger)index;

/** 如果搜索数据源发生改变，需要移除旧的数据源 */
- (void)removeFormIdentifer:(NSString *)identifier;
- (void)removeAllObjects;

/** 获取已解析的数据源 */
- (NSArray *)getInitializedDataSource;

/** 追加需要处理读音与本身读音不同的特殊字符键值对，@{@"pinyin":@"vaule"} */
- (void)appendingFixPinYinMappings:(NSDictionary *)mappings;

/**
 搜索数据
 
 @param keyWord 关键字
 @param searchEntity 搜索实例
 @return PSSearchResult
 */
- (PSSearchResult *)searchResultWithKeyWord:(NSString *)keyWord
                               searchEntity:(PSSearchEntity *)searchEntity;

@end

NS_ASSUME_NONNULL_END
