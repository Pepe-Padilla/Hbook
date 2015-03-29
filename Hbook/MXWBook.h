//
//  MXWBook.h
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXWBook : NSObject

@property (copy,nonatomic)  NSString * title;
@property (strong,nonatomic) NSArray * authors;
@property (strong,nonatomic) NSArray * tags;
@property (strong,nonatomic) NSURL * coverURL;
@property (strong,nonatomic) NSURL * pdfURL;
@property (nonatomic) BOOL  favorite;


// inicializador
- (id) initWithTitle: (NSString*) title
             authors: (NSArray*) authors
                tags: (NSArray*) tags
            coverURL: (NSURL*) coverURL
              pdfURL: (NSURL*) pdfURL
            favorite: (BOOL) favorite;


@end