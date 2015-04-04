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
        [self.fButton setTitle:@"Hide Favorite" forState:UIControlStateNormal];
    else
        [self.fButton setTitle:@"Show Favorite" forState:UIControlStateNormal];
    
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * valForDef = nil;
    
    if (self.showFavorite) {
        valForDef = @"YES";
    } else {
        valForDef = @"NO";
    }
    
    [defaults setObject:valForDef
                 forKey:@"showFavorite"];
    [defaults synchronize];
    
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
        [self.fButton setTitle:@"Hide Favorites" forState:UIControlStateNormal];
    else
        [self.fButton setTitle:@"Show Favorites" forState:UIControlStateNormal];
    
    [self.sectionSC  setSelectedSegmentIndex:self.sectionSelected];
    
}



@end
