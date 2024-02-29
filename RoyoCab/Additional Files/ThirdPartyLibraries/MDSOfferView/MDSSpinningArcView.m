//
//  MDSCirclePendingView
//

#import "MDSSpinningArcView.h"
#import "MDSCircleView.h"

static NSString * const MDSSpinningArcViewSpinAnimationKey = @"MDSSpinningArcViewSpinAnimationKey";

@interface MDSSpinningArcView ()

@property (nonatomic, weak) MDSCircleView *circleView;

@property (nonatomic) BOOL isSpinning;

@end

@implementation MDSSpinningArcView

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setupCirclePendingView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCirclePendingView];
    }
    return self;
}

- (void)setupCirclePendingView {
    MDSCircleView *circleView = [[MDSCircleView alloc] initWithFrame:self.bounds];
    circleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:circleView];
    self.circleView = circleView;
    
    self.emptyAngle = 0.6;
    self.spinDuration = 1.0;
    
    self.userInteractionEnabled = NO;
}

- (void)setSpinDuration:(NSTimeInterval)spinDuration {
    _spinDuration = spinDuration;
    [self removeRotationAnimation];
    if (self.isSpinning) {
        [self startSpinning];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.circleView.lineWidth = lineWidth;
}

- (void)setEmptyAngle:(CGFloat)emptyAngle {
    _emptyAngle = emptyAngle;
    self.circleView.startAngle = 1.5f * M_PI + emptyAngle / 2.f;
    self.circleView.endAngle = self.circleView.startAngle + 2 * M_PI - emptyAngle;
}

#pragma mark - private methods

- (void)startSpinning {
    self.isSpinning = YES;
    [self addRotationAnimationWithDuration:self.spinDuration];
}

- (void)stopSpinning {
    [self removeRotationAnimation];
    self.isSpinning = NO;
}

- (void)addRotationAnimationWithDuration:(NSTimeInterval)fullRotationDuration {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [self.circleView.layer.presentationLayer valueForKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = @([rotationAnimation.fromValue floatValue] + (2. * M_PI));
    rotationAnimation.duration = fullRotationDuration;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [self.circleView.layer addAnimation:rotationAnimation forKey:MDSSpinningArcViewSpinAnimationKey];
}

- (void)removeRotationAnimation {
    [self.circleView.layer removeAnimationForKey:MDSSpinningArcViewSpinAnimationKey];
}

@end
