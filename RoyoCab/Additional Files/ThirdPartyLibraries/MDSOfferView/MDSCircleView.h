//
//  MDSCircleView
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MDSCircleView : UIView

@property (nonatomic) IBInspectable CGFloat startAngle;
@property (nonatomic) IBInspectable CGFloat endAngle;
@property (nonatomic) IBInspectable CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END