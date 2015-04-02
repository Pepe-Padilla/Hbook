//
//  MXWBookViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/31/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;

@class MXWBook;
#import "MXWLibraryTableViewController.h"

@interface MXWBookViewController : UIViewController <UISplitViewControllerDelegate,MXWLibraryTableViewControllerDelegate>

@property (strong, nonatomic) MXWBook * book;
@property (weak, nonatomic) IBOutlet UIImageView * photoBook;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel * tagsLabel;
@property (weak, nonatomic) IBOutlet UIButton * pdfB;
@property (weak, nonatomic) IBOutlet UISwitch * favoriteS;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * activityView;


-(IBAction)displayPDFBook:(id)sender;
-(IBAction)toggleFavorite:(id)sender;


-(id) initWithBook: (MXWBook *) book;



@end
