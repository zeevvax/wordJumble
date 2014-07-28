//
//  wordsJumbleLegalWordsModel.h
//  wordJumble
//
//  Created by Zeev Vax on 7/26/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wordsJumbleLegalWordsModel : NSObject
@property (nonatomic, getter = isReady) BOOL ready;

+(wordsJumbleLegalWordsModel *)sharedInstance;
- (void)loadAllLegalWords;
- (BOOL)isLegalWord:(NSString *)word;

@end
