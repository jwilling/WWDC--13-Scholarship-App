//
//  VerticallyCenteredTextView.m
//  WWDC13
//
//  Created by Jonathan Willing on 5/1/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "VerticallyCenteredTextField.h"

@interface VerticallyCenteredTextFieldCell : NSTextFieldCell

@end

@implementation VerticallyCenteredTextField

+ (Class)cellClass {
	return VerticallyCenteredTextFieldCell.class;
}

@end

@implementation VerticallyCenteredTextFieldCell

// ht Jakob Egger:  http://stackoverflow.com/a/9547002/456851
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSAttributedString *attrString = self.attributedStringValue;
    [attrString drawWithRect: [self titleRectForBounds:cellFrame] options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    NSRect titleFrame = [super titleRectForBounds:theRect];
	NSAttributedString *attrString = self.attributedStringValue;
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height;
    }
    return titleFrame;
}

@end
