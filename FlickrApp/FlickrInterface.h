//
//  FlickrInterface.h
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrQuery.h"

@interface FlickrInterface : NSObject

- (instancetype)initWithQuery:(FlickrQuery *)flickrQuery NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)query;
+ (void)clearData;

@end
