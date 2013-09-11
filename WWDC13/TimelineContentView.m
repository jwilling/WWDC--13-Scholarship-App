//
//  TimelineContentView.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "TimelineContentView.h"
#import "VerticallyCenteredTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface TimelineContentView()
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) VerticallyCenteredTextField *textField;
@end

@implementation TimelineContentView

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	[self.contentView addSubview:self.imageView];
	[self.contentView addSubview:self.textField];
	return self;
}

- (void)setItem:(TimelineItem *)item {
	_item = item;
	
	// normal->		 [text] | [image]
	// mirrored->	[image] | [text]
	
	BOOL left = self.layoutPosition == TimelineLayoutItemPositionLeft;
	BOOL normalDirecton = self.layoutDirection == TimelineLayoutDirectionNormal;

	if (item.image != nil && ((normalDirecton && !left) || (!normalDirecton && left))) {
		self.imageView.imageAlignment = (left ? NSImageAlignRight : NSImageAlignLeft);
		self.imageView.image = item.image;
	}
	
	if (item.attributedTextPath != nil && ((self.layoutDirection == TimelineLayoutDirectionNormal && left) ||
										   (self.layoutDirection == TimelineLayoutDirectionMirrored && !left))) {
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithPath:item.attributedTextPath documentAttributes:nil];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, attributedString.length)];
		self.textField.attributedStringValue = attributedString;		
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.imageView.image = nil;
	self.textField.stringValue = @"";
	
	[self.layer removeAnimationForKey:@"opacity"];
	[self.layer removeAnimationForKey:@"transform"];
	
	CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacity.fromValue = @0;
	opacity.duration = 1.f;
	[self.layer addAnimation:opacity forKey:@"opacity"];
}

- (void)setLayoutPosition:(TimelineLayoutItemPosition)layoutPosition {
	_layoutPosition = layoutPosition;
	
	CGFloat translation = (layoutPosition == TimelineLayoutItemPositionLeft ? -50.f : 50.f);
	CABasicAnimation *glide = [CABasicAnimation animationWithKeyPath:@"transform"];
	glide.duration = 1.f;
	glide.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(translation, 0, 0)];
	glide.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	// Use a custom timing function to make the ease out even more gradual. Gives a nice
	// relaxed feeling.
	glide.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.195 :.97 :.535 :.975];
	[self.layer addAnimation:glide forKey:@"transform"];
}

- (void)layout {
	[super layout];
	
	[_imageView setFrame:self.contentView.bounds];
	[_textField setFrame:self.contentView.bounds];
}

- (NSImageView *)imageView {
	if (_imageView == nil) {
		_imageView = [[NSImageView alloc] initWithFrame:self.bounds];
	}
	return _imageView;
}

- (VerticallyCenteredTextField *)textField {
	if (_textField == nil) {
		_textField = [[VerticallyCenteredTextField alloc] initWithFrame:self.bounds];
		_textField.drawsBackground = NO;
		_textField.bezeled = NO;
		_textField.bordered = NO;
		_textField.selectable = NO;
	}
	
	return _textField;
}

@end
