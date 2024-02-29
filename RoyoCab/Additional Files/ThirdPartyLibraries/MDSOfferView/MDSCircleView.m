//
//  MDSCircleView
//

#import "MDSCircleView.h"

static CGFloat const MDSCircleViewDefaultLineWidth = 1.0;

@interface MDSCircleView ()

@property (nonatomic,readonly) CAShapeLayer *shapeLayer;

@end

@implementation MDSCircleView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (id)self.layer;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setupCircleView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCircleView];
    }
    return self;
}

- (void)setupCircleView {
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = -M_PI * 1.5;
    self.endAngle = self.startAngle + (M_PI * 2);
    self.lineWidth = MDSCircleViewDefaultLineWidth;
}

#pragma mark - properties

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self updateShapeLayer];
}

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    [self updateShapeLayer];
}

- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
    [self updateShapeLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShapeLayer];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self updateShapeLayer];
}

- (void)updateShapeLayer {
    CGRect rect = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
                          radius:MIN(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2) - self.lineWidth/2
                      startAngle:self.startAngle
                        endAngle:self.startAngle + 2 * M_PI
                       clockwise:YES];
    self.shapeLayer.path = bezierPath.CGPath;
    self.shapeLayer.strokeColor = self.tintColor.CGColor;
    CGFloat progress = MAX((self.endAngle - self.startAngle)/(2 * M_PI),0);
    if (progress > 1.0) {
        progress = progress - floor(progress);
    }
    self.shapeLayer.strokeEnd = progress;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if (layer == self.shapeLayer && [event isEqualToString:@"strokeEnd"]) {
        //Only perform animation action when in a UIView animation block
        CAAnimation *opacityAction = (id)[super actionForLayer:layer forKey:@"opacity"];
        if (opacityAction && ![opacityAction isKindOfClass:[NSNull class]] && [opacityAction isKindOfClass:[CAAnimation class]]) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
            animation.fromValue = [layer.presentationLayer valueForKey:event];
            animation.duration = opacityAction.duration;
            return animation;
        } else {
            return [NSNull null];
        }
    }
    return [super actionForLayer:layer forKey:event];
}

@end
