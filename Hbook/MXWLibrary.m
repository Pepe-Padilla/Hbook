//
//  MXWLibrary.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibrary.h"
#import "MXWBook.h"



@interface MXWLibrary()

@property (strong,nonatomic) NSMutableArray * books;
@property (strong,nonatomic) NSArray * oTitles;
@property (strong,nonatomic) NSMutableArray * titles;
@property (strong,nonatomic) NSMutableArray * favorites;
@property (strong,nonatomic) NSMutableDictionary * dTags;
@property (strong,nonatomic) NSMutableDictionary * dAuthors;

@end

@implementation MXWLibrary

#pragma mark - init
- (id) init {
    
    if (self = [super init]) {
        _books = nil;
        _favorites = nil;
        _titles = nil;
        _dTags = nil;
        _dAuthors = nil;
    }
    
    return self;
}


#pragma mark - chargeLibrary
- (BOOL) chargeLibrayWithError:(NSError**) error{
    // Accedemos a UserDafaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Actualizamos desde repositorio al menos 1 vez al día de otro modo leemos desde nuestro SandBox
    BOOL needRecharge = YES;
    NSDate * lastRun = [self dateDefaultMangerWithUserDefaults:defaults
                                                        andKey:@"lastRun"];
    
    NSTimeInterval secondsBetewen = [lastRun timeIntervalSinceDate:[NSDate date]];
    
    if (secondsBetewen < 86400) {
        needRecharge = NO;
    }
    
    // Accedemos a la URL correcta
    NSError * err = nil;
    NSString * jString = nil;
    if (needRecharge) {
        
        jString = [self getFromRepositoryWithError:&err];
        
        if (!jString) {
            jString = [self getFromSandboxWithError:&err];
            
            if (!jString) {
                NSLog(@"No se ha podido abrir ninguna biblioteca");
                *error=err;
                return NO;
            }
        }
        
        [self setSandbox:jString
                   error:&err];
        
    } else {
        jString = [self getFromSandboxWithError:&err];
        
        if (!jString) {
            jString = [self getFromRepositoryWithError:&err];
            
            if (!jString) {
                NSLog(@"No se ha podido abrir ninguna biblioteca");
                *error=err;
                return NO;
            }
        }
    }
    
    // Accedemos a al JSON
    NSData * jsonData = [jString dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:0
                                                       error:&err];
    
    if (!jsonResults) {
        NSLog(@"Error at JSON: %@",err.userInfo);
        *error = err;
        return NO;
    }
    
    
    // trabajamos con el JSON
    if([jsonResults isKindOfClass:[NSDictionary class]]) {
        
        [self manageBooksWithDictionary:jsonResults
                      usingUserDefaults:defaults];
    
    } else if([jsonResults isKindOfClass:[NSArray class]]) {
        
        [self manageBooksWithArray:jsonResults
                 usingUserDafaults:defaults];
        
        
    } else {
        
        NSLog(@"Error at use JSON: JSON formata incorrect");
        
        *error = [NSError errorWithDomain:@"MXWLibray"
                                     code:4030
                                 userInfo:@{@"JSONFormat":@"Error at use JSON: JSON formata incorrect"}];
        
        return NO;
    }
    
    // Establecemos elementos de la biblioteca
    [self orderElements];
    
    return YES;
}

