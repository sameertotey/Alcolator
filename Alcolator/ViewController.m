//
//  ViewController.m
//  Alcolator
//
//  Created by Sameer Totey on 10/7/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UILabel *numBeers;
@property (weak, nonatomic) UIButton *calculateButton;
@property (weak, nonatomic) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@end

@implementation ViewController

- (void) loadView {
    // Allocate and initialize the all-encompassing view
    self.view = [[UIView alloc] init];
    
    // Allocate and initialize each of our views and the gesture recognizer
    UITextField *textField = [[UITextField alloc] init];
    UISlider *slider = [[UISlider alloc] init];
    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
    // Add each view and the gesture recognizer as the view's subviews
    [self.view addSubview:textField];
    [self.view addSubview:slider];
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:button];
    [self.view addGestureRecognizer:tap];
    
    // Assign the views and gesture recognizer to our properties
    self.beerPercentTextField = textField;
    self.beerCountSlider = slider;
    self.resultLabel = label1;
    self.numBeers = label2;
    self.calculateButton = button;
    self.hideKeyboardTapGestureRecognizer = tap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Set our primary view's background color to lightGrayColor
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // Tells the text field that `self`, this instance of `BLCViewController` should be treated as the text field's delegate
    self.beerPercentTextField.delegate = self;
    
    // Set the placeholder text
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");
    self.numBeers.text = @"1.0";
    
    self.beerPercentTextField.backgroundColor = [UIColor whiteColor];
    self.beerPercentTextField.textColor = [UIColor darkTextColor];
    self.numBeers.textColor = [UIColor darkTextColor];
    self.calculateButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.4 blue:0.3 alpha:1.0];
    self.resultLabel.backgroundColor = [UIColor whiteColor];
    self.numBeers.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.5 brightness:0.5 alpha:1.0];
    
    
    // Tells `self.beerCountSlider` that when its value changes, it should call `[self -sliderValueDidChange:]`.
    // This is equivalent to connecting the IBAction in our previous checkpoint
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Set the minimum and maximum number of beers
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    // Tells `self.calculateButton` that when a finger is lifted from the button while still inside its bounds, to call `[self -buttonPressed:]`
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the title of the button
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate command") forState:UIControlStateNormal];
    
    // Tells the tap gesture recognizer to call `[self -tapGestureDidFire:]` when it detects a tap.
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    // Gets rid of the maximum number of lines on the label
    self.resultLabel.numberOfLines = 0;
    
    
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = 320;
    CGFloat padding = 20;
    CGFloat itemWidth = viewWidth - padding - padding;
    CGFloat itemHeight = 44;
    
    self.beerPercentTextField.frame = CGRectMake(padding, padding, itemWidth, itemHeight);
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfTextField + padding, itemWidth - 100, itemHeight);
    
    self.numBeers.frame = CGRectMake(itemWidth - 100 + 2 * padding, bottomOfTextField + padding, 100 - 2 * padding, itemHeight);
    
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    self.resultLabel.frame = CGRectMake(padding, bottomOfSlider + padding, itemWidth, itemHeight * 3);
    
    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame);
    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
    
    // set the resizing behavior
//    self.view.autoresizesSubviews = NO;
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleWidth;
//    self.calculateButton.autoresizingMask = UIViewAutoresizingNone;
//    self.resultLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;

    // try setting the autolayout programmatically
    self.calculateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.beerCountSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.numBeers.translatesAutoresizingMaskIntoConstraints = NO;
    self.beerPercentTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_calculateButton, _beerCountSlider, _numBeers, _beerPercentTextField, _resultLabel);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_calculateButton]-50-|" options:0 metrics:nil views:viewsDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:|-60-[_beerPercentTextField]-20-[_beerCountSlider]-20-[_resultLabel]-20-[_calculateButton]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|-30-[_beerPercentTextField]-30-|"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|-20-[_beerCountSlider]-30-[_numBeers]-20-|"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:[_numBeers(==_beerCountSlider)]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:[_beerPercentTextField]-20-[_numBeers]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|-20-[_resultLabel]-20-|"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"[_calculateButton(>=50)]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"[_beerCountSlider(>=100,<=200)]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"[_numBeers(>=50,<=100)]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];

    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:[_calculateButton(==44)]"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    
    [self.view addConstraints:constraints];
    [self.calculateButton sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)sender {
    // Make sure the text is a number
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        // clear the field because the user did not enter a number
        sender.text = nil;
    }
 }

- (void)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider values changed to %f", sender.value);
    self.numBeers.text = [NSString stringWithFormat:@"%.1f", sender.value];
    [self.numBeers sizeToFit];
    [self.view setNeedsDisplay];
    [self.beerPercentTextField resignFirstResponder];
}

- (void)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    
    // first calculate how much alcohol there is in all those bottles
    int numOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12;                // assume they are 12 ounce bottles
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    float ouncesOfAlcoholPerBeer = alcoholPercentageOfBeer * ouncesInOneBeerGlass;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numOfBeers;
    
    // now calculate equivalent amount for wine
    float ouncesInOneWineGlass = 5;       // wine glasses are usually 5 ounces
    float alcoholPercentageOfWine = 0.13;   // 13% is the average
    
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWineGlass;
    
    // decide whether to use "beer"/"beers" and "glass"/"glasses"
    NSString *beerText;
    
    if (numOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
    // generate the result text, and display it on the label
    NSString *resultText = [NSString stringWithFormat:@"%d %@ contains as much alcohol as %.1f %@ of wine",
                            numOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
    [self.resultLabel sizeToFit];
    [self.view setNeedsDisplay];
}

- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}


@end
