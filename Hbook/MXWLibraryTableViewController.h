//
//  MXWLibraryTableViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/29/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@class MXWLibrary;

#define FAVORITE_SECTION 0
#define TAG_SECTION 1


@interface MXWLibraryTableViewController : UITableViewController

@property (strong,nonatomic) MXWLibrary * library;
@property (strong,nonatomic) NSArray * tags;

- (id) initWithLibray:(MXWLibrary*) library
                style:(UITableViewStyle) style;

@end
