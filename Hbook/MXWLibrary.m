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

@property (strong,nonatomic) NSArray * books;
@property (strong,nonatomic) NSArray * favorites;
@property (strong,nonatomic) NSDictionary * dTags;
@property (strong,nonatomic) NSDictionary * dAuthors;

@end

@implementation MXWLibrary

#pragma mark - init
- (id) init {
    
    if (self = [super init]) {
        _books = nil;
        _favorites = nil;
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
    NSDictionary *jsonDictionary = nil;
    NSArray *jsonArray = nil;
    
    if([jsonResults isKindOfClass:[NSDictionary class]]) {
        
        jsonDictionary = jsonResults;
        [self setBooksWithDictionary: jsonDictionary];
    
    } else if([jsonResults isKindOfClass:[NSArray class]]) {
        
        jsonArray = jsonResults;
        
        
    } else {
        
        NSLog(@"Error at use JSON: JSON formata incorrect");
        
        *error = [NSError errorWithDomain:@"MXWLibray"
                                     code:4030
                                 userInfo:@{@"JSONFormat":@"Error at use JSON: JSON formata incorrect"}];
        
        return NO;
    }
    
    return YES;
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

- (void) setBooksWithArray:(NSArray*) jArray {
    for (id object in jArray) {
        [self setBooksWithDictionary:object];
    }
}

- (void) setBooksWithDictionary:(NSDictionary*) jDictionary {
    
}



#pragma mark - count functions
// functions for count
- (NSUInteger) countBooksForFavorites{
    return 0;
}

- (NSUInteger) countBooksForTitles{
    return 0;
}

- (NSUInteger) countBooksForTags:(NSString*) tag{
    return 0;
}

- (NSUInteger) countBooksForAuthors:(NSString*) author{
    return 0;
}

#pragma mark - groups functions
// functions groups
- (NSArray*) getTags{
    return nil;
}

- (NSArray*) getAuthors{
    return nil;
}


#pragma mark - get Books functions
// functions get books
- (MXWBook*) bookForFavoritesAtIndex:(NSUInteger) i{
    return nil;
}

- (MXWBook*) bookForTitlesAtIndex:(NSUInteger) i{
    return nil;
}

- (MXWBook*) bookForTag:(NSString*) tag AtIndex:(NSUInteger) i{
    return nil;
}

- (MXWBook*) bookForAuthor:(NSString*) author AtIndex:(NSUInteger) i{
    return nil;
}


#pragma mark - set Favorite functions
// functions to set favorites
- (void) markBookAsFavoriteWithBook: (MXWBook*) book{
    
}

- (void) markBookAsNotFavoriteWithBook: (MXWBook*) book{
    
}

@end
