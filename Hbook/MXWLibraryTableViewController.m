//
//  MXWLibraryTableViewController.m
//  Hbook
//
//  Created by Pepe Padilla on 15/29/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWLibraryTableViewController.h"
#import "MXWLibrary.h"
#import "MXWBook.h"
#import "MXWBookViewController.h"
#import "Header.h"



@interface MXWLibraryTableViewController ()

@property (strong, nonatomic) MXWLibaryTableViewCell * lTVC;

@end

@implementation MXWLibraryTableViewController


#pragma mark - inits
// sobre escribios el inicializador por defecto
- (id) initWithLibray:(MXWLibrary*) library
                style:(UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _library = library;
        _tags = [library getTags];
        _authors = [library getAuthors];
        _lTVC  = [[MXWLibaryTableViewCell alloc] init];
        //self.title = @"Favorite / Tags";
    }
    
    return self;
}

#pragma mark - View life
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter ];
    [nc addObserver:self
           selector:@selector(notifyThatFBookDidChange:)
               name:FBOOK_DID_CHANGE_NOTIFICATION
             object:nil];
    
    [self.library orderFavorites];
    [self.tableView reloadData];
    
    UINib *nib = [UINib nibWithNibName:[MXWLibaryTableViewCell cellID]
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[MXWLibaryTableViewCell cellID]];
    
    [self manageLibraryCell];
    
}



- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
//FBOOK_DID_CHANGE_NOTIFICATION
-(void)notifyThatFBookDidChange:(NSNotification*) notification{
    //sacamos el personaje
    MXWBook * aBook = [notification.userInfo objectForKey:BOOK_FAVORITE];
    
    if (aBook) {
        
        [self.library orderFavorites];
        
        [self.tableView reloadData];
    
    }
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SELECT_SECTION)
        return 110;
    else
        return [super tableView:tableView
        heightForRowAtIndexPath:indexPath];
}


- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section{
    
    if (section == SELECT_SECTION) {
        return nil;
    }
    
    if (self.lTVC.showFavorite) {
        
        if (section == FAVORITE_SECTION) {
            NSString * aint= [@([self.library countBooksForFavorites]) stringValue];
            return [NSString stringWithFormat:@"Favorites (%@)",aint];
        } else {
            if (self.lTVC.sectionSelected == SECTION_TITLES) {
                return @"All Titles";
            } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
                return [self.tags objectAtIndex:section-2];;
            } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
                return [self.authors objectAtIndex:section-2];
            }
        }
    } else {
        if (self.lTVC.sectionSelected == SECTION_TITLES) {
            return @"All Titles";
        } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
            return [self.tags objectAtIndex:section-1];;
        } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
            return [self.authors objectAtIndex:section-1];
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    int slecS = 0;
    
    if (self.lTVC.sectionSelected == SECTION_TITLES) {
        slecS = 1;
    } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
        slecS = self.tags.count;
    } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
        slecS = self.authors.count;
    }
    
    if (self.lTVC.showFavorite) {
        return slecS + 2;
    } else {
        return slecS + 1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if (section == SELECT_SECTION) {
        return 1;
    }
    
    if (self.lTVC.showFavorite) {
        
        if (section == FAVORITE_SECTION) {
            return [self.library countBooksForFavorites];
        } else {
            if (self.lTVC.sectionSelected == SECTION_TITLES) {
                return [self.library countBooksForTitles];
            } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
                return [self.library countBooksForTags:[self.tags objectAtIndex:section-2]];
            } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
                return [self.library countBooksForAuthors:[self.authors objectAtIndex:section-2]];
            }
            else return 0;
        }
    
    } else {
    
        if (self.lTVC.sectionSelected == SECTION_TITLES) {
            return [self.library countBooksForTitles];
        } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
            return [self.library countBooksForTags:[self.tags objectAtIndex:section-1]];
        } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
            return [self.library countBooksForAuthors:[self.authors objectAtIndex:section-1]];
        }
        
        else return 0;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != SELECT_SECTION) {
    
        MXWBook * aBook =nil;
        if (self.lTVC.showFavorite) {
            if (indexPath.section == FAVORITE_SECTION) {
                aBook = [self.library bookForFavoritesAtIndex:indexPath.row];
            } else {
                if (self.lTVC.sectionSelected == SECTION_TITLES) {
                    aBook = [self.library bookForTitlesAtIndex:indexPath.row];
                    
                } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
                    aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section - 2]
                                             AtIndex:indexPath.row];
                } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
                    aBook = [self.library bookForAuthor:[self.authors objectAtIndex:indexPath.section - 2]
                                                AtIndex:indexPath.row];
                }
            }
        } else {
            if (self.lTVC.sectionSelected == SECTION_TITLES) {
                aBook = [self.library bookForTitlesAtIndex:indexPath.row];
                
            } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
                aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section - 1]
                                         AtIndex:indexPath.row];
            } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
                aBook = [self.library bookForAuthor:[self.authors objectAtIndex:indexPath.section - 1]
                                            AtIndex:indexPath.row];
            }
        }
        
        /* obsoleto (ahora con delegados):
         // crar el bookVC
         //MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithBook:aBook];
         
         //Hacer un push
         //[self.navigationController pushViewController:bVC animated:YES];
         */
        
        if (aBook) {
            // Avisar al delegado
            if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
                [self.delegate libraryTableViewController:self
                                            didSelectBook:aBook];
            }
            
            // mandamos notificación
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            
            NSDictionary * dict = @{BOOK_CHANGE : aBook};
            
            NSNotification * n = [NSNotification notificationWithName: BOOK_DID_CHANGE_NOTIFICATION
                                                               object: self
                                                             userInfo: dict];
            [nc postNotification:n];
        }
    }
    
}

