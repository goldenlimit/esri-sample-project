// Copyright 2016 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://resources.arcgis.com/en/sample-use-restrictions/
// Developer: Nathan(Yue) Wu

#import "MapViewDemoAppDelegate.h"
#import "MapViewDemoViewController.h"

@implementation MapViewDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window setRootViewController:viewController];
    [window makeKeyAndVisible];
}




@end
