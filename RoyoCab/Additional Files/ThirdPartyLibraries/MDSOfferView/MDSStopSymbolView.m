//
//  MDSStopSignView.m
//  DownloadButtonDemo
//
//  Created by YuAo on 3/16/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "MDSStopSymbolView.h"

@implementation MDSStopSymbolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupStopSymbolView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupStopSymbolView];
    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)setupStopSymbolView {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

- (CAShapeLayer *)shapeLayer {
    return (id)self.layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShapeLayer];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self updateShapeLayer];
}

- (void)setSymbolSize:(CGFloat)symbolSize {
    _symbolSize = symbolSize;
    [self updateShapeLayer];
}

- (void)updateShapeLayer {
    CGRect rect = CGRectInset(self.bounds, (CGRectGetWidth(self.bounds) - self.symbolSize )/2, (CGRectGetHeight(self.bounds) - self.symbolSize)/2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    self.shapeLayer.path = bezierPath.CGPath;
    self.shapeLayer.lineWidth = 0;
    self.shapeLayer.fillColor = self.tintColor.CGColor;
}

@end