- (id)defaultMangerWithNewValIfNotExist:(id)newVal
                                 andKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    id anId=[defaults objectForKey:key];
    
    if (!anId) {
        // Si no hay nada, lo añadimos
        anId = newVal;
        [defaults setObject:anId
                     forKey:key];
        [defaults synchronize];
    }
    
    return anId;
}

- (void) manageLibraryCell{
    NSString * sShowF = [self defaultMangerWithNewValIfNotExist:@"YES"
                                                         andKey:@"showFavorite"];
    
    NSString * sSectSel = [self defaultMangerWithNewValIfNotExist:@"SECTION_TITLES"
                                                           andKey:@"sectionSelected"];
    
    int aInt= 0;
    
    if ([sSectSel isEqual:@"SECTION_TITLES"]) {
        aInt = SECTION_TITLES;
    } else if ([sSectSel isEqual:@"SECTION_TAGS"]) {
        aInt = SECTION_TAGS;
    } if ([sSectSel isEqual:@"SECTION_AUTHORS"]) {
        aInt = SECTION_AUTHORS;
    }
    
    [self.lTVC startWithSection: aInt
                   showFavorite: [sShowF isEqual:@"YES"]];
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXWBook * aBook =nil;
    if (indexPath.section == SELECT_SECTION) {
        MXWLibaryTableViewCell * cell= [tableView
                                        dequeueReusableCellWithIdentifier:[MXWLibaryTableViewCell cellID]
                                                             forIndexPath:indexPath];
        
        //if (cell == nil){
        //    cell = [[MXWLibaryTableViewCell alloc] initWithStyle:<#(UITableViewCellStyle)#> reuseIdentifier:<#(NSString *)#>];
        //}
        
        [cell startWithSection: self.lTVC.sectionSelected
                  showFavorite: self.lTVC.showFavorite];
        
        cell.delegate=self;
        
        return cell;
    }
    else if (self.lTVC.showFavorite) {
        if (indexPath.section == FAVORITE_SECTION) {
            aBook = [self.library bookForFavoritesAtIndex:indexPath.row];
        } else {
            if (self.lTVC.sectionSelected == SECTION_TITLES) {
                aBook = [self.library bookForTitlesAtIndex:indexPath.row];
                
            } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
                aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section - 2]
                                         AtIndex:indexPath.row];
            } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
                aBook = [self.library bookForAuthor:[self.authors objectAtIndex:indexPath.section - 2]
                                            AtIndex:indexPath.row];
            }
        }
    } else {
        if (self.lTVC.sectionSelected == SECTION_TITLES) {
            aBook = [self.library bookForTitlesAtIndex:indexPath.row];
            
        } else if (self.lTVC.sectionSelected == SECTION_TAGS) {
            aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section - 1]
                                     AtIndex:indexPath.row];
        } else if (self.lTVC.sectionSelected == SECTION_AUTHORS) {
            aBook = [self.library bookForAuthor:[self.authors objectAtIndex:indexPath.section - 1]
                                        AtIndex:indexPath.row];
        }
    }
    
    
    
    if (aBook) {
        //Crear celda
        static NSString * cellID = @"HMXWLibary";
        UITableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            // crear cell
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellID];
        }
        
        UIImage* imagen = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:aBook.coverURL]];
        
        //Configurar celda
        cell.imageView.image = imagen;
        cell.textLabel.text = aBook.title;
        cell.detailTextLabel.text = [aBook.authors componentsJoinedByString:@", "];
        
        //Devolver la celda
        return cell;
    }
    
    return nil;
}

-(void) libraryTableViewController: (MXWLibraryTableViewController *) lVC
                     didSelectBook: (MXWBook *) aBook{
    
    MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithBook:aBook];
    
    [self.navigationController pushViewController:bVC animated:YES];
    
}

-(void) libraryCellViewController: (MXWLibaryTableViewCell *) lVC{
    self.lTVC = lVC;
    
    [self.tableView reloadData];
    
}

@end
