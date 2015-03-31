//
//  MXWBook.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBook.h"

@interface MXWBook ()

@property (nonatomic) BOOL pdfSanbox;

@end

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
        _pdfSanbox = NO;
        
    }
    
    return self;
}

-(NSURL *) pdfURL {
    
    if (!self.pdfSanbox){
        
        NSString * sPDF = [NSString stringWithFormat:@"MXWbook_pdf_%@.%@",self.title,[self.pdfURL pathExtension]];
        
        self.pdfSanbox = YES;
        
        return [self setAndGetURLFromSandboxWithExternalURL:self.pdfURL
                                             andElementName:sPDF];
    } else return _pdfURL;
}


- (void) manageURLS {
    
    NSString * titledash = [self.title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSString * sCover = [NSString stringWithFormat:@"MXWbook_cover_%@.%@",titledash,[self.coverURL pathExtension]];
    //NSString * sPDF = [NSString stringWithFormat:@"MXWbook_pdf_%@.%@",self.title,[self.pdfURL pathExtension]];
    
    NSURL * localCoverURL =[self setAndGetURLFromSandboxWithExternalURL:self.coverURL
                                                         andElementName:sCover];
    
    //NSURL * localPdfURL = [self setAndGetURLFromSandboxWithExternalURL:self.pdfURL
    //                                                    andElementName:sPDF];
    
    self.coverURL = localCoverURL;
    
}

- (NSURL*) setAndGetURLFromSandboxWithExternalURL:(NSURL*) aURL
                                   andElementName:(NSString*) element {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray * fmURL = [fm URLsForDirectory: NSCachesDirectory
                                 inDomains: NSUserDomainMask];
    
    NSURL * urlF = [fmURL lastObject];
    
    urlF = [urlF URLByAppendingPathComponent:element];
    
    //NSData * eData= [NSData dataWithContentsOfURL:urlF];
    
    BOOL exist = [fm fileExistsAtPath:[urlF absoluteString]];
    
    if (!exist) {
        //UIImage * anImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
        [fm createFileAtPath:[urlF absoluteString]
                    contents:[NSData dataWithContentsOfURL:aURL]
                  attributes:nil];
    }
    
    return urlF;
}

@end
