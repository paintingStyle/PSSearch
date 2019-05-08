# PSSearch

[![CI Status](https://img.shields.io/travis/paintingStyle/PSSearch.svg?style=flat)](https://travis-ci.org/paintingStyle/PSSearch)
[![Version](https://img.shields.io/cocoapods/v/PSSearch.svg?style=flat)](https://cocoapods.org/pods/PSSearch)
[![License](https://img.shields.io/cocoapods/l/PSSearch.svg?style=flat)](https://cocoapods.org/pods/PSSearch)
[![Platform](https://img.shields.io/cocoapods/p/PSSearch.svg?style=flat)](https://cocoapods.org/pods/PSSearch)

## Example

### 联系人呢称/拼音/字母搜索组件
- 支持汉字，字母，数字，下划线等搜索
- 支持是否区分大小写搜索
- 支持多音字匹配
- 搜索结果优先展示 中文，其次是全拼匹配，最后是拼音首字母匹配
- 优先显示 高亮位置索引靠前的搜索结果

### 使用方法

#### 1, 初始化搜索数据源，指定搜索关键字与标识符

````
@property (nonatomic, strong) PSSearchManager *searchManager;

for (SPUser *aUser in category.friendsArray) {
NSString *name = aUser.remark:aUser.nickname;
NSString *identifer = [NSString stringWithFormat:@"%ld",[category.friendsArray indexOfObject:aUser]];
[self.searchManager addInitializeString:name identifer:identifer];
}
````

#### 2, 匹配关键字，刷新结果列表

````
- (void)searchWithKeyWord:(NSString *)keyword{

NSMutableArray *resultDataSource = [NSMutableArray array];
for (PSSearchEntity *entity in [self.searchManager getInitializedDataSource]) {
@autoreleasepool {
	PSSearchResult *result = [self.searchManager searchResultWithKeyWord:keyword searchEntity:entity];;
	if (!result.highlightedRange.length) { continue; } // 过滤无效的结果

	entity.highlightLoaction = result.highlightedRange.location;
	entity.textRange = result.highlightedRange;
	entity.matchType = result.matchType;
	if ([entity.identifier integerValue] <= self.allSearchFriendsArray.count-1) { // 根据标识符取出业务需要数据
		SPSelectModel *selectModel = self.category.friendsArray[[entity.identifier integerValue]];
		selectModel.highlightedRange = result.highlightedRange;
		[resultDataSource addObject:selectModel];
	}
}
}
self.hasSearchedArray = resultDataSource;
}
````

## Requirements

## Installation

PSSearch is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PSSearch'
```

## Author

paintingStyle, renshuangfu@spap.com

## License

PSSearch is available under the MIT license. See the LICENSE file for more info.
