//
//  MDSCirclePendingView
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MDSSpinningArcView : UIView

@property (nonatomic) IBInspectable CGFloat lineWidth;
@property (nonatomic) IBInspectable CGFloat emptyAngle;
@property (nonatomic) IBInspectable NSTimeInterval spinDuration;

@property (nonatomic,readonly) BOOL isSpinning;

- (void)startSpinning;
- (void)stopSpinning;

@end

NS_ASSUME_NONNULL_END