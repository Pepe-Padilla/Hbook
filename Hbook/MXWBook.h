//
//  MXWBook.h
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface MXWBook : NSObject

@property (copy,nonatomic)  NSString * title;
@property (strong,nonatomic) NSArray * authors;
@property (strong,nonatomic) NSArray * tags;
@property (strong,nonatomic) NSURL * coverURL;
@property (strong,nonatomic) NSURL * pdfURL;
@property (nonatomic) BOOL  favorite;
@property (nonatomic) BOOL pdfSanbox;



// inicializador
- (id) initWithTitle: (NSString*) title
             authors: (NSArray*) authors
                tags: (NSArray*) tags
            coverURL: (NSURL*) coverURL
              pdfURL: (NSURL*) pdfURL;

- (void) manageURLS;
- (void) managePdfURL;
- (void) markBookAsFavorite;
- (void) markBookAsNotFavorite;

- (BOOL) isEqual:(id)object;

- (void) updateFavorite;

@end
