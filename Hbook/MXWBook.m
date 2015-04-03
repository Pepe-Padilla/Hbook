//
//  MXWBook.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
#import "MXWBook.h"
#import "Header.h"

@interface MXWBook ()


@end

@implementation MXWBook


#pragma mark - Inicializadores
- (id) initWithTitle: (NSString*) title
             authors: (NSArray*) authors
                tags: (NSArray*) tags
            coverURL: (NSURL*) coverURL
              pdfURL: (NSURL*) pdfURL{
    
    if (self = [super init]) {
        _title = title;
        _authors = authors;
        _tags = tags;
        _coverURL = coverURL;
        _pdfURL = pdfURL;
        _pdfSanbox = NO;
        _favorite = NO;
        
    }
    
    return self;
}

-(void) managePdfURL {
    
    NSString * sPDF = [NSString stringWithFormat:@"MXWbook_pdf_%@.%@",self.title,[self.pdfURL pathExtension]];
    
    self.pdfSanbox = YES;
    
    self.pdfURL = [self setAndGetURLFromSandboxWithExternalURL:self.pdfURL
                                                andElementName:sPDF];
    
}


- (void) manageURLS {
    
    NSString * titledash = [self.title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSString * sCover = [NSString stringWithFormat:@"MXWbook_cover_%@.%@",titledash,[self.coverURL pathExtension]];
    
    NSString * sPDF = [NSString stringWithFormat:@"MXWbook_pdf_%@.%@",self.title,[self.pdfURL pathExtension]];
    
    NSURL * localCoverURL =[self setAndGetURLFromSandboxWithExternalURL:self.coverURL
                                                         andElementName:sCover];
    
    self.coverURL = localCoverURL;
    
    self.pdfSanbox = [self isInSandbowWithElementName:sPDF];
    
    NSString * sfavorite= [self defaultMangerWithNewValIfNotExist:@"NO"
                           andKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",self.title]];
    
    self.favorite = [sfavorite isEqualToString:@"YES"];
    
}

- (NSURL*) setAndGetURLFromSandboxWithExternalURL:(NSURL*) aURL
                                   andElementName:(NSString*) element {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlF = [fmURL lastObject];
    
    urlF = [urlF URLByAppendingPathComponent:element];
    
    BOOL exist = [fm fileExistsAtPath:[urlF path]];
    
    if (!exist) {
        //UIImage * anImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
        [fm createFileAtPath:[urlF path]
                    contents:[NSData dataWithContentsOfURL:aURL]
                  attributes:nil];
    }
    
    return urlF;
}

-(BOOL) isInSandbowWithElementName:(NSString*)element {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlF = [fmURL lastObject];
    
    urlF = [urlF URLByAppendingPathComponent:element];
    
    return  [fm fileExistsAtPath:[urlF path]];
}

- (id)defaultMangerWithNewValIfNotExist:(id)newVal
                             andKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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

#pragma mark - set Favorite functions
// functions to set favorites
- (void) markBookAsFavorite{
    if (!self.favorite){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES"
                     forKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",self.title]];
        [defaults synchronize];
        
        self.favorite = YES;
        
        // mandamos una notificación
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        NSDictionary * dict = @{BOOK_FAVORITE : self};
        
        NSNotification * n = [NSNotification notificationWithName: FBOOK_DID_CHANGE_NOTIFICATION
                                                           object: self
                                                         userInfo: dict];
        [nc postNotification:n];
    }
}

- (void) markBookAsNotFavorite{
    if (self.favorite){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO"
                     forKey:[NSString stringWithFormat:@"MXWbook_favorite_%@",self.title]];
        [defaults synchronize];
        
        self .favorite = NO;
        
        // mandamos una notificación
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        NSDictionary * dict = @{BOOK_FAVORITE : self};
        
        NSNotification * n = [NSNotification notificationWithName: FBOOK_DID_CHANGE_NOTIFICATION
                                                           object: self
                                                         userInfo: dict];
        [nc postNotification:n];
    }
}


- (BOOL) isEqual:(id)object{
    if ([object isKindOfClass:[MXWBook class]]) {
        
        MXWBook * oBook = object;
        
        return ([self.title isEqual:oBook.title] && [self.authors isEqual:oBook.authors]);
    }
    
    return NO;
    
}


@end
