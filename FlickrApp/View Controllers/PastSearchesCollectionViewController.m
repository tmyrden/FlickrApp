//
//  PastSearchesCollectionViewController.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "PastSearchesCollectionViewController.h"
#import "PastSearchesCollectionViewCell.h"
#import "AppDelegate.h"
#import "FlickrInterface.h"
#import "FlickrPhoto.h"
#import "FlickrQuery.h"
#import "SearchResultsCollectionViewController.h"

@interface PastSearchesCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertedIndices;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *updatedIndices;
@property (nonatomic) FlickrInterface *flickrInterface;
@property (nonatomic) NSString *searchQuery;

@end

@implementation PastSearchesCollectionViewController

static NSString * const resultsReuseIdentifier = @"PastSearchesCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updatedIndices = [NSMutableArray new];
    self.insertedIndices = [NSMutableArray new];
    self.title = @"Past Searches";

    [self.collectionView registerClass:[PastSearchesCollectionViewCell class] forCellWithReuseIdentifier:resultsReuseIdentifier];

    [self.fetchedResultsController performFetch:nil];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FlickrQuery"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryString" ascending:YES]];
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
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeDelete:
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
    PastSearchesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resultsReuseIdentifier forIndexPath:indexPath];

    FlickrQuery *query = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell.button setTitle:query.queryString forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(didPressPastSearchItem:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)didPressPastSearchItem:(UIButton *)sender {
    self.searchQuery = [sender titleForState:UIControlStateNormal];
    [self performSegueWithIdentifier:@"ShowPastSearch" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPastSearch"]) {
        SearchResultsCollectionViewController *vc = segue.destinationViewController;
        vc.searchQuery = self.searchQuery;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.contentSize.width, 64);
}

@end
