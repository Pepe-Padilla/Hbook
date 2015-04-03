//
//  MXWLibaryTableViewCell.h
//  Hbook
//
//  Created by Pepe Padilla on 15/03/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

@import UIKit;
@class MXWLibaryTableViewCell;

@protocol MXWLibaryTableViewCellTableViewControllerDelegate <NSObject>

@optional
-(void) libraryCellViewController: (MXWLibaryTableViewCell *) lVC;


@end


@interface MXWLibaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *fButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sectionSC;

@property (nonatomic) BOOL showFavorite;
@property (nonatomic) NSInteger sectionSelected;

@property (weak, nonatomic) id<MXWLibaryTableViewCellTableViewControllerDelegate> delegate;


-(void) startWithSection: (NSUInteger) section
            showFavorite: (BOOL) showF;

- (IBAction)displaySegment:(UISegmentedControl *)sender;
- (IBAction)displayFaborite:(id)sender;

+ (NSString*) cellID;

@end
