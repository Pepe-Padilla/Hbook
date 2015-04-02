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

@interface MXWLibraryTableViewController ()

@end

@implementation MXWLibraryTableViewController


// sobre escribios el inicializador por defecto
- (id) initWithLibray:(MXWLibrary*) library
                style:(UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _library = library;
        _tags = [library getTags];
        self.title = @"Favorite / Tags";
    }
    
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == FAVORITE_SECTION) {
        NSString * aint= [@([self.library countBooksForFavorites]) stringValue];
        return [NSString stringWithFormat:@"Favorites (%@)",aint];
    } else {
        return [self.tags objectAtIndex:section-1];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.tags.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == FAVORITE_SECTION) {
        return [self.library countBooksForFavorites];
    } else {
        return [self.library countBooksForTags:[self.tags objectAtIndex:section-1]];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MXWBook * aBook;
    
    if (indexPath.section == FAVORITE_SECTION) {
        aBook = [self.library bookForFavoritesAtIndex:indexPath.row];
    } else {
        aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section - 1]
                                 AtIndex:indexPath.row];
    }
    
    /* obsoleto (ahora con delegados):
    // crar el bookVC
    //MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithBook:aBook];
    
    //Hacer un push
    //[self.navigationController pushViewController:bVC animated:YES];
    */
    
    
    // Avisar al delegado
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        [self.delegate libraryTableViewController:self
                                    didSelectBook:aBook];
    }
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Averiguar modelo
    MXWBook * aBook = nil;
    
    if (indexPath.section == FAVORITE_SECTION) {
        aBook = [self.library bookForFavoritesAtIndex:indexPath.row];
    } else {
        aBook = [self.library bookForTag:[self.tags objectAtIndex:indexPath.section-1]
                                 AtIndex:indexPath.row];
    }
    
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

-(void) libraryTableViewController: (MXWLibraryTableViewController *) lVC
                     didSelectBook: (MXWBook *) aBook{
    
    MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithBook:aBook];
    
    [self.navigationController pushViewController:bVC animated:YES];
    
}

@end
