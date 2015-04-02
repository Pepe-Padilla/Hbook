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

-(IBAction)toggleFavorite:(id)sender{
    if (self.book.favorite) {
        //[self.favoriteB setImage:[UIImage imageNamed:@"starOff.png"]
        //                forState:UIControlStateNormal];
        
        [self.favoriteS setOn:NO animated:YES];
        
        self.book.favorite = NO;
        
        //NSLog(@"favorite yes to no on toggleFavorite");
        
    } else {
        //[self.favoriteB setImage:[UIImage imageNamed:@"starOn.png"]
        //                forState:UIControlStateNormal];
        
        [self.favoriteS setOn:YES animated:YES];
        self.book.favorite = YES;
        
        //NSLog(@"favorite no to yes on toggleFavorite");
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
        [self.favoriteS setOn:YES animated:NO];
        
        //NSLog(@"favorite yes on wiewWillApeer");
        
        //[self.favoriteB setImage:[UIImage imageNamed:@"starOn.png"]
        //                forState:UIControlStateNormal];
    } else {
        [self.favoriteS setOn:NO animated:NO];
        
        //NSLog(@"favorite no on wiewWillApeer");
        //[self.favoriteB setImage:[UIImage imageNamed:@"starOff.png"]
        //                forState:UIControlStateNormal];
    }
    
    UIImage *btnImage = [UIImage imageNamed:@"wood.png"];
    [self.pdfB setImage:btnImage forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end