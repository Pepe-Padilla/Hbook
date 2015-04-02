//
//  MXWLibraryTableViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/29/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@class MXWLibrary;
@class MXWBook;

#define FAVORITE_SECTION 0
#define TAG_SECTION 1


@class MXWLibraryTableViewController;


@protocol MXWLibraryTableViewControllerDelegate <NSObject>

@optional
-(void) libraryTableViewController: (MXWLibraryTableViewController *) lVC
                     didSelectBook: (MXWBook *) aBook;


@end


@interface MXWLibraryTableViewController : UITableViewController <MXWLibraryTableViewControllerDelegate>

@property (strong,nonatomic) MXWLibrary * library;
@property (strong,nonatomic) NSArray * tags;
@property(weak, nonatomic) id<MXWLibraryTableViewControllerDelegate> delegate;

- (id) initWithLibray:(MXWLibrary*) library
                style:(UITableViewStyle) style;

@end
