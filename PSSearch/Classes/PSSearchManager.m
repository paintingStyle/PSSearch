//
//  PSSearchManager.m
//  PinYin4Objc
//
//  Created by rsf on 2019/5/8.
//

#import "PSSearchManager.h"
#import "PSSearchEntity.h"
#import "PSSearchTools.h"

@implementation PSSearchResult

@end

@interface PSSearchManager ()
    
@property (nonatomic, strong) HanyuPinyinOutputFormat *outputFormat;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *fixPinYinMappings;
    
@end

@implementation PSSearchManager

- (instancetype)init {
    if (self = [super init]) {
        _caseSensitive = NO;
        _fixPinYinMappings =  [NSMutableDictionary dictionaryWithDictionary:@{
                                                                              @"e":@"嗯",
                                                                              @"en":@"嗯", // 嗯这个字用的是后鼻音用ng, ng很不常用，又有很多人不知道所以采取了en的形式
                                                                              }];
    }
    return self;
}

- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier {
    [self addInitializeString:string identifer:identifier index:0];
}

- (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier index:(NSInteger)index {
    
    if ([self existingWithIdentifer:identifier]) { return; } // 过滤重复的identifier
    
    PSSearchEntity *searchEntity = [PSSearchEntity searchEntityWithIdentifier:identifier andName:string adnHanyuPinyinOutputFormat:self.outputFormat caseSensitive:self.caseSensitive];
    searchEntity.index = index;
    [self.dataSource addObject:searchEntity];
}

- (void)removeObjectAtIdentifier:(NSString *)identifier {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"identifier = %@",identifier];
    NSArray *filteredArray = [self.dataSource filteredArrayUsingPredicate:pre];
    for (PSSearchEntity *enity in filteredArray) {
        NSInteger index = [self.dataSource indexOfObject:enity];
        if (index <= self.dataSource.count-1) {
            [self.dataSource removeObjectAtIndex:index];
        }
    }
}

- (void)removeAllObjects {
    
    [self.dataSource removeAllObjects];
}

- (BOOL)existingWithIdentifer:(NSString *)identifer {

    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"identifier == %@", identifer];
    NSArray *array = [self.dataSource filteredArrayUsingPredicate:predicate];
    return array.count;
}

- (NSArray *)getInitializedDataSource {
    return self.dataSource;
}

- (void)appendingFixPinYinMappings:(NSDictionary *)mappings {
    
    [mappings enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *vaule, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [vaule isKindOfClass:[NSString class]]) {
            [self.fixPinYinMappings setObject:vaule forKey:key];
        }
    }];
}

- (PSSearchResult *)searchResultWithKeyWord:(NSString *)keyWord
                               searchEntity:(PSSearchEntity *)searchEntity {
    
    PSSearchResult *resultModel = [self
                                   _searchEffectiveResultWithSearchString:keyWord
                                   nameString:searchEntity.name
                                   completeSpelling:searchEntity.completeSpelling
                                   initialString:searchEntity.initialString
                                   pinyinLocationString:searchEntity.pinyinLocationString
                                   initialLocationString:searchEntity.initialLocationString
                                   caseSensitive:self.caseSensitive];
    
    if (resultModel.highlightedRange.length) {
        return resultModel;
    } else if (searchEntity.isContainPolyPhone) {
        // 如果正常匹配没有对应结果，且该model存在多音字，则尝试多音字匹配
        resultModel = [self
                       _searchEffectiveResultWithSearchString:keyWord
                       nameString:searchEntity.name
                       completeSpelling:searchEntity.polyPhoneCompleteSpelling
                       initialString:searchEntity.polyPhoneInitialString
                       pinyinLocationString:searchEntity.polyPhonePinyinLocationString
                       initialLocationString:searchEntity.initialLocationString
                       caseSensitive:self.caseSensitive];
        if (resultModel.highlightedRange.length) {
            return resultModel;
        }
    }
    return nil;
}