- (void) orderElements{
    NSMutableDictionary *dTitles = nil;
    for (int i = 0; i<self.books.count; i++) {
        [dTitles addEntriesFromDictionary:@{[[self.books objectAtIndex:i] title]:@(i)}];
    }
    
    self.oTitles = [dTitles keysSortedByValueUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (id element in self.oTitles) {
        long j = [[dTitles objectForKey:element] longValue];
        MXWBook * b = [self.books objectAtIndex:j];
        
        // metemos los apuntadores en cada grupo
        [self.titles addObject:@(j)];
        
        if (b.favorite) {
            [self.favorites addObject:@(j)];
        }
        
        for (id idA in b.authors){
            NSArray * arr = [self.dAuthors objectForKey:idA];
            if (arr) {
                [self.dAuthors setObject:[arr arrayByAddingObject:@(j)]
                                  forKey:idA];
            } else {
                [self.dAuthors setObject:@[@(j)]
                                  forKey:idA];
            }
            
        }
        
        for (id idA in b.tags){
            NSArray * arr = [self.dTags objectForKey:idA];
            if (arr) {
                [self.dTags setObject:[arr arrayByAddingObject:@(j)]
                                  forKey:idA];
            } else {
                [self.dTags setObject:@[@(j)]
                                  forKey:idA];
            }
            
        }
        
    }
}

- (NSDate*)dateDefaultMangerWithUserDefaults:(NSUserDefaults*) defaults andKey:(NSString*)key{
    
    NSDate*aDate=[defaults objectForKey:key];
    
    if (!aDate) {
        // Si no hay nada, lo añadimos
        aDate =[NSDate date];
        [defaults setObject:aDate
                     forKey:key];
        [defaults synchronize];
    }
    
    return aDate;
}

- (id)defaultMangerWithUserDefaults:(NSUserDefaults*) defaults
                andNewValIfNotExist:(id)newVal
                             andKey:(NSString*)key{
    
    id anId=[defaults objectForKey:key];
    
    if (!anId) {
        // Si no hay nada, lo añadimos
        anId = newVal;
        [defaults setObject:anId
                     forKey:key];
        [defaults synchronize];
    }
    
    return anId;
}

- (NSString*) getFromRepositoryWithError:(NSError**)error{
    NSURL * urlJ=[NSURL URLWithString:@""];
    NSError *err= nil;
    NSString * strJson= [NSString stringWithContentsOfURL:urlJ
                                                 encoding:NSUTF8StringEncoding
                                                    error:&err];
    
    if (!strJson) {
        NSLog(@"Error at get from Repository(%@): %@",[urlJ path],err.userInfo);
        *error=err;
    }
    
    return strJson;
}

- (NSString*) getFromSandboxWithError:(NSError**)error {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlJ = [fmURL lastObject];
    
    urlJ = [urlJ URLByAppendingPathComponent:@"library.json"];
    
    NSError *err= nil;
    
    NSString * strJson= [NSString stringWithContentsOfURL:urlJ
                                                 encoding:NSUTF8StringEncoding
                                                    error:&err];
    
    if (!strJson) {
        NSLog(@"Error at get form Sandbox: %@",err.userInfo);
        *error=err;
    }

    return strJson;
}

- (BOOL) setSandbox:(NSString*) jsonString error:(NSError**)error{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlJ = [fmURL lastObject];
    
    urlJ = [urlJ URLByAppendingPathComponent:@"library.json"];
    
    NSError *err= nil;
    
    BOOL rc= [jsonString writeToURL: urlJ
                         atomically: YES
                           encoding: NSUTF8StringEncoding
                              error: &err];
    
    if (rc == NO) {
        NSLog(@"Error at save Sandbox: %@",err.userInfo);
        *error=err;
    }
    
    return rc;
}

- (void) manageBooksWithArray:(NSArray*) jArray
            usingUserDafaults:(NSUserDefaults*) defaults{
    for (id object in jArray) {
        [self manageBooksWithDictionary:object
                      usingUserDefaults:defaults];
    }
}

- (void) manageBooksWithDictionary:(NSDictionary*) jDictionary
                 usingUserDefaults:(NSUserDefaults*) defaults{
    NSString * title= [jDictionary objectForKey:@"title"];
    NSString * authors= [jDictionary objectForKey:@"authors"];
    NSString * tags= [jDictionary objectForKey:@"tags"];
    
    NSURL * coverURL= [[NSURL alloc] initWithString:[jDictionary objectForKey:@"image_url"]];
    NSURL * pdfURL= [[NSURL alloc] initWithString:[jDictionary objectForKey:@"pdf_url"]];
    
    NSURL * localCoverURL =[self setAndGetURLFromSandboxWithExternalURL:coverURL
                                                         andElementName:[NSString stringWithFormat:@"MXWbook_cover_%@%@",title,[coverURL pathExtension]]];
    
    NSURL * localPdfURL = [self setAndGetURLFromSandboxWithExternalURL:pdfURL
                                                        andElementName:[NSString stringWithFormat:@"MXWbook_pdf_%@%@",title,[pdfURL pathExtension]]];
    
    BOOL favorite = NO;
    
    NSArray * aAuthors = [authors componentsSeparatedByString:@", "];
    NSArray * aTags = [tags componentsSeparatedByString:@", "];
    
    NSString * sfavorite= [self defaultMangerWithUserDefaults:defaults
                                          andNewValIfNotExist:@"NO"
                                                       andKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",title]];
    
    favorite = [sfavorite isEqualToString:@"YES"];
    
    MXWBook * book = [[MXWBook alloc] initWithTitle:title
                                            authors:aAuthors
                                               tags:aTags
                                           coverURL:localCoverURL
                                             pdfURL:localPdfURL
                                           favorite:favorite];
    
    [self.books addObject:book];
    
}

- (NSURL*) setAndGetURLFromSandboxWithExternalURL:(NSURL*) aURL
                                   andElementName:(NSString*) element {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlF = [fmURL lastObject];
    
    urlF = [urlF URLByAppendingPathComponent:element];
    
    NSData * eData= [NSData dataWithContentsOfURL:urlF];
    
    if (eData == nil) {
        eData = [NSData dataWithContentsOfURL:aURL];
        [eData writeToURL:urlF
               atomically:YES];
    }
    
    return urlF;
}

#pragma mark - count functions
// functions for count
- (NSUInteger) countBooksForFavorites{
    return self.favorites.count;
}

- (NSUInteger) countBooksForTitles{
    return self.titles.count;
}

- (NSUInteger) countBooksForTags:(NSString*) tag{
    return [[self.dTags objectForKey:tag] count];
}

- (NSUInteger) countBooksForAuthors:(NSString*) author{
    return [[self.dAuthors objectForKey:author] count];
}

#pragma mark - groups functions
// functions groups
- (NSArray*) getTags{
    return [self.dTags allKeys];
}

- (NSArray*) getAuthors{
    return [self.dAuthors allKeys];
}


#pragma mark - get Books functions
// functions get books
- (MXWBook*) bookForFavoritesAtIndex:(NSUInteger) i{
    id idIndex = [self.favorites objectAtIndex:i];
    
    NSInteger index = [idIndex integerValue];
    
    MXWBook * b = [self.books objectAtIndex:index];
    
    return b;
}

- (MXWBook*) bookForTitlesAtIndex:(NSUInteger) i{
    id idIndex = [self.titles objectAtIndex:i];
    
    NSInteger index = [idIndex integerValue];
    
    MXWBook * b = [self.books objectAtIndex:index];
    
    return b;
}

- (MXWBook*) bookForTag:(NSString*) tag AtIndex:(NSUInteger) i{
    id idIndex = [[self.dTags objectForKey:tag] objectAtIndex:i];
    
    NSInteger index = [idIndex integerValue];
    
    MXWBook * b = [self.books objectAtIndex:index];
    
    return b;
}

- (MXWBook*) bookForAuthor:(NSString*) author AtIndex:(NSUInteger) i{
    id idIndex = [[self.dAuthors objectForKey:author] objectAtIndex:i];
    
    NSInteger index = [idIndex integerValue];
    
    MXWBook * b = [self.books objectAtIndex:index];
    
    return b;
}


#pragma mark - set Favorite functions
// functions to set favorites
- (void) markBookAsFavoriteWithBook: (MXWBook*) book{
    if (!book.favorite){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES"
                     forKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",book.title]];
        [defaults synchronize];
        
        book.favorite = YES;
    }
    
    [self orderFavorites];
}

- (void) markBookAsNotFavoriteWithBook: (MXWBook*) book{
    if (book.favorite){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO"
                     forKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",book.title]];
        [defaults synchronize];
        
        book.favorite = NO;
    }
    
    [self orderFavorites];
}

- (void) orderFavorites{
    NSMutableDictionary *dTitles = nil;
    for (int i = 0; i<self.books.count; i++) {
        [dTitles addEntriesFromDictionary:@{[[self.books objectAtIndex:i] title]:@(i)}];
    }
    
    for (id element in self.oTitles) {
        long j = [[dTitles objectForKey:element] longValue];
        MXWBook * b = [self.books objectAtIndex:j];
        
        if (b.favorite) {
            [self.favorites addObject:@(j)];
        }
    }
}

@end
