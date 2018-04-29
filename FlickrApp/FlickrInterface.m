//
//  FlickrInterface.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "FlickrInterface.h"
#import "FlickrPhoto.h"
#import "AppDelegate.h"
@import UIKit;

@interface FlickrInterface ()

@property (nonatomic) NSString *searchQuery;
@property (nonatomic) NSInteger pageNumber;
@property (nonatomic) NSInteger itemNumber;

@end

@implementation FlickrInterface

- (instancetype)initWithQuery:(NSString *)searchQuery {
    self = [super init];
    if (self) {
        self.pageNumber = 1;
        self.searchQuery = searchQuery;
        self.itemNumber = 0;
    }
    return self;
}

- (void)query {
    NSURL *downloadUrl = [self urlFromQuery];

    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *objectContext = appDelegate.persistentContainer.viewContext;

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:downloadUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }

        self.pageNumber++;

        id flickrResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSArray *photos = flickrResponse[@"photos"][@"photo"];

        [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block FlickrPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"FlickrPhoto" inManagedObjectContext:objectContext];

            photo.url_s = obj[@"url_s"];
            photo.itemId = obj[@"id"];
            photo.width_s = [NSNumber numberWithFloat:[obj[@"width_s"] floatValue]];
            photo.height_s = [NSNumber numberWithFloat:[obj[@"height_s"] floatValue]];
            photo.itemNumber = [NSNumber numberWithInteger:self.itemNumber++];

            NSURL *photoUrl = [NSURL URLWithString:obj[@"url_s"]];
            NSURLSessionDataTask *photoTask = [[NSURLSession sharedSession] dataTaskWithURL:photoUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                photo.photoData = data;

                [appDelegate saveContext];
            }];

            [photoTask resume];
        }];

        [appDelegate saveContext];
    }];

    [downloadTask resume];
}

- (NSURL *)urlFromQuery {
    NSString *baseUrl = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=%@&extras=url_s&format=json&nojsoncallback=1&per_page=10&page=%i&sort=relevance";

    NSString *finalUrl = [NSString stringWithFormat:baseUrl, self.searchQuery, self.pageNumber];

    return [NSURL URLWithString:finalUrl];
}

+ (void)clearData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *objectContext = appDelegate.persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FlickrPhoto"];

    NSArray<FlickrPhoto *> *photos = [objectContext executeFetchRequest:fetchRequest error:nil];

    for (FlickrPhoto *photo in photos) {
        [objectContext deleteObject:photo];
    }

    [appDelegate saveContext];
}

@end
