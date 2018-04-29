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

@property (nonatomic) FlickrQuery *flickrQuery;
@property (nonatomic, weak) AppDelegate *appDelegate;
@property (nonatomic, weak) NSManagedObjectContext *context;

@end

@implementation FlickrInterface

- (instancetype)initWithQuery:(FlickrQuery *)flickrQuery {
    self = [super init];
    if (self) {
        self.flickrQuery = flickrQuery;
        self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.context = self.appDelegate.persistentContainer.viewContext;
    }
    return self;
}

- (void)query {
    __block NSInteger pageCount = [self.flickrQuery.pageCount integerValue];
    pageCount++;
    self.flickrQuery.pageCount = [NSNumber numberWithInteger:pageCount];
    NSURL *downloadUrl = [self urlFromQuery];

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:downloadUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return;
        }

        id flickrResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSArray *photos = flickrResponse[@"photos"][@"photo"];

        [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block FlickrPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"FlickrPhoto" inManagedObjectContext:self.context];

            photo.url_s = obj[@"url_s"];
            photo.itemId = obj[@"id"];
            photo.width_s = [NSNumber numberWithFloat:[obj[@"width_s"] floatValue]];
            photo.height_s = [NSNumber numberWithFloat:[obj[@"height_s"] floatValue]];
            NSInteger itemNumber = [self.flickrQuery.itemCount integerValue];
            photo.itemNumber = [NSNumber numberWithInteger:itemNumber++];
            self.flickrQuery.itemCount = [NSNumber numberWithInteger:itemNumber];

            photo.query = self.flickrQuery;

            NSURL *photoUrl = [NSURL URLWithString:obj[@"url_s"]];
            NSURLSessionDataTask *photoTask = [[NSURLSession sharedSession] dataTaskWithURL:photoUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                photo.photoData = data;

                [self.appDelegate saveContext];
            }];

            [photoTask resume];
        }];

        [self.appDelegate saveContext];
    }];

    [downloadTask resume];
}

- (NSURL *)urlFromQuery {
    NSString *baseUrl = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=%@&extras=url_s&format=json&nojsoncallback=1&per_page=10&page=%@&sort=relevance";

    NSString *finalUrl = [NSString stringWithFormat:baseUrl, self.flickrQuery.queryString, self.flickrQuery.pageCount];

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

    NSFetchRequest *queryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FlickrQuery"];

    NSArray<FlickrQuery *> *queries = [objectContext executeFetchRequest:queryFetchRequest error:nil];

    for (FlickrQuery *query in queries) {
        [objectContext deleteObject:query];
    }

    [appDelegate saveContext];
}

@end
