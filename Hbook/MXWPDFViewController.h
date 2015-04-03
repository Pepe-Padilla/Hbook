//
//  MXWPDFViewController.h
//  Hbook
//
//  Created by Pepe Padilla on 15/02/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;

@class MXWBook;

#import "ReaderViewController.h"

@interface MXWPDFViewController : UIViewController <ReaderViewControllerDelegate>

@property (strong, nonatomic) MXWBook * book;
@property (strong, nonatomic) ReaderViewController *readerViewController;


-(id) initWithBook:(MXWBook *) aBook;

@end
