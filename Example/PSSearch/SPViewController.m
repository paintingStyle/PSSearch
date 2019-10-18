//
//  SPViewController.m
//  PSSearch
//
//  Created by paintingStyle on 05/08/2019.
//  Copyright (c) 2019 paintingStyle. All rights reserved.
//

#import "SPViewController.h"
#import "PSSearchManager.h"
#import "PSSearchEntity.h"

@interface SPViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) PSSearchManager *searchManager;

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSArray *keywords = @[
						  @"啊卡卡卡",
						  @"按实(182981928)",
						  @">?[=2",
						  @"a",
						  @"asd",
						  @"llop",
						  @"&",
						  @"mk",
						  @"账上",
						  @"往后",
						  @"数据",
						  @"指挥部",
						  @"opp"
						  ];
	for (int i=0; i<keywords.count-1; i++) {
		NSString *s = keywords[i];
		[self.searchManager addInitializeString:s identifer:[NSString stringWithFormat:@"%d",i]];
	}

	NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
	[keywords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[string appendFormat:@"\t%@,\n", obj];
	}];
	[string appendString:@"}\n"];
	self.textLabel.text = string;
}


- (IBAction)searchDidClick {
	
	[self searchWithKeyWord:self.textField.text];
}

- (void)searchWithKeyWord:(NSString *)keyword{
	
	// TODO:2,遍历数据源，查看是否匹配，刷新结果列表
	NSMutableArray *resultDataSource = [NSMutableArray array];
	for (PSSearchEntity *entity in [self.searchManager getInitializedDataSource]) {
		@autoreleasepool {
			PSSearchResult *result = [self.searchManager searchResultWithKeyWord:keyword searchEntity:entity];;
			if (!result.highlightedRange.length) { continue; }
			
			entity.highlightLoaction = result.highlightedRange.location;
			entity.textRange = result.highlightedRange;
			entity.matchType = result.matchType;
			[resultDataSource addObject:entity];
			NSLog(@"----->name: %@, textRange:%@",entity.name, NSStringFromRange(entity.textRange));
		}
	}
	
}

#pragma mark - setter/getter

- (PSSearchManager *)searchManager {
	if (!_searchManager) {
		_searchManager = [[PSSearchManager alloc] init];
	}
	return _searchManager;
}

@end