- (PSSearchResult *)_searchEffectiveResultWithSearchString:(NSString *)searchStrLower
                                                nameString:(NSString *)nameStrLower
                                          completeSpelling:(NSString *)completeSpelling
                                             initialString:(NSString *)initialString
                                      pinyinLocationString:(NSString *)pinyinLocationString
                                     initialLocationString:(NSString *)initialLocationString
                                             caseSensitive:(BOOL)caseSensitive {
    
    PSSearchResult *searchResult = [[PSSearchResult alloc] init];
    
    // 若搜索单个和多个字母不区分大小写,这里统一转成小写
    NSString *searchKey = caseSensitive ? searchStrLower:[searchStrLower lowercaseString];
    NSString *nameKey = caseSensitive ? nameStrLower:[nameStrLower lowercaseString];
    
    NSArray *completeSpellingArray = [pinyinLocationString componentsSeparatedByString:@","];
    NSArray *pinyinFirstLetterLocationArray = [initialLocationString componentsSeparatedByString:@","];
    
    // 完全中文匹配范围
    NSRange chineseRange = [nameKey rangeOfString:searchKey];
    // 拼音全拼匹配范围
    NSRange complateRange = [completeSpelling rangeOfString:searchKey];
    // 拼音首字母匹配范围
    NSRange initialRange = [initialString rangeOfString:searchKey];
    
    // 汉字直接匹配
    if (chineseRange.length!=0) {
        searchResult.highlightedRange = chineseRange;
        searchResult.matchType = MatchTypeChinese;
        return searchResult;
    }
    
    NSRange highlightedRange = NSMakeRange(0, 0);
    
    // MARK: 拼音全拼匹配
    if (complateRange.length != 0) {
        if (complateRange.location == 0) {
            // 拼音首字母匹配从0开始，即搜索的关键字与该数据源第一个汉字匹配到，所以高亮范围从0开始
            highlightedRange = NSMakeRange(0, [completeSpellingArray[complateRange.length-1] integerValue] +1);
            
        } else {
            /** 如果该拼音字符是一个汉字的首个字符，如搜索“g”，
             *  就要匹配出“gai”、“ge”等“g”开头的拼音对应的字符，
             *  而不应该匹配到“wang”、“feng”等非”g“开头的拼音对应的字符
             */
            NSInteger currentLocation = [completeSpellingArray[complateRange.location] integerValue];
            NSInteger lastLocation = [completeSpellingArray[complateRange.location-1] integerValue];
            if (currentLocation != lastLocation) {
                // 高亮范围从匹配到的第一个关键字开始
                highlightedRange = NSMakeRange(currentLocation, [completeSpellingArray[complateRange.length+complateRange.location -1] integerValue] - currentLocation +1);
            }
        }
        searchResult.highlightedRange = highlightedRange;
        searchResult.matchType = MatchTypeComplate;
        if (highlightedRange.length!=0) {
            return searchResult;
        }
    }
    
    // MARK: 拼音首字母匹配
    if (initialRange.length!=0) {
        NSInteger currentLocation = [pinyinFirstLetterLocationArray[initialRange.location] integerValue];
        NSInteger highlightedLength;
        if (initialRange.location ==0) {
            highlightedLength = [pinyinFirstLetterLocationArray[initialRange.length-1] integerValue]-currentLocation +1;
            // 拼音首字母匹配从0开始，即搜索的关键字与该数据源第一个汉字匹配到，所以高亮范围从0开始
            highlightedRange = NSMakeRange(0, highlightedLength);
        } else {
            highlightedLength = [pinyinFirstLetterLocationArray[initialRange.length+initialRange.location-1] integerValue]-currentLocation +1;
            // 高亮范围从匹配到的第一个关键字开始
            highlightedRange = NSMakeRange(currentLocation, highlightedLength);
        }
        searchResult.highlightedRange = highlightedRange;
        searchResult.matchType = MatchTypeInitial;
        if (highlightedRange.length!=0) {
            return searchResult;
        }
    }
    
    // 处理读音与本身读音不同的特殊字符
    __block NSRange fixPinYinRange = NSMakeRange(NSNotFound, 0);
    [self.fixPinYinMappings enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *vaule, BOOL * _Nonnull stop) {
        if ([searchKey isEqualToString:key] && [nameKey rangeOfString:vaule].length) {
            fixPinYinRange = [nameKey rangeOfString:vaule];
            *stop = YES;
        }
    }];
    if (fixPinYinRange.length!=0) {
        searchResult.highlightedRange = fixPinYinRange;
        searchResult.matchType = MatchTypeInitial;
        return searchResult;
    }
    
    
    searchResult.highlightedRange = NSMakeRange(0, 0);
    searchResult.matchType = NSIntegerMax;
    return searchResult;
}

- (HanyuPinyinOutputFormat *)outputFormat {
    if (!_outputFormat) {
        _outputFormat = [PSSearchTools getOutputFormat];
    }
    return _outputFormat;
}
    
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
    
@end
