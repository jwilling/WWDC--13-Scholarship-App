//
//  TimelineLayout.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "TimelineLayout.h"

NSString * const TimelineLayoutUpperLineKind = @"TimelineLineUpper";
NSString * const TimelineLayoutLowerLineKind = @"TimelineLineLower";

@interface TimelineLayoutItem : NSObject
@property (nonatomic, assign) TimelineLayoutDirection layoutDirection;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGRect leftItemFrame;
@property (nonatomic, assign) CGRect centerItemFrame;
@property (nonatomic, assign) CGRect rightItemFrame;
@property (nonatomic, assign) CGRect headerFrame;
@property (nonatomic, assign) CGRect footerFrame;
@end

@implementation TimelineLayoutItem
@end

@interface TimelineLayout()
@property (nonatomic, strong) NSMutableArray *layoutData;
@end

@implementation TimelineLayout

- (instancetype)initWithCollectionView:(JNWCollectionView *)collectionView {
	self = [super initWithCollectionView:collectionView];
	if (self == nil) return nil;
	self.layoutData = [NSMutableArray array];
	self.timelineRowSpacing = 30.f;
	self.timelineEdgeInset = 0;
	self.selectionIndicatorSize = CGSizeMake(50, 50);
	self.timelineCenterPadding = 50.f;
	
	return self;
}

- (void)prepareLayout {
	[super prepareLayout];
	
	[self.layoutData removeAllObjects];
	
	// To be clear: a row, in this layout, means both the picture and the descriptive text combined.\
	// This means that each row is its own section.
	NSInteger numberOfTimelines = [self.collectionView numberOfSections];
	CGFloat currentOffset = 0;
	
	for (NSInteger timelineRow = 0; timelineRow < numberOfTimelines; timelineRow++) {
		CGFloat timelineRowHeight = [self.delegate collectionView:self.collectionView heightForTimelineAtRow:timelineRow];
		
		TimelineLayoutItem *layoutItem = [[TimelineLayoutItem alloc] init];
		layoutItem.height = timelineRowHeight;
		layoutItem.layoutDirection = (timelineRow % 2);
		
		CGFloat totalWidth = CGRectGetWidth(self.collectionView.documentVisibleRect);
		CGFloat totalLeftRightUsableWidth = totalWidth - 2 * self.timelineEdgeInset - self.selectionIndicatorSize.width;
		
		CGFloat itemWidth = floorf(totalLeftRightUsableWidth / 2) - self.timelineCenterPadding;
		CGFloat itemHeight = timelineRowHeight;
		CGFloat itemY = currentOffset + self.timelineRowSpacing;
		CGFloat centerItemOffsetY = itemY + floorf(itemHeight / 2) - floorf(self.selectionIndicatorSize.height / 2);
		
		layoutItem.leftItemFrame = CGRectMake(self.timelineEdgeInset, itemY, itemWidth, itemHeight);
		layoutItem.rightItemFrame = CGRectMake(totalWidth - self.timelineEdgeInset - itemWidth, itemY, itemWidth, itemHeight);
		layoutItem.centerItemFrame = CGRectMake(self.timelineEdgeInset + itemWidth + self.timelineCenterPadding, centerItemOffsetY,
												self.selectionIndicatorSize.width, self.selectionIndicatorSize.width);
		layoutItem.headerFrame = CGRectMake(self.timelineEdgeInset + itemWidth + self.timelineCenterPadding, currentOffset, self.selectionIndicatorSize.width, centerItemOffsetY - currentOffset);
		layoutItem.footerFrame = CGRectMake(self.timelineEdgeInset + itemWidth + self.timelineCenterPadding, centerItemOffsetY + self.selectionIndicatorSize.height, self.selectionIndicatorSize.width, centerItemOffsetY - currentOffset);
		currentOffset = itemY + itemHeight;
		
		[self.layoutData addObject:layoutItem];
	}
}

- (TimelineLayoutDirection)timelineLayoutDirectionForItemAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.jnw_section % 2);
}

- (TimelineLayoutItemPosition)timelineLayoutItemPositionForItemAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.jnw_item) {
		case 0:
			return TimelineLayoutItemPositionLeft;
			break;
		case 1:
			return TimelineLayoutItemPositionCenter;
			break;
		case 2:
		default:
			return TimelineLayoutItemPositionRight;
			break;
	}
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
	attributes.alpha = 1.f;
	
	TimelineLayoutItem *layoutItem = self.layoutData[indexPath.jnw_section];
	if ([self timelineLayoutItemPositionForItemAtIndexPath:indexPath] == TimelineLayoutItemPositionLeft) {
		attributes.frame = layoutItem.leftItemFrame;
	} else if ([self timelineLayoutItemPositionForItemAtIndexPath:indexPath] == TimelineLayoutItemPositionRight) {
		attributes.frame = layoutItem.rightItemFrame;
	} else {
		attributes.frame = layoutItem.centerItemFrame;
	}
	
	return attributes;
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryItemInSection:(NSInteger)section kind:(NSString *)kind {
	JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
	attributes.alpha = 1.f;
	
	TimelineLayoutItem *layoutItem = self.layoutData[section];
	
	if ([kind isEqualToString:TimelineLayoutUpperLineKind]) {
		attributes.frame = layoutItem.headerFrame;
	} else {
		attributes.frame = layoutItem.footerFrame;
	}
	
	return attributes;
}

- (NSIndexPath *)indexPathForNextItemInDirection:(JNWCollectionViewDirection)direction currentIndexPath:(NSIndexPath *)currentIndexPath {
	if (direction == JNWCollectionViewDirectionDown) {
		if (currentIndexPath.jnw_section + 1 < self.layoutData.count)
			return [NSIndexPath jnw_indexPathForItem:1 inSection:currentIndexPath.jnw_section + 1];
	} else if (direction == JNWCollectionViewDirectionUp) {
		if (currentIndexPath.jnw_section - 1 >= 0)
			return [NSIndexPath jnw_indexPathForItem:1 inSection:currentIndexPath.jnw_section - 1];
	}
	
	return nil;
}

- (CGFloat)proposedWidthForLeftRightItem {
	CGFloat totalLeftRightUsableWidth = CGRectGetWidth(self.collectionView.documentVisibleRect) - 2 * self.timelineEdgeInset - self.selectionIndicatorSize.width;
	return floorf(totalLeftRightUsableWidth / 2) - self.timelineCenterPadding;
}

@end
