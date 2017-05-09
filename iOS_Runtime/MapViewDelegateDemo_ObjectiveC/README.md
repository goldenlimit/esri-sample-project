# MapViewDelegate & AGSLayerDelegate in ArcGIS Runtime iOS SDK 10.2.5

## About

Using ArcGIS Runtime SDK for iOS 10.2.5 to enteract with several different delegates to see how method called
Demo:

![](https://media.giphy.com/media/sfjN0eRHkKali/giphy.gif)

## Usage Notes

This sample require to have iOS version >= 8.0.

Using the latest version of ArcGIS Runtime SDK for iOS 10.2.5. You can use any version of Xcode 7,8 with iOS 9,10 SDK or Xcode 6 with iOS 8 SDK.

We recommend that you use the latest version of Xcode to ensure that you have Apple's latest bug fixes, language support, and enhancements to both Xcode and the iOS SDKs.

For more information about system requirements, please check: [System requirement  - ArcGIS Runtime SDK for iOS](https://developers.arcgis.com/ios/swift/guide/system-reqs.htm)

## How it works:

Use AGSLayerDelegate to check whether the layer is successfully load:
```swift

NSURL * url = [NSURL URLWithString:@"https://sampleserver6.arcgisonline.com/arcgis/rest/services/Toronto/ImageServer"];
    self.imageLayer = [[AGSImageServiceLayer alloc] initWithURL:url];
    
    self.imageLayer.delegate  = self;
    self.mapView.layerDelegate = self;

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
```

Add MapViewDelegate to help work with this method "(BOOL) 	- mapView:shouldHitTestLayer:atPoint:mapPoint:", this method only works with feature layer (specific layer with features), then it will trigger, otherwise, imageLayer and DynamicLayer will not work. You should use AGSMapViewTouchDelegate instead. 
 
```swift

 self.featureLayer = [[AGSFeatureLayer alloc] initWithURL:[NSURL URLWithString:@"https://sampleserver6.arcgisonline.com/arcgis/rest/services/WorldTimeZones/MapServer/0"] mode:
                         AGSFeatureLayerModeOnDemand];
    
 self.mapView.layerDelegate = self;

 -(BOOL) mapView:(AGSMapView *)mapView shouldHitTestLayer:(AGSLayer *)layer atPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint {
    NSLog(@"The click point is x:'%f', y:'%f'", mappoint.x, mappoint.y);
    return YES;
    
}
```

## Resources

* [AGSMapViewLayerDelegate - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/10-2/api-reference/protocol_a_g_s_map_view_layer_delegate-p.html)
* [AGSLayerDelegate - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/10-2/api-reference/protocol_a_g_s_layer_delegate-p.html)
