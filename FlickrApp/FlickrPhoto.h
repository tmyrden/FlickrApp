//
//  FlickrPhoto.h
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FlickrQuery.h"

@interface FlickrPhoto : NSManagedObject

@property (nonatomic, strong) NSData *photoData;
@property (nonatomic, strong) NSString *url_s;
@property (nonatomic, strong) NSNumber *width_s;
@property (nonatomic, strong) NSNumber *height_s;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSNumber *itemNumber;
@property (nonatomic) FlickrQuery *query;

@end
