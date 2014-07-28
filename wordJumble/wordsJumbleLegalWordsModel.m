//
//  wordsJumbleLegalWordsModel.m
//  wordJumble
//
//  Created by Zeev Vax on 7/26/14.
//  Copyright (c) 2014 Zeev Vax. All rights reserved.
//

#import "wordsJumbleLegalWordsModel.h"

@interface wordsJumbleLegalWordsModel() 
@property (nonatomic,strong)NSMutableSet *legalWords;
@property (nonatomic,strong)NSSet *projectFiles;
@end

static wordsJumbleLegalWordsModel *gLegalWords;

@implementation wordsJumbleLegalWordsModel

+(wordsJumbleLegalWordsModel *)sharedInstance
{
    if (!gLegalWords)
        gLegalWords = [[wordsJumbleLegalWordsModel alloc] init];
    return gLegalWords;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.projectFiles = [NSSet setWithArray:@[@"Default.png", @"Default@2x.png", @"Default-568h@2x.png", @"en.lproj", @"info.plist", @"PkgInfo", @"wordJumble"]];
        self.legalWords = [NSMutableSet new];
    }
    return self;
}

- (void)loadAllLegalWords
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^()
    {
        NSString *path = [[NSBundle mainBundle] resourcePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        
        NSArray *directoryAndFileNames = [fm contentsOfDirectoryAtPath:path error:&error];
        if (error)
            NSLog(@"Error reading bundle %@", error);
        for (NSString *file in directoryAndFileNames)
        {
            if (![self.projectFiles member:file])
                [self loadWordsFromFile:[NSString stringWithFormat:@"%@/%@",path,file]];
        }
        self.ready = YES;
    });
}

- (void)loadWordsFromFile:(NSString *)path
{
    NSError *error;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    
    if (error)
        NSLog(@"Error reading file %@ \n %@", path, error);
    NSArray *words = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]];
    NSMutableArray *lowercaseWords = [NSMutableArray new];
    for (NSString *word in words)
    {
        [lowercaseWords addObject:[word lowercaseString]];
    }
    [self.legalWords addObjectsFromArray:lowercaseWords];
}

- (BOOL)isLegalWord:(NSString *)word
{
    return self.ready && [self.legalWords member:word];
}

@end

