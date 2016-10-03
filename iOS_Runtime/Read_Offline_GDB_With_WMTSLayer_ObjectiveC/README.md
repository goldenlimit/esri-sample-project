# Read Offline GDB With WMTSLayer as basemap

## About

Using ArcGIS Runtime SDK for iOS 10.2.5 to load an open source WMTSLayer, and add local geodatabase featureTableLayer as operational layer on top of WMTSLayer to show the data

Currently, we have already submitted a [BUG-000094940 Segmentation fault thrown when using WMTS layer with Swift]
This sample shows that it works with Objective-C

Demo:

![](https://media.giphy.com/media/12HT7KEKAOeCnC/giphy.gif)

## Usage Notes

This sample require to have iOS version >= 8.0.

Using the latest version of ArcGIS Runtime SDK for iOS 10.2.5. You can use any version of Xcode 7,8 with iOS 9,10 SDK or Xcode 6 with iOS 8 SDK.

We recommend that you use the latest version of Xcode to ensure that you have Apple's latest bug fixes, language support, and enhancements to both Xcode and the iOS SDKs.

For more information about system requirements, please check: [System requirement  - ArcGIS Runtime SDK for iOS](https://developers.arcgis.com/ios/swift/guide/system-reqs.htm)

## How it works:

Use AGSWMTSInfoDelegate to load the WMTSLayerInfo when the WMTSLayer URL is added
```swift
//Add a wmtsURL for basemap reference
    NSURL *wmtsUrl = [NSURL URLWithString:@"http://tiles.craig.fr/ortho/service?service=WMTS"];
    //Assign wmtsUrl to wmtsInfo, in order to trigger the WMTSLayerDelegate
    self.wmtsInfo = [[AGSWMTSInfo alloc] initWithURL:wmtsUrl];
    self.wmtsInfo.delegate = self;


Add AGSWMTSInfoDelegate in viewDidLoad, and triggered this delegat: wmtsInfoDidLoad

```swift
 -(void)wmtsInfoDidLoad:(AGSWMTSInfo *)wmtsInfo {
    NSLog(@"WMTS info success to load");
    //Triggered by wmtsInfo did load, get populate all the wmtsLayer info
    NSArray *layerInfos = [wmtsInfo layerInfos];
    
    //Since third party wmts service, we need to get useful information from the xml file. 
    //The XML file content an arry of layers, therefore in order to view one specific tile. 
    //We need to load one element from the arry.
    
    //Get layerInfo and spatial reference from tileMatrixSet
    AGSWMTSLayerInfo *layerInfo = layerInfos[1];
    layerInfo.tileMatrixSet = layerInfo.tileMatrixSetIds[1];
    
    AGSWMTSLayer *wmtsLayer = [wmtsInfo wmtsLayerWithLayerInfo:layerInfo andSpatialReference:nil];
    NSLog(@"WMTSLayer: %@", wmtsLayer.spatialReference);
    
    //Add WMTSLayer to map
    [self.mapView addMapLayer:wmtsLayer withName:@"wmtsLayer"];

```

## Resources

* [AGSWMTSInfoDelegate - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/api-reference/protocol_a_g_s_w_m_t_s_info_delegate-p.html)
* [AGSWMTSInfo - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/api-reference/interface_a_g_s_w_m_t_s_info.html)

* [AGSGDBGeodatabase - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/api-reference/interface_a_g_s_g_d_b_geodatabase.html)
* [AGSFeatureTableLayer - ArcGIS Runtime for iOS 10.2.5](https://developers.arcgis.com/ios/api-reference/interface_a_g_s_feature_table_layer.html)
* [How To: Consume ArcGIS (WMS and WMTS) services with the ArcGIS Runtime SDK for iOS](http://support.esri.com/technical-article%5C000011861)