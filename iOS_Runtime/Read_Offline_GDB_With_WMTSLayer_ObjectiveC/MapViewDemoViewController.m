// Copyright 2016 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// This sample is just a proof of concept
// See the use restrictions at http://resources.arcgis.com/en/sample-use-restrictions/
// Developer: Nathan(Yue) Wu

#import "MapViewDemoViewController.h"

@implementation MapViewDemoViewController

@synthesize mapView = _mapView;
@synthesize dynamicLayer = _dynamicLayer;
@synthesize tiledLayer = _tiledLayer;

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSLog(@"slider value = %f", self.opacitySlider.value);
    self.mapView.baseLayer.opacity = self.opacitySlider.value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    //Add a wmtsURL for basemap reference
    NSURL *wmtsUrl = [NSURL URLWithString:@"http://tiles.craig.fr/ortho/service?service=WMTS"];
    //Assign wmtsUrl to wmtsInfo, in order to trigger the WMTSLayerDelegate
    self.wmtsInfo = [[AGSWMTSInfo alloc] initWithURL:wmtsUrl];
    self.wmtsInfo.delegate = self;
    
    self.opacitySlider.value = 1;
    self.opacitySlider.maximumValue = 1;
    self.opacitySlider.minimumValue = 0;
    
    self.mapView.layerDelegate = self;
    self.mapView.touchDelegate = self;
}

#pragma mark AGSWMTSInfoDelegate methods

-(void)wmtsInfo:(AGSWMTSInfo *)wmtsInfo didFailToLoad:(NSError *)error {
    NSLog(@"WMTS info failed to load");
}

-(void)wmtsInfoDidLoad:(AGSWMTSInfo *)wmtsInfo {
    NSLog(@"WMTS info success to load");
    //Triggered by wmtsInfo did load, get populate all the wmtsLayer info
    NSArray *layerInfos = [wmtsInfo layerInfos];
    
    //Since third party wmts service, we need to get useful information from the xml file. The XML file content an arry of layers, therefore in order to view one specific tile, we need to load one element from the arry.
    
    //Get layerInfo and spatial reference from tileMatrixSet
    AGSWMTSLayerInfo *layerInfo = layerInfos[1];
    layerInfo.tileMatrixSet = layerInfo.tileMatrixSetIds[1];
    
    AGSWMTSLayer *wmtsLayer = [wmtsInfo wmtsLayerWithLayerInfo:layerInfo andSpatialReference:nil];
    NSLog(@"WMTSLayer: %@", wmtsLayer.spatialReference);
    
    //Add WMTSLayer to map
    [self.mapView addMapLayer:wmtsLayer withName:@"wmtsLayer"];
    
    NSMutableArray *lFeaturetableLayer = [[NSMutableArray alloc]init];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *gdbPath = [paths objectAtIndex:0];
    
    //This is loading a geodatabase file from application as an operational layer add on top of WMTSLayer
    gdbPath = [gdbPath stringByAppendingPathComponent:@"france.geodatabase"];
    
    AGSGDBGeodatabase *gdb = [[AGSGDBGeodatabase alloc] initWithPath:gdbPath error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    else{
        if ([[NSFileManager defaultManager] fileExistsAtPath:gdbPath]) {
            
            NSLog(@"_gdb.featureTables.count =%lu", (unsigned long)gdb.featureTables.count);
            
            for (AGSFeatureTable* fTable in gdb.featureTables) {
                if ([fTable hasGeometry]) {
                    AGSFeatureTableLayer *fTableLayer = [[AGSFeatureTableLayer alloc]initWithFeatureTable:fTable];
                    fTableLayer.definitionExpression = @"OBJECTID < 200";
                    
                    // Change symbology if this is necessary
                    
                    //AGSSimpleMarkerSymbol* myMarkerSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbol];
                    //myMarkerSymbol.color = [UIColor blueColor];
                    //myMarkerSymbol.style = AGSSimpleMarkerSymbolStyleDiamond;
                    //myMarkerSymbol.outline.color = [UIColor whiteColor];
                    //myMarkerSymbol.outline.width = 3;
                    
                    //AGSSimpleRenderer* gdbSimpleRenderer = [AGSSimpleRenderer simpleRendererWithSymbol:myMarkerSymbol];
                    //fTableLayer.renderer = gdbSimpleRenderer;
                    
                    [lFeaturetableLayer addObject:fTableLayer];
                    
                    [self.mapView addMapLayer:fTableLayer withName:[NSString stringWithFormat:@"Offline Feature Layer#%lu - %@", lFeaturetableLayer.count-1, fTableLayer.name]];
                    NSLog(@"%@", [NSString stringWithFormat:@"Offline Feature Layer#%lu - %@", lFeaturetableLayer.count-1, fTableLayer.name]);
                }
            }
        }
    }
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.mapView = nil;
	self.dynamicLayer = nil;
}

#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    //Check the gdb location type "po geodatabase.path
    NSLog(@"%@",[[NSBundle mainBundle] bundlePath]);
}

- (void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error{
    NSLog(@"failed");
}

- (void)layerDidLoad:(AGSLayer *)layer{
    NSLog(@"success");
}
@end
