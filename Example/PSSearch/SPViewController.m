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

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) PSSearchManager *searchManager;

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSArray *keywords = @[
						  @"按实际的了解 嗯(182981928)",@"",@"a",@"asd",@"llop",@"&",@"mk",@"账上",@"往后",@"数据",@"啊卡卡卡",@"指挥部",@"opp"
						  ];
	for (int i=0; i<keywords.count-1; i++) {
		NSString *s = keywords[i];
		[self.searchManager addInitializeString:s identifer:[NSString stringWithFormat:@"%d",i]];
	}
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
			NSLog(@"----->: %@",entity.name);
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
