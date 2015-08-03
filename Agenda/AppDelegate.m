//
//  AppDelegate.m
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "CoreDataAPI.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.949020F green:0.239216F blue:0.152941F alpha:1.0F]];
     [self inicializarContextoCoreData];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Core Data stack
-(void)inicializarContextoCoreData{
    NSArray *sandBox=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[sandBox objectAtIndex:0];
    NSString *sqliteBDPath=[documentsDirectory stringByAppendingPathComponent:@"Agenda.data"];;
    NSURL *storeURLBDPath=[NSURL fileURLWithPath:sqliteBDPath];
    NSError *error;
    
    [[CoreDataAPI instanciaCompartida] setModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    [[CoreDataAPI instanciaCompartida] setPsc:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[[CoreDataAPI instanciaCompartida] model]]];
    if([[[CoreDataAPI instanciaCompartida] psc] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURLBDPath options:nil error:&error])
    {
        [[CoreDataAPI instanciaCompartida] setContext:[[NSManagedObjectContext alloc] init]];
        [[[CoreDataAPI instanciaCompartida] context] setPersistentStoreCoordinator:[[CoreDataAPI instanciaCompartida] psc]];
        [[[CoreDataAPI instanciaCompartida] context] setUndoManager:nil];
    }
    else
        NSLog(@"ERROR:AppDelegate->inicializarContextoCoreData:%@",[error localizedDescription]);
}


@end
