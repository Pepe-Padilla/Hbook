//
//  MXWBook.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBook.h"

@interface MXWBook ()


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
    
    NSURL * aURL = _pdfURL;
    
    if (!self.pdfSanbox){
        
        NSLog([aURL pathExtension]);
        
        
        NSString * sPDF = [NSString stringWithFormat:@"MXWbook_pdf_%@.%@",self.title,[aURL pathExtension]];
        
        self.pdfSanbox = YES;
        
        aURL = [self setAndGetURLFromSandboxWithExternalURL:aURL
                                                andElementName:sPDF];
        
        _pdfURL = aURL;
        
        return aURL;
        
    } else return aURL;
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
    
    BOOL exist = [fm fileExistsAtPath:[urlF path]];
    
    if (!exist) {
        //UIImage * anImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
        [fm createFileAtPath:[urlF path]
                    contents:[NSData dataWithContentsOfURL:aURL]
                  attributes:nil];
    }
    
    return urlF;
}

@end
