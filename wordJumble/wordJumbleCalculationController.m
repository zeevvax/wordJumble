//
//  wordJumbleCalculationController.m
//  wordJumble
//
//  Created by Zeev Vax on 7/26/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//

#import "wordJumbleCalculationController.h"
#import "NSArray+legalPermutations.h"
#import "wordsJumbleLegalWordsModel.h"

@interface wordJumbleCalculationController()

@property (nonatomic, strong) NSMutableSet *result;
@end

@implementation wordJumbleCalculationController

- (id)init
{
    self = [super self];
    if (self)
    {
        self.result = [NSMutableSet new];
    }
    return self;
}

- (void)calculatePossibleWords:(NSString *)inputString
{
    dispatch_async(dispatch_get_global_queue(0, 0),^()
    {
        [self.result removeAllObjects];
        NSArray *wordsPermutations = [self getPermutations:inputString];
        wordsJumbleLegalWordsModel *legalWords = [wordsJumbleLegalWordsModel sharedInstance];
        for (NSString *s in wordsPermutations)
        {
            if([legalWords isLegalWord:s] && ![s isEqualToString:inputString])
            {
                [self.result addObject:s];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^()
                       {
                           [[NSNotificationCenter defaultCenter]
                            postNotificationName:calculationControllerDidFinish object:nil];
                       });
    });
}

- (NSArray *) getPermutations:(NSString *)input
{
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [input length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [input characterAtIndex:i]];
        [chars addObject:ichar];
    }
    
    NSArray *wordsPermutations = [chars getPermutations];

    return wordsPermutations;
}

- (NSSet *)getPossibleWords;
{
    return [self.result copy];
}
@end

NSString * const calculationControllerDidFinish =@"calculationControllerDidFinish";
