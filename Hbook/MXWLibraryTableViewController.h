//
//  MXWLibraryTableViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/29/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//


@import UIKit;

#import "MXWLibaryTableViewCell.h"
@class MXWLibrary;
@class MXWBook;

#define SELECT_SECTION 0
#define FAVORITE_SECTION 1
#define SELECTED_SECTION 2


@class MXWLibraryTableViewController;


@protocol MXWLibraryTableViewControllerDelegate <NSObject>

@optional
-(void) libraryTableViewController: (MXWLibraryTableViewController *) lVC
                     didSelectBook: (MXWBook *) aBook;


@end


@interface MXWLibraryTableViewController : UITableViewController <MXWLibraryTableViewControllerDelegate, MXWLibaryTableViewCellTableViewControllerDelegate>


@property (strong,nonatomic) MXWLibrary * library;
@property (strong,nonatomic) NSArray * tags;
@property (strong,nonatomic) NSArray * authors;

@property (weak, nonatomic) id<MXWLibraryTableViewControllerDelegate> delegate;

- (id) initWithLibray:(MXWLibrary*) library
                style:(UITableViewStyle) style;

@end
