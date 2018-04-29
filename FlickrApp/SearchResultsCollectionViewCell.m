//
//  SearchResultsCollectionViewCell.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "SearchResultsCollectionViewCell.h"

@implementation SearchResultsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];

        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.imageView.image = nil;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

@end
