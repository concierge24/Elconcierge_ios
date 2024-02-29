//
//  MyTextField.m
//  TextField
//
//  Created by Aseem 14 on 20/06/16.
//  Copyright © 2016 Aseem 14. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.delegate = self;
        
        self.clipsToBounds = YES;
        [self setLeftViewMode:UITextFieldViewModeAlways];
        
    }
    return self;

}
- (void)deleteBackward {
    
    [super deleteBackward];
    
    if ([_myDelegate respondsToSelector:@selector(textFieldDidDelete)]){
        
        [_myDelegate textFieldDidDelete];
    }
}

@end
