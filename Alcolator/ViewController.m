//
//  ViewController.m
//  Alcolator
//
//  Created by Sameer Totey on 10/7/14.
//  Copyright (c) 2014 Sameer Totey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *numBeers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldDidChange:(UITextField *)sender {
    // Make sure the text is a number
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        // clear the field because the user did not enter a number
        sender.text = nil;
    }
}

- (IBAction)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider values changed to %f", sender.value);
    self.numBeers.text = [NSString stringWithFormat:@"%.1f", sender.value];
    [self.numBeers sizeToFit];
    [self.view setNeedsDisplay];
    [self.beerPercentTextField resignFirstResponder];
}

- (IBAction)buttonPressed:(UIButton *)sender {
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

- (IBAction)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}


@end
