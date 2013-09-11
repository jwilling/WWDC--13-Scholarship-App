//
//  TimelineSelectionView.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "TimelineSelectionView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimelineSelectionView {
	BOOL _shouldAnimate;
}

- (void)drawOuterRingInRect:(CGRect)frame context:(CGContextRef)ctx {
	CGContextSetStrokeColorWithColor(ctx, [NSColor whiteColor].CGColor);
	CGContextSetLineWidth(ctx, 3.f);
	CGContextAddEllipseInRect(ctx, CGRectInset(frame, 1.5, 1.5));
	CGContextStrokePath(ctx);
}

- (NSImage *)standardBackgroundImage {
	return [NSImage imageWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
		CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
		[self drawOuterRingInRect:dstRect context:ctx];
		return YES;
	}];
}

- (NSImage *)selectedBackgroundImage {
	return [NSImage imageWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
		CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
		[self drawOuterRingInRect:dstRect context:ctx];
		CGContextSetFillColorWithColor(ctx, [NSColor whiteColor].CGColor);
		CGContextFillEllipseInRect(ctx, CGRectInset(dstRect, 7, 7));
		return YES;
	}];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	
	if (selected) {
		self.backgroundImage = [self selectedBackgroundImage];
	} else {
		self.backgroundImage = [self standardBackgroundImage];
	}
}

@end
