//
//  MXWLibaryTableViewCell.m
//  Hbook
//
//  Created by Pepe Padilla on 15/03/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibaryTableViewCell.h"
#import "Header.h"

@implementation MXWLibaryTableViewCell

-(void) startWithSection: (NSUInteger) section
            showFavorite: (BOOL) showF{
    self.sectionSelected = section;
    self.showFavorite = showF;
    
    [self.sectionSC  setSelectedSegmentIndex:self.sectionSelected];
    
    if (self.showFavorite)
        self.fButton.titleLabel.text =@"Hide Favorite";
    else
        self.fButton.titleLabel.text =@"Show Favorite";
}

+ (NSString*) cellID{
    return NSStringFromClass([self class]);
}

- (IBAction)displaySegment:(UISegmentedControl *)sender {
    
    self.sectionSelected = sender.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * valForDef = nil;
    
    if (sender.selectedSegmentIndex == SECTION_TITLES) {
        valForDef = @"SECTION_TITLES";
    } else if (sender.selectedSegmentIndex == SECTION_TAGS) {
        valForDef = @"SECTION_TAGS";
    } else if (sender.selectedSegmentIndex == SECTION_TITLES) {
        valForDef = @"SECTION_TITLES";
    }
    
    [defaults setObject:valForDef
                 forKey:@"sectionSelected"];
    [defaults synchronize];
    
    [self.sectionSC  setSelectedSegmentIndex:self.sectionSelected];
    if (self.showFavorite)
        self.fButton.titleLabel.text =@"Hide Favorite";
    else
        self.fButton.titleLabel.text =@"Show Favorite";
    
}

- (IBAction)displayFavorite:(id)sender {
    
    
    self.showFavorite = !self.showFavorite;
    
    // Avisar al delegado -(void) libraryCellViewController: (MXWLibaryTableViewCell *) lVC;
    if ([self.delegate respondsToSelector:@selector(libraryCellViewController:)]) {
        [self.delegate libraryCellViewController:self];
    }
    
    [self.sectionSC  setSelectedSegmentIndex:self.sectionSelected];

    if (self.showFavorite)
        self.fButton.titleLabel.text =@"Hide Favorite";
    else
        self.fButton.titleLabel.text =@"Show Favorite";
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    if (self.showFavorite)
        self.fButton.titleLabel.text =@"Hide Favorite";
    else
        self.fButton.titleLabel.text =@"Show Favorite";
    
}

- (void) prepareForReuse{
    // Desinitalization code
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
