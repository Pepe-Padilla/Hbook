//
//  MXWLibrary.h
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@import Foundation;

@class MXWBook;

@interface MXWLibrary : NSObject

// inicialización tardía de biblioteca, no me gusta la idea de usar un init tan pesado
- (BOOL) chargeLibrayWithError:(NSError**) error;


// functions for count
- (NSUInteger) countBooksForFavorites;
- (NSUInteger) countBooksForTitles;
- (NSUInteger) countBooksForTags:(NSString*) tag;
- (NSUInteger) countBooksForAuthors:(NSString*) author;

// functions groups
- (NSArray*) getTags;
- (NSArray*) getAuthors;

// functions get books
- (MXWBook*) bookForFavoritesAtIndex:(NSUInteger) i;
- (MXWBook*) bookForTitlesAtIndex:(NSUInteger) i;
- (MXWBook*) bookForTag:(NSString*) tag AtIndex:(NSUInteger) i;
- (MXWBook*) bookForAuthor:(NSString*) author AtIndex:(NSUInteger) i;

// functions to set favorites
- (void) markBookAsFavoriteWithBook: (MXWBook*) book;
- (void) markBookAsNotFavoriteWithBook: (MXWBook*) book;

@end
