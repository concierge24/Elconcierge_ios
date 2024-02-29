
#import "MDSCircularProgressView.h"
#import "MDSCircleView.h"

static CGFloat const MDSCircularProgressViewDefaultFilledLineWidth = 3.0;
static CGFloat const MDSCircularProgressViewDefaultEmptyLineWidth = 1.0;
static CGFloat const MDSCircularProgressViewStartAngle = M_PI * 1.5;

@interface MDSCircularProgressView ()

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;

@property (nonatomic, weak) MDSCircleView *emptyLineCircleView;
@property (nonatomic, weak) MDSCircleView *filledLineCircleView;

@end

@implementation MDSCircularProgressView

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setupCircleProgressView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCircleProgressView];
    }
    return self;
}

- (void)setupCircleProgressView {
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = MDSCircularProgressViewStartAngle;
    self.endAngle = self.startAngle + (M_PI * 2);
    
    MDSCircleView *emptyLineCircleView = [[MDSCircleView alloc] initWithFrame:self.bounds];
    self.emptyLineCircleView = emptyLineCircleView;
    [self addSubview:emptyLineCircleView];
    
    MDSCircleView *filledLineCircleView = [[MDSCircleView alloc] initWithFrame:self.bounds];
    self.filledLineCircleView = filledLineCircleView;
    [self addSubview:filledLineCircleView];
    
    self.emptyLineWidth = MDSCircularProgressViewDefaultEmptyLineWidth;
    self.filledLineWidth = MDSCircularProgressViewDefaultFilledLineWidth;
}

- (void)setProgress:(double)progress {
    _progress = progress;
    self.filledLineCircleView.startAngle = self.startAngle;
    self.filledLineCircleView.endAngle = (self.endAngle - self.startAngle) * progress + self.startAngle;
}

- (void)setProgress:(double)progress animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.progress = progress;
                         }];
    } else {
        self.progress = progress;
    }
}

- (void)setFilledLineWidth:(CGFloat)filledLineWidth {
    _filledLineWidth = filledLineWidth;
    self.filledLineCircleView.lineWidth = filledLineWidth;
    [self setNeedsLayout];
}

- (void)setEmptyLineWidth:(CGFloat)emptyLineWidth {
    _emptyLineWidth = emptyLineWidth;
    self.emptyLineCircleView.lineWidth = emptyLineWidth;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat radius = MIN(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    CGFloat emptyLineCircleSize = radius * 2.0;
    CGFloat deltaRaduis = - self.emptyLineCircleView.lineWidth / 2.0;
    CGFloat filledLineCircleSize = radius * 2.0 + deltaRaduis * 2.0;
    self.emptyLineCircleView.frame = CGRectMake(0, 0, emptyLineCircleSize, emptyLineCircleSize);
    self.emptyLineCircleView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.filledLineCircleView.frame = CGRectMake(0, 0, filledLineCircleSize, filledLineCircleSize);
    self.filledLineCircleView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
