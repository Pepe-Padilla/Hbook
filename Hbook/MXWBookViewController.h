//
//  MXWBookViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/31/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;

@class MXWBook;

@interface MXWBookViewController : UIViewController

@property (strong, nonatomic) MXWBook * book;
@property (weak, nonatomic) IBOutlet UIImageView * photoBook;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel * tagsLabel;
@property (weak, nonatomic) IBOutlet UIButton * favoriteB;
@property (weak, nonatomic) IBOutlet UIButton * pdfB;


-(IBAction)displayPDFBook:(id)sender;
-(IBAction)toggleyFavorite:(id)sender;


-(id) initWithBook: (MXWBook *) book;



@end
