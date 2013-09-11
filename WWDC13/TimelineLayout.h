//
//  TimelineLayout.h
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionViewLayout.h>

extern NSString * const TimelineLayoutUpperLineKind;
extern NSString * const TimelineLayoutLowerLineKind;

typedef NS_ENUM(NSInteger, TimelineLayoutDirection) {
	TimelineLayoutDirectionNormal = 0,
	TimelineLayoutDirectionMirrored
};

typedef NS_ENUM(NSInteger, TimelineLayoutItemPosition) {
	TimelineLayoutItemPositionLeft = 0,
	TimelineLayoutItemPositionCenter,
	TimelineLayoutItemPositionRight
};

@protocol TimelineLayoutDelegate <NSObject>
- (CGFloat)collectionView:(JNWCollectionView *)collectionView heightForTimelineAtRow:(NSInteger)row;
@end

@interface TimelineLayout : JNWCollectionViewLayout

@property (nonatomic, unsafe_unretained) id<TimelineLayoutDelegate> delegate;

// The vertical spacing between timeline rows
//
// Defaults to 30.
@property (nonatomic, assign) CGFloat timelineRowSpacing;

// Padding of the edge views from the center item.
//
// Defaults to 50.
@property (nonatomic, assign) CGFloat timelineCenterPadding;

// Inset of items from the edges.
//
// Defaults to 0.
@property (nonatomic, assign) CGFloat timelineEdgeInset;

// The size of the timeline indicator dot in the center.
//
// Defaults to 50, 50.
@property (nonatomic, assign) CGSize selectionIndicatorSize;

- (CGFloat)proposedWidthForLeftRightItem;

- (TimelineLayoutDirection)timelineLayoutDirectionForItemAtIndexPath:(NSIndexPath *)indexPath;
- (TimelineLayoutItemPosition)timelineLayoutItemPositionForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
