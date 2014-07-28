//
//  NSArray+legalPermutations.m
//  wordJumble
//
//  Created by Zeev Vax on 7/27/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//

#import "NSArray+legalPermutations.h"

@implementation NSArray (legalPermutations)

- (void) doPermuteWithInput:(NSMutableArray *)input
                     iterationOutput:(NSMutableArray *)iterationOutput
                       used:(NSMutableArray *)used
                       size:(int)size
                      level:(int)level
                comulativeOutput: (NSMutableArray *)comulativeOutput
{
    if (size == level)
    {
        NSString *word = [iterationOutput componentsJoinedByString:@""];
        [comulativeOutput addObject:word];
        return;
    }
    
    level++;
    for (int i = 0; i < input.count; i++)
    {
        if ([used[i] boolValue])
        {
            continue;
        }
        
        used[i] = [NSNumber numberWithBool:YES];
        [iterationOutput addObject:input[i]];
        [self doPermuteWithInput:input iterationOutput:iterationOutput used:used
                            size:size level:level comulativeOutput:comulativeOutput];
        used[i] = [NSNumber numberWithBool:NO];
        [iterationOutput removeLastObject];
    }
    return;
}

- (NSArray *) getPermutations
{
    NSMutableArray *comulativeOutput = [[NSMutableArray alloc] init];
    
    NSMutableArray *iterationOutput = [[NSMutableArray alloc] init];
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.count; i++)
    {
        [used addObject:[NSNumber numberWithBool:NO]];
    }
    NSMutableArray *input =[self mutableCopy];
    for (int j = 2;j <=self.count;j++)
        [self doPermuteWithInput: input iterationOutput:iterationOutput used:used size:j level:0 comulativeOutput:comulativeOutput];
    
    return comulativeOutput;
}

@end
