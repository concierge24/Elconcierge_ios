//
//  EBAEventbritePurchaseViewController.h
//  InEvent
//
//  Created by Pedro Góes on 12/16/15.
//  Copyright © 2015 InEvent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void(^PSTCKAuthCallback)(void);

/**
 **/
@interface PSTCKAuthViewController : UIViewController

/** ************************************************************************************************ **
 * @name Initializers
 ** ************************************************************************************************ **/

/**
 * Default initializer.
 * @param authURL the authorization url from Paystack.
 * @param completion A standard block.
 * @returns An initialized instance
 **/
- (id)initWithURL:(NSURL *)authURL handler:(PSTCKAuthCallback)completion;

@end
