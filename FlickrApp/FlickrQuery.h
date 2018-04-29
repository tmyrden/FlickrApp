//
//  FlickrQuery.h
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FlickrQuery : NSManagedObject

@property (nonatomic, strong) NSString *queryString;

@end
