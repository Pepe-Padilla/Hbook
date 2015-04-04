//
//  MXWBookViewController.m
//  Hbook
//
//  Created by Pepe Padilla on 15/31/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWBookViewController.h"
#import "MXWBook.h"
#import "MXWPDFViewController.h"

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
    
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    [self.book managePdfURL];
    
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
    
    MXWPDFViewController * pdfVC = [[MXWPDFViewController alloc]
                                    initWithBook:self.book];
    
    //Hacer un push
    [self.navigationController pushViewController:pdfVC
                                         animated:YES];
}

-(IBAction)toggleFavorite:(id)sender{
    if (self.book.favorite) {
        [self.book markBookAsNotFavorite];
        
    } else {
        [self.book markBookAsFavorite];
    }
    
}

- (void) viewWillAppear:(BOOL)animated{
    // protocolos básico del view will Apear
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout= UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    [self manageBook];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) splitViewController:(UISplitViewController *)svc
    willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // tabla oculta
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    } else {
        //Se muestra la tabla
        self.navigationItem.leftBarButtonItem = nil;
    }

    
}

-(void) libraryTableViewController:(MXWLibraryTableViewController *)lVC
                     didSelectBook:(MXWBook *)aBook{
    
    self.book = aBook;
    
    [self manageBook];
    
}

-(void) manageBook{
    self.title = self.book.title;
    
    [self.activityView stopAnimating];
    [self.activityView setHidden:YES];
    
    self.titleLabel.text = self.book.title;
    self.authorsLabel.text = [NSString stringWithFormat:@"Authors: %@",[self.book.authors componentsJoinedByString:@", "]];
    self.tagsLabel.text = [NSString stringWithFormat:@"Book Tags: %@",[self.book.tags componentsJoinedByString:@", "]];
    
    
    UIImage * anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.book.coverURL]];
    self.photoBook.image = anImage;
    
    
    if (self.book.favorite) {
        [self.favoriteS setOn:YES animated:NO];
        
    } else {
        [self.favoriteS setOn:NO animated:NO];
        
    }
    
    if (!self.book.pdfSanbox) {
        UIImage * btnImage = [UIImage imageNamed:@"downloadIc.png"];
        [self.pdfB setImage:btnImage forState:UIControlStateNormal];
    }
    else {
        UIImage * btnImage = [UIImage imageNamed:@"wood.png"];
        [self.pdfB setImage:btnImage forState:UIControlStateNormal];
    }
}

@end
