//
//  MDSDownloadButton.h
//  DownloadButtonDemo
//
//  Created by YuAo on 3/15/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MDSOfferViewState) {
    MDSOfferViewStateNormal,
    MDSOfferViewStatePendingDownload,
    MDSOfferViewStateDownloading,
    MDSOfferViewStateDownloaded
};

/**
 MDSOfferView imitates the download/offer button in the App Store app.
 */
IB_DESIGNABLE
@interface MDSOfferView : UIView

/**
 Get or set the current state of the receiver.
 */
@property (nonatomic) MDSOfferViewState state;

/**
 Get or set the progress of the progress view shows in MDSOfferViewStateDownloading state, withou animation.
 */
@property (nonatomic) double progress;

/**
 Get or set the progress of the progress view shows in MDSOfferViewStateDownloading state.
 */
- (void)setProgress:(double)progress animated:(BOOL)animated;

/**
 A Boolean value that determines whether the receiver is enabled.
 */
@property (nonatomic) BOOL enabled;

/**
 Sets the title to use for the specified state.
 */
- (void)setTitle:(nullable NSString *)title forState:(MDSOfferViewState)state;

/**
 Returns the title associated with the specified state.
 */
- (nullable NSString *)titleForState:(MDSOfferViewState)state;

/**
 The current title that is displayed on the action button.
 */
@property (nonatomic, readonly, nullable) NSString *currentTitle;

/**
 Returns the UIButton associated with the receiver.
 You can customize the title color, font, and content insets for the button. You can also add additional target/actions to the button.
 */
@property (nonatomic, readonly) UIButton *actionButton;

/**
 A block that is called when the user tap the action button.
 */
@property (nonatomic, copy, nullable) void (^actionHandler)(MDSOfferView *offerView);

@end

NS_ASSUME_NONNULL_END