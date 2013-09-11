//
//  TimelineContentView.h
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <JNWCollectionView/JNWCollectionView.h>
#import "TimelineLayout.h"
#import "TimelineItem.h"

@interface TimelineContentView : JNWCollectionViewCell

// We default to text on the left, images on the right. Mirrored is the opposite.
@property (nonatomic, assign) TimelineLayoutDirection layoutDirection;

@property (nonatomic, assign) TimelineLayoutItemPosition layoutPosition;

@property (nonatomic, strong) TimelineItem *item;

@end
