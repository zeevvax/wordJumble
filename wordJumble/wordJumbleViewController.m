//
//  wordJumbleViewController.m
//  wordJumble
//
//  Created by Zeev Vax on 7/26/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//

#import "wordJumbleViewController.h"
#import "wordsJumbleLegalWordsModel.h"
#import "wordJumbleCalculationController.h"

@interface wordJumbleViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITextView *resultText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) wordJumbleCalculationController *calculatorController;
@property (strong, nonatomic) NSCharacterSet * forbidenChars;
@end

@implementation wordJumbleViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLegalWordsModel];
    [self setupCalculationController];
    self.forbidenChars = [[NSCharacterSet letterCharacterSet] invertedSet];
}

- (void)setupLegalWordsModel
{
	// Do any additional setup after loading the view, typically from a nib.
    wordsJumbleLegalWordsModel *legalWordsModel = [wordsJumbleLegalWordsModel sharedInstance];
    [legalWordsModel loadAllLegalWords];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    [legalWordsModel addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setupCalculationController
{
    self.calculatorController = [[wordJumbleCalculationController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calculationControllerDidFinish:)
                                                 name:calculationControllerDidFinish
                                               object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^()
    {
        if (object == [wordsJumbleLegalWordsModel sharedInstance])
        {
            if ([wordsJumbleLegalWordsModel sharedInstance].isReady)
                [self.activityIndicator stopAnimating];
            else
                [self.activityIndicator startAnimating];
        }
    });
}

- (void)calculationControllerDidFinish:(NSNotification *)n
{
    [self.activityIndicator stopAnimating];
    NSSet *possibleWords = [self.calculatorController getPossibleWords];
    NSMutableString *wordsText = [NSMutableString new];
    if (possibleWords.count > 0)
    {
        [possibleWords enumerateObjectsUsingBlock:^(id obj, BOOL *stop)
         {
             [wordsText appendFormat:@"%@\n",obj];
         }];
    }
    else
        [wordsText appendString:@"Sorry no jumble words where found"];
    self.resultText.text = wordsText;
}
#pragma mark - action

- (IBAction)jumbleIt:(id)sender
{
    if ([self checkIfInputLegalAndAlert])
        [self.inputText resignFirstResponder];
}

- (BOOL)checkIfInputLegalAndAlert
{
    NSRange range = [self.inputText.text rangeOfCharacterFromSet:self.forbidenChars];
    if (range.location != NSNotFound)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Only letters are allowd"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [[wordsJumbleLegalWordsModel sharedInstance] isReady];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.resultText setText: @""];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.activityIndicator startAnimating];
    [self.calculatorController calculatePossibleWords:self.inputText.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self checkIfInputLegalAndAlert])
    {
        [self.inputText resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
