//
//  MainWindowController.h
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <JNWCollectionView/JNWCollectionView.h>
#import "TimelineLayout.h"

@interface MainWindowController : NSWindowController <JNWCollectionViewDataSource, JNWCollectionViewDelegate, TimelineLayoutDelegate>

@property (nonatomic, strong) IBOutlet JNWCollectionView *collectionView;

@end
