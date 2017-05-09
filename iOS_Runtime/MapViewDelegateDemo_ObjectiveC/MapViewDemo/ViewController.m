//
//  ViewController.m
//  MapViewDemo
//

#import "ViewController.h"
#import <ArcGIS/ArcGIS.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set the delegate for the map view
   
    
    //create an instance of a tiled map service layer
    self.tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]];
    
    AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-8844874.0651 ymin:5401062.402699997 xmax:-8828990.0651 ymax:5420947.402699997  spatialReference:self.mapView.spatialReference];
    [self.mapView zoomToEnvelope:envelope animated:NO];
    
    
    NSURL * url = [NSURL URLWithString:@"https://sampleserver6.arcgisonline.com/arcgis/rest/services/Toronto/ImageServer"];
    //AGSImageServiceLayer* imageLayer = [AGSImageServiceLayer imageServiceLayerWithURL:url];
    self.imageLayer = [[AGSImageServiceLayer alloc] initWithURL:url];
    
    
    self.featureLayer = [[AGSFeatureLayer alloc] initWithURL:[NSURL URLWithString:@"https://sampleserver6.arcgisonline.com/arcgis/rest/services/WorldTimeZones/MapServer/0"] mode:
                         AGSFeatureLayerModeOnDemand];
    
    self.imageLayer.delegate  = self;
    self.tiledLayer.delegate  = self;
    self.mapView.layerDelegate = self;
    self.mapView.touchDelegate = self;
    
    //Add it to the map view
    [self.mapView addMapLayer:self.tiledLayer withName:@"Tiled Layer"];
    [self.mapView addMapLayer:self.imageLayer withName:@"Image Layer"];
    [self.mapView addMapLayer:self.featureLayer withName:@"feature Layer"];

}

#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    
    // Enable location display on the map
    [self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
   
}

//This function based on our documentation, it is only works with feature layer (specific layer with features), then it will trigger, otherwise, imageLayer and DynamicLayer will not work. You should use AGSMapViewTouchDelegate
-(BOOL) mapView:(AGSMapView *)mapView shouldHitTestLayer:(AGSLayer *)layer atPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint {
    NSLog(@"The click point is x:'%f', y:'%f'", mappoint.x, mappoint.y);
    return YES;
    
}

#pragma mark AGSLayerDelegate methods
//Triggered when layer successfully load
-(void) layerDidLoad:(AGSLayer *)layer {
    
    if (layer == self.imageLayer) {
    NSLog(@"This is the imageServiceInfo load: '%@'",self.imageLayer.imageServiceInfo.encodeToJSON);
    }
}

//Triggered when layer fails to load
- (void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error{
    NSLog(@"failed");
}


#pragma mark - Delegate Methods: AGSMapViewTouchDelegate 
- (void) mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features {
    
    NSLog(@"Clicked on this point x: '%f', y: '%f'", mappoint.x, mappoint.y);
    
}

@end
