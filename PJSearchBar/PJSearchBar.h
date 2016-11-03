//
//  PJSearchBar.h
//  PJSearchBar
//
//  Created by 孙培杰 on 16/11/3.
//  Copyright © 2016年 sunpeijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJSearchBarDelegate <NSObject>

@end

@interface PJSearchBar : UISearchBar<UISearchBarDelegate>

@property (nonatomic, weak) id <PJSearchBarDelegate> delegate;
@property (nonatomic, strong) UITextField *searchTextField;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@end
