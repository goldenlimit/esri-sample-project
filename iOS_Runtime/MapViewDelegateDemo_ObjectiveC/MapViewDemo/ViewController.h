//
//  ViewController.h
//  MapViewDemo
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface ViewController : UIViewController <AGSMapViewLayerDelegate, AGSMapViewTouchDelegate, AGSLayerDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *mapView;
@property (strong, nonatomic) AGSImageServiceLayer *imageLayer;
@property (strong, nonatomic) AGSTiledLayer *tiledLayer;
@property (strong, nonatomic) AGSFeatureLayer *featureLayer;

@end

