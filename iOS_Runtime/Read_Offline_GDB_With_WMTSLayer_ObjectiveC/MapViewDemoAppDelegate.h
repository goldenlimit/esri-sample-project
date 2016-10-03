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

#import <UIKit/UIKit.h>

@class MapViewDemoViewController;

@interface MapViewDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MapViewDemoViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet MapViewDemoViewController *viewController;

@end

