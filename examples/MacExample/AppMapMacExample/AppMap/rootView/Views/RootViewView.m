#import "RootViewView.h"

@interface RootViewView ()
// Private interface goes here.
@end

@implementation RootViewView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    NSImage *image = [NSImage imageNamed:@"tool-constraints-selected"];
    NSImageView *view = [NSImageView new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.image = image;
    
    [self addSubview:view];

    NSLayoutConstraint *width =
    [NSLayoutConstraint
     constraintWithItem:view
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0f
     constant:image.size.width];

    NSLayoutConstraint *height =
    [NSLayoutConstraint
     constraintWithItem:view
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
     toItem:nil
     attribute:NSLayoutAttributeNotAnAttribute
     multiplier:1.0f
     constant:image.size.height];
    
    NSLayoutConstraint *centerX =
    [NSLayoutConstraint
     constraintWithItem:view
     attribute:NSLayoutAttributeCenterX
     relatedBy:NSLayoutRelationEqual
     toItem:self
     attribute:NSLayoutAttributeCenterX
     multiplier:1.0f
     constant:0.0f];
    
    NSLayoutConstraint *centerY =
    [NSLayoutConstraint
     constraintWithItem:view
     attribute:NSLayoutAttributeCenterY
     relatedBy:NSLayoutRelationEqual
     toItem:self
     attribute:NSLayoutAttributeCenterY
     multiplier:1.0f
     constant:0.0f];
    
    [self addConstraint:width];
    [self addConstraint:height];
    [self addConstraint:centerX];
    [self addConstraint:centerY];
}

@end
