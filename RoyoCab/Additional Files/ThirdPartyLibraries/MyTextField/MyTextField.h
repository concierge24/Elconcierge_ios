//
//  MyTextField.h
//  TextField
//
//  Created by Aseem 14 on 20/06/16.
//  Copyright © 2016 Aseem 14. All rights reserved.
//

#import <UIKit/UIKit.h>

//create delegate protocol

@protocol MyTextFieldDelegate <NSObject>
@optional
- (void)textFieldDidDelete;
@end

@interface MyTextField : UITextField<UIKeyInput,UITextFieldDelegate>

@property (nonatomic, assign) id<MyTextFieldDelegate> myDelegate;

@end
