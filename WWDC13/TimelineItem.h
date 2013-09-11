//
//  TimelineItem.h
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimelineItem : NSObject

@property (nonatomic, strong) NSImage *image;
@property (nonatomic, copy) NSString *attributedTextPath;

@end
