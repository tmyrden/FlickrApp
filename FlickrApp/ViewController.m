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

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.searchTextField];

    [self setupConstraints];
}

- (void)setupConstraints {
    [self.searchTextField.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor].active = YES;
    [self.searchTextField.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor].active = YES;
    [self.searchTextField.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.searchTextField.heightAnchor constraintEqualToConstant:44];
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

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    [self performSegueWithIdentifier:@"ShowSearchResults" sender:self];
    [FlickrInterface clearData];
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
