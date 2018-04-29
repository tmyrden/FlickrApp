//
//  SearchResultsCollectionViewController.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "SearchResultsCollectionViewController.h"
#import "SearchResultsCollectionViewCell.h"
#import "AppDelegate.h"
#import "FlickrInterface.h"
#import "FlickrPhoto.h"

@interface SearchResultsCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertedIndices;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *updatedIndices;
@property (nonatomic) FlickrInterface *flickrInterface;
@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation SearchResultsCollectionViewController

static NSString * const resultsReuseIdentifier = @"SearchResultsCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updatedIndices = [NSMutableArray new];
    self.insertedIndices = [NSMutableArray new];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.collectionView registerClass:[SearchResultsCollectionViewCell class] forCellWithReuseIdentifier:resultsReuseIdentifier];

    [self updateData];
}

- (void)updateData {
    if (self.searchQuery) {
        NSManagedObjectContext *objectContext = self.appDelegate.persistentContainer.viewContext;

        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FlickrQuery"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"queryString = %@", self.searchQuery];

        NSArray<FlickrQuery *> *queries = [objectContext executeFetchRequest:fetchRequest error:nil];

        if (queries.count > 0) {
            self.flickrInterface = [[FlickrInterface alloc] initWithQuery:queries[0]];
        } else {
            FlickrQuery *query = [NSEntityDescription insertNewObjectForEntityForName:@"FlickrQuery" inManagedObjectContext:objectContext];
            query.queryString = self.searchQuery;
            query.itemCount = @(0);
            query.pageCount = @(0);
            self.flickrInterface = [[FlickrInterface alloc] initWithQuery:query];
        }
    }
    
    [self.flickrInterface query];
    [self.fetchedResultsController performFetch:nil];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FlickrPhoto"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"query.queryString = %@", self.searchQuery];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"itemNumber" ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark <NSFetchedResultsControllerDelegate>

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.insertedIndices addObject:newIndexPath];

            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.updatedIndices addObject:indexPath];

            break;
        }
        // Not worrying about other Change Types in the context of this assignment
        default: {
            break;
        }
    }

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:self.insertedIndices];
        [self.insertedIndices removeAllObjects];
    } completion:^(BOOL finished) {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:self.updatedIndices];
            [self.updatedIndices removeAllObjects];
        } completion:nil];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[0].numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resultsReuseIdentifier forIndexPath:indexPath];
    
    FlickrPhoto *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    cell.imageView.image = [UIImage imageWithData:photo.photoData];

    if (indexPath.item + 1 == self.fetchedResultsController.sections[0].numberOfObjects) {
        [self.flickrInterface query];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhoto *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];

    CGFloat ratio = [photo.height_s floatValue] / [photo.width_s floatValue];

    CGFloat height = collectionView.contentSize.width * ratio;

    return CGSizeMake(collectionView.contentSize.width, height);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
