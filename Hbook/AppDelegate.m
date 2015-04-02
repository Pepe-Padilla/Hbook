//
//  AppDelegate.m
//  Hbook
//
//  Created by Pepe Padilla on 15/28/03.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "AppDelegate.h"
#import "MXWLibrary.h"
#import "MXWLibraryTableViewController.h"
#import "MXWBookViewController.h"
#import "MXWBook.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    MXWLibrary* mLibray = [[MXWLibrary alloc] init];
    
    NSError * err = nil;
    
    if (![mLibray chargeLibrayWithError:&err])
        NSLog(@"Error at charge Libray: %@", err.userInfo);
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureForPad:mLibray];
    } else {
        [self configureForPhone:mLibray];
    }
    
    
    
    [[self window] makeKeyAndVisible];
    
    return YES;
}

-(void) configureForPad:(MXWLibrary*)libray{
    // creamos un controlador
    MXWLibraryTableViewController * lVC = [[MXWLibraryTableViewController  alloc]
                                           initWithLibray:libray style: UITableViewStylePlain];
    
    
    MXWBook* aBook = nil;
    
    
    if (libray.countBooksForFavorites > 0) {
        aBook = [libray bookForFavoritesAtIndex:0];
    } else {
        aBook = [libray bookForTag:[libray.getTags objectAtIndex:0] AtIndex:0];
    }
    
    
    MXWBookViewController * bVC = [[MXWBookViewController alloc] initWithBook:aBook];
    
    
    
    // Creo el combinador
    UINavigationController * lNav = [UINavigationController new];
    [lNav pushViewController:lVC animated:NO];
    
    UINavigationController * bNav = [UINavigationController new];
    [bNav pushViewController:bVC animated:NO];
    
    UISplitViewController * spVC = [UISplitViewController new];
    spVC.viewControllers = @[lNav,bNav];
    
    spVC.delegate=bVC;
    lVC.delegate=bVC;
    
    
    self.window.rootViewController = spVC;
}

-(void) configureForPhone:(MXWLibrary*)libray{
    MXWLibraryTableViewController* lVC = [[MXWLibraryTableViewController alloc]
                                          initWithLibray:libray
                                          style:UITableViewStylePlain];
    // Creo el combinador
    UINavigationController * lNav = [UINavigationController new];
    [lNav pushViewController:lVC animated:NO];
    
    lVC.delegate = lVC;
    
    self.window.rootViewController = lNav;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
