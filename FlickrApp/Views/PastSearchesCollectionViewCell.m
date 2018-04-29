//
//  PastSearchesCollectionViewCell.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "PastSearchesCollectionViewCell.h"

@implementation PastSearchesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.button];

        self.backgroundColor = [UIColor lightGrayColor];

        [self.button.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [self.button.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [self.button.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
        [self.button.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _button;
}

@end
