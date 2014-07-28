//
//  wordJumbleCalculationController.h
//  wordJumble
//
//  Created by Zeev Vax on 7/26/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//


#import <Foundation/Foundation.h>
extern NSString * const calculationControllerDidFinish;

@interface wordJumbleCalculationController : NSObject
- (void)calculatePossibleWords:(NSString *)inputString;
- (NSSet *)getPossibleWords;

@end
