//
//  TimelineHeaderFooterLineView.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "TimelineHeaderFooterLineView.h"

@implementation TimelineHeaderFooterLineView

- (BOOL)wantsUpdateLayer {
	return YES;
}

- (void)updateLayer {
	self.layer.contents = [NSImage imageWithSize:CGSizeMake(self.bounds.size.width, 2) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
		CGRect drawingRect = CGRectMake(floorf(dstRect.size.width / 2) - 1, 0, 3, 2);
		[[NSColor whiteColor] set];
		NSRectFill(drawingRect);
		return YES;
	}];
}

@end
