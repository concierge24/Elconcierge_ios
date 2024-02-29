//
//  MDSDownloadButton.m
//  DownloadButtonDemo
//
//  Created by YuAo on 3/15/16.
//  Copyright © 2016 YuAo. All rights reserved.
//

#import "MDSOfferView.h"
#import "MDSCircularProgressView.h"
#import "MDSSpinningArcView.h"
#import "MDSStopSymbolView.h"

@interface MDSOfferView ()

@property (nonatomic,weak) MDSCircularProgressView *progressView;

@property (nonatomic,weak) MDSSpinningArcView *pendingView;

@property (nonatomic,weak) MDSStopSymbolView *stopSymbolView;

@property (nonatomic,weak) UIButton *button;

@property (nonatomic,copy) NSDictionary *titles;

@end

@implementation MDSOfferView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupOfferView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupOfferView];
    }
    return self;
}

- (void)setupOfferView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.button = button;
    self.button.layer.cornerRadius = 3;
    
    MDSCircularProgressView *progressView = [[MDSCircularProgressView alloc] initWithFrame:CGRectZero];
    progressView.userInteractionEnabled = NO;
    progressView.progress = 0;
    [self addSubview:progressView];
    self.progressView = progressView;
 
    MDSStopSymbolView *stopSymbolView = [[MDSStopSymbolView alloc] initWithFrame:CGRectZero];
    [self addSubview:stopSymbolView];
    self.stopSymbolView = stopSymbolView;
    
    MDSSpinningArcView *pendingView = [[MDSSpinningArcView alloc] initWithFrame:CGRectZero];
    pendingView.userInteractionEnabled = NO;
    [self addSubview:pendingView];
    self.pendingView = pendingView;
    
    [self setTitle:NSLocalizedString(@"GET", @"") forState:MDSOfferViewStateNormal];
    [self setTitle:NSLocalizedString(@"INSTALLED", @"") forState:MDSOfferViewStateDownloaded];
    
    [self updateButtonBorderColor];
    self.state = MDSOfferViewStateNormal;
}

- (double)progress {
    return self.progressView.progress;
}

- (void)setProgress:(double)progress {
    self.progressView.progress = progress;
}

- (void)setProgress:(double)progress animated:(BOOL)animated {
    [self.progressView setProgress:progress animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
    CGRect progressRect = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetHeight(self.bounds), 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
    self.progressView.frame = progressRect;
    self.pendingView.frame = progressRect;
    self.stopSymbolView.frame = progressRect;
    self.stopSymbolView.symbolSize = ceil(CGRectGetHeight(progressRect)/3.8);
}

- (void)updateButtonBorderColor {
    self.button.layer.borderColor = self.button.currentTitleColor.CGColor;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.button.tintColor = self.tintColor;
    [self updateButtonBorderColor];
}

- (void)setTitle:(NSString *)title forState:(MDSOfferViewState)state {
    NSMutableDictionary *titles = [NSMutableDictionary dictionaryWithDictionary:self.titles];
    titles[@(state)] = title ?: @"";
    self.titles = titles;
    [self updateForState];
}

- (NSString *)titleForState:(MDSOfferViewState)state {
    return self.titles[@(state)];
}

- (NSString *)currentTitle {
    return self.button.currentTitle;
}

- (void)setState:(MDSOfferViewState)state {
    _state = state;
    [self updateForState];
    [self setNeedsLayout];
}

- (void)updateForState {
    switch (self.state) {
        case MDSOfferViewStateNormal:
            [self.button setTitle:self.titles[@(MDSOfferViewStateNormal)] forState:UIControlStateNormal];
            self.button.layer.borderWidth = 1;
            self.progressView.hidden = YES;
            self.stopSymbolView.hidden = YES;
            [self.pendingView stopSpinning];
            self.pendingView.hidden = YES;
            break;
        case MDSOfferViewStatePendingDownload:
            [self.button setTitle:nil forState:UIControlStateNormal];
            self.button.layer.borderWidth = 0;
            self.progressView.hidden = YES;
            self.stopSymbolView.hidden = YES;
            [self.pendingView startSpinning];
            self.pendingView.hidden = NO;
            break;
        case MDSOfferViewStateDownloading:
            [self.button setTitle:nil forState:UIControlStateNormal];
            self.button.layer.borderWidth = 0;
            self.progressView.hidden = NO;
            self.stopSymbolView.hidden = NO;
            [self.pendingView stopSpinning];
            self.pendingView.hidden = YES;
            break;
        case MDSOfferViewStateDownloaded:
            [self.button setTitle:self.titles[@(MDSOfferViewStateDownloaded)] forState:UIControlStateNormal];
            [self.button setImage:nil forState:UIControlStateNormal];
            self.button.layer.borderWidth = 1;
            self.progressView.hidden = YES;
            self.stopSymbolView.hidden = YES;
            [self.pendingView stopSpinning];
            self.pendingView.hidden = YES;
            break;
        default:
            break;
    }
    [UIView performWithoutAnimation:^{
        [self.button layoutIfNeeded];
    }];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [self.button intrinsicContentSize];
    if (size.width < size.height) {
        size.width = size.height;
    }
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fittingSize = [self.button sizeThatFits:size];
    if (fittingSize.width < fittingSize.height) {
        fittingSize.width = fittingSize.height;
    }
    return fittingSize;
}

- (void)buttonTapped:(UIButton *)sender {
    if (self.actionHandler) {
        self.actionHandler(self);
    }
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    self.button.enabled = enabled;
    [self updateButtonBorderColor];
}

- (UIButton *)actionButton {
    return self.button;
}

@end
