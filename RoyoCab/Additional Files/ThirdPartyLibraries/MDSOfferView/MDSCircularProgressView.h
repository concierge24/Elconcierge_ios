//
//  MDSCircleProgressView
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MDSCircularProgressView : UIView

@property (nonatomic) IBInspectable double progress;
@property (nonatomic) IBInspectable CGFloat filledLineWidth;
@property (nonatomic) IBInspectable CGFloat emptyLineWidth;

- (void)setProgress:(double)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
