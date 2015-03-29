//
//  MXWBook.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBook.h"

@implementation MXWBook


#pragma mark - Inicializadores
- (id) initWithTitle: (NSString*) title
             authors: (NSArray*) authors
                tags: (NSArray*) tags
            coverURL: (NSURL*) coverURL
              pdfURL: (NSURL*) pdfURL
            favorite: (BOOL)favorite{
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _coverURL = coverURL;
        _pdfURL = pdfURL;
        _favorite = favorite;
    }
    
    return self;
}

@end
