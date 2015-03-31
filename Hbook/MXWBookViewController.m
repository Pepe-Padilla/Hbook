//
//  MXWBookViewController.m
//  Hbook
//
//  Created by Pepe Padilla on 15/31/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBookViewController.h"
#import "MXWBook.h"

@interface MXWBookViewController ()

@end

@implementation MXWBookViewController



-(id) initWithBook: (MXWBook *) book {
    if (self == [super initWithNibName:nil
                                bundle:nil]) {
        _book = book;
        self.title = book.title;
    }
    
    return self;
}

-(IBAction)displayPDFBook:(id)sender{
    //Crear un PDFVC
    //MXWPDFViewController * pVC = [[PDFWikiViewController alloc] initWithModel:self.model];
    
    //Hacer un push
    //[self.navigationController pushViewController:pVC animated:YES];
}

-(IBAction)toggleyFavorite:(id)sender{
    if (self.book.favorite) {
        [self.favoriteB setImage:[UIImage imageNamed:@"starOff.png"]
                        forState:UIControlStateNormal];
        
        self.book.favorite = NO;
        
    } else {
        [self.favoriteB setImage:[UIImage imageNamed:@"starOn.png"]
                        forState:UIControlStateNormal];
        
        self.book.favorite = YES;
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    // protocolos básico del view will Apear
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = [NSString stringWithFormat:@"Authors: %@",[self.book.authors componentsJoinedByString:@", "]];
    self.tagsLabel.text = [NSString stringWithFormat:@"Book Tags: %@",[self.book.tags componentsJoinedByString:@", "]];
    
    
    UIImage * anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.book.coverURL]];
    self.photoBook.image = anImage;
    
    if (self.book.favorite) {
        [self.favoriteB setImage:[UIImage imageNamed:@"starOn.png"]
                        forState:UIControlStateNormal];
    } else {
        [self.favoriteB setImage:[UIImage imageNamed:@"starOff.png"]
                        forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
