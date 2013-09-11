//
//  MainWindowController.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "MainWindowController.h"
#import "TimelineHeaderFooterLineView.h"
#import "TimelineSelectionView.h"
#import "TimelineItem.h"
#import "TimelineContentView.h"

@interface MainWindowController ()
@property (nonatomic, strong) NSArray *items;
@end

static NSString * const headerFooterIdentifier = @"headerFooterIdentifier";
static NSString * const selectionIndicatorIdentifier = @"selectionIndicatorIdentifier";
static NSString * const leftRightItemIndentifier = @"itemIdentifier";

@implementation MainWindowController

- (instancetype)init {
	self = [super initWithWindowNibName:NSStringFromClass(self.class)];
	if (self == nil) return nil;
	[self.window makeKeyAndOrderFront:nil];
	return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
	
	[self loadData];
	
	TimelineLayout *layout = [[TimelineLayout alloc] initWithCollectionView:self.collectionView];
	layout.delegate = self;
	layout.timelineEdgeInset = 50.f;
	
	self.collectionView.collectionViewLayout = layout;
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	
	self.collectionView.animatesSelection = YES;
		
	// We're bumping down the deceleration rate (turning up the constant) so that the
	// transition between scenes isn't done at an incredibly fast rate.
	self.collectionView.clipView.decelerationRate = 0.93f;
	
	[self.collectionView registerClass:TimelineSelectionView.class forCellWithReuseIdentifier:selectionIndicatorIdentifier];
	[self.collectionView registerClass:TimelineContentView.class forCellWithReuseIdentifier:leftRightItemIndentifier];
	[self.collectionView registerClass:TimelineHeaderFooterLineView.class
			forSupplementaryViewOfKind:TimelineLayoutUpperLineKind withReuseIdentifier:headerFooterIdentifier];
	[self.collectionView registerClass:TimelineHeaderFooterLineView.class
			forSupplementaryViewOfKind:TimelineLayoutLowerLineKind withReuseIdentifier:headerFooterIdentifier];
	
	[self.collectionView reloadData];
	
	self.collectionView.backgroundColor = [NSColor colorWithCalibratedWhite:0.090 alpha:1.000];

	[self.collectionView selectItemAtIndexPath:[NSIndexPath jnw_indexPathForItem:0 inSection:0] atScrollPosition:JNWCollectionViewScrollPositionTop animated:YES];
}

- (void)loadData {
	BOOL exists = YES;
	NSInteger index = 0;
	NSMutableArray *items = [NSMutableArray array];
	while (exists) {
		NSString *filename = [NSString stringWithFormat:@"%ld",index];
		NSImage *image = [NSImage imageNamed:filename];
		NSString *textPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"rtf"];
		exists = (image != nil || textPath != nil);
		if (exists) {
			TimelineItem *item = [[TimelineItem alloc] init];
			item.image = image;
			item.attributedTextPath = textPath;
			[items addObject:item];
		}
		index++;
	}
	
	self.items = items.copy;
}

#pragma mark JNWCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(JNWCollectionView *)collectionView {
	return self.items.count;
}

- (NSUInteger)collectionView:(JNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	// We're returning 3 because in each section we have the info text, the selection indicator, and the picture
	return 3;
}

- (JNWCollectionViewCell *)collectionView:(JNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	TimelineLayout *timelineLayout = (TimelineLayout *)self.collectionView.collectionViewLayout;
	TimelineItem *item = self.items[indexPath.jnw_section];

	TimelineLayoutItemPosition position = [timelineLayout timelineLayoutItemPositionForItemAtIndexPath:indexPath];
	if (position == TimelineLayoutItemPositionLeft || position == TimelineLayoutItemPositionRight) {
		TimelineContentView *informationCell = (TimelineContentView *)[self.collectionView dequeueReusableCellWithIdentifier:leftRightItemIndentifier];		
		informationCell.layoutDirection = [timelineLayout timelineLayoutDirectionForItemAtIndexPath:indexPath];
		informationCell.layoutPosition = position;
		informationCell.item = item;
		return informationCell;
	} else {
		return [self.collectionView dequeueReusableCellWithIdentifier:selectionIndicatorIdentifier];
	}
}

- (JNWCollectionViewReusableView *)collectionView:(JNWCollectionView *)collectionView viewForSupplementaryViewOfKind:(NSString *)kind inSection:(NSInteger)section {
	return [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifer:headerFooterIdentifier];
}

- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForTimelineAtRow:(NSInteger)row {
	TimelineItem *item = self.items[row];
	CGFloat defaultHeight = 200;
	CGFloat imageHeight = 0;
	CGFloat textHeight = 0;
	
	if (item.image != nil) {
		imageHeight = item.image.size.height;
	}
	
	if (item.attributedTextPath != nil) {
		CGFloat width = [(TimelineLayout *)self.collectionView.collectionViewLayout proposedWidthForLeftRightItem];
		CGSize boundingSize = CGSizeMake(width, MAXFLOAT);
		NSAttributedString *attributedString = [[NSAttributedString alloc] initWithPath:item.attributedTextPath documentAttributes:nil];
		
		CGRect rect = [attributedString boundingRectWithSize:boundingSize options:NSLineBreakByWordWrapping | NSStringDrawingUsesDeviceMetrics | NSStringDrawingUsesLineFragmentOrigin];
		textHeight = rect.size.height;
	}
	
	return MAX(MAX(textHeight, imageHeight), defaultHeight);
}

#pragma mark JNWCollectionViewDelegate

- (void)collectionView:(JNWCollectionView *)collectionView didScrollToItemAtIndexPath:(NSIndexPath *)indexPath {
	TimelineLayout *timelineLayout = (TimelineLayout *)self.collectionView.collectionViewLayout;
	
	// We want to make sure the view scrolls up to make all three items in the timeline visible, not just the selection view.
	if ([timelineLayout timelineLayoutItemPositionForItemAtIndexPath:indexPath] == TimelineLayoutItemPositionCenter) {
		NSIndexPath *toScroll = [NSIndexPath jnw_indexPathForItem:0 inSection:indexPath.jnw_section];
		[self.collectionView scrollToItemAtIndexPath:toScroll atScrollPosition:JNWCollectionViewScrollPositionNearest animated:YES];
	}
}

@end
