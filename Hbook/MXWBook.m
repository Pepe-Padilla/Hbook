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
             bookURL: (NSURL*) bookURL
              pdfURL: (NSURL*) pdfURL
            favorite: (BOOL)favorite{
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _bookURL = bookURL;
        _pdfURL = pdfURL;
        _favorite = favorite;
    }
    
    return self;
}

@end
