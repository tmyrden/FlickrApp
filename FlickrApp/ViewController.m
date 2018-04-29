//
//  ViewController.m
//  FlickrApp
//
//  Created by Thomas Myrden on 2018-04-29.
//  Copyright © 2018 myrden.com. All rights reserved.
//

#import "ViewController.h"
#import "FlickrInterface.h"
#import "SearchResultsCollectionViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic) UITextField *searchTextField;
@property (nonatomic) UIButton *pastSearchesButton;
@property (nonatomic) UIButton *searchButton;
@property (nonatomic) UIButton *clearCacheButton;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.searchTextField];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.pastSearchesButton];
    [self.view addSubview:self.clearCacheButton];

    [self setupConstraints];
}

- (void)setupConstraints {
    [self.searchTextField.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor].active = YES;
    [self.searchTextField.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor].active = YES;
    [self.searchTextField.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.searchTextField.heightAnchor constraintEqualToConstant:44].active = YES;

    [self.searchButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.searchButton.topAnchor constraintEqualToAnchor:self.searchTextField.bottomAnchor].active = YES;

    [self.pastSearchesButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.pastSearchesButton.topAnchor constraintEqualToAnchor:self.searchButton.bottomAnchor].active = YES;

    [self.clearCacheButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.clearCacheButton.topAnchor constraintEqualToAnchor:self.pastSearchesButton.bottomAnchor].active = YES;

}

#pragma mark - View getters

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _searchTextField.backgroundColor = [UIColor redColor];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)pastSearchesButton {
    if (!_pastSearchesButton) {
        _pastSearchesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pastSearchesButton setTitle:@"Past Searches" forState:UIControlStateNormal];
        [_pastSearchesButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_pastSearchesButton addTarget:self action:@selector(didPressPastSearchesButton:) forControlEvents:UIControlEventTouchUpInside];
        _pastSearchesButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pastSearchesButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(didPressSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _searchButton;
}

- (UIButton *)clearCacheButton {
    if (!_clearCacheButton) {
        _clearCacheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearCacheButton setTitle:@"Clear Cache" forState:UIControlStateNormal];
        [_clearCacheButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_clearCacheButton addTarget:self action:@selector(didPressClearCacheButton:) forControlEvents:UIControlEventTouchUpInside];
        _clearCacheButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _clearCacheButton;
}

- (void)didPressPastSearchesButton:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ShowPastSearches" sender:self];
}

- (void)didPressClearCacheButton:(UIButton *)sender {
    [FlickrInterface clearData];
}

#pragma mark - UITextViewDelegate

- (void)didPressSearchButton:(UIButton *)sender {
    [self.searchTextField resignFirstResponder];

    [self performSegueWithIdentifier:@"ShowSearchResults" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    [self performSegueWithIdentifier:@"ShowSearchResults" sender:self];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSearchResults"]) {
        SearchResultsCollectionViewController *vc = segue.destinationViewController;
        vc.searchQuery = self.searchTextField.text;
        self.searchTextField.text = @"";
    }
}

@end
