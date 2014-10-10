//
//  MainMenuViewController.m
//  Alcolator
//
//  Created by Sameer Totey on 10/9/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ViewController.h"
#import "WhiskeyViewController.h"

@interface MainMenuViewController ()
@property (nonatomic, strong) UIButton *wineButton;
@property (nonatomic, strong) UIButton *whiskeyButton;

@end

@implementation MainMenuViewController

- (void)loadView {
    // Allocate and initialize the all-encompassing view
    self.view = [[UIView alloc] init];
    
    // Allocate and initialize buttons
    self.wineButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.whiskeyButton = [UIButton buttonWithType:UIButtonTypeSystem];

    // Add buttons as the view's subviews
    [self.view addSubview:self.whiskeyButton];
    [self.view addSubview:self.wineButton];
    
    // Set the titles of the buttons
    [self.wineButton setTitle:NSLocalizedString(@"Wine", @"Wine") forState:UIControlStateNormal];
    [self.whiskeyButton setTitle:NSLocalizedString(@"Whiskey", @"Whiskey") forState:UIControlStateNormal];
    
    // Set the outlets of these buttons
    [self.wineButton addTarget:self action:@selector(winePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiskeyButton addTarget:self action:@selector(whiskeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.wineButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    self.whiskeyButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.view.backgroundColor = [UIColor darkGrayColor];

 }

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
 
    
    CGRect wineButtonFrame, whiskeyButtonFrame;
    CGRectDivide(self.view.bounds, &wineButtonFrame, &whiskeyButtonFrame, CGRectGetWidth(self.view.bounds) / 2, CGRectMaxXEdge);
    
    self.wineButton.frame = wineButtonFrame;
    self.whiskeyButton.frame = whiskeyButtonFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set the title of the view
    self.title = NSLocalizedString(@"Select Alcolator", @"Select Alcolator");
}

- (void) winePressed:(UIButton *) sender {
    ViewController *wineVC = [[ViewController alloc] init];
    [self.navigationController pushViewController:wineVC animated:YES];
}

- (void) whiskeyPressed:(UIButton *) sender {
    WhiskeyViewController *whiskeyVC = [[WhiskeyViewController alloc] init];
    [self.navigationController pushViewController:whiskeyVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
