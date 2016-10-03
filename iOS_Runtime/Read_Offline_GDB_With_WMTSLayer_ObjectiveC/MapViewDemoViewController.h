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
#import <ArcGIS/ArcGIS.h>

@interface MapViewDemoViewController : UIViewController <AGSMapViewLayerDelegate, AGSWMTSInfoDelegate, AGSMapViewTouchDelegate> {
	
	//container for map layers
	AGSMapView *_mapView;
	
	//this map has a dynamic layer, need a view to act as a container for it
	AGSDynamicMapServiceLayer * _dynamicLayer;
    AGSTiledMapServiceLayer *_tiledLayer;
}

//map view is an outlet so we can associate it with UIView
//in IB
@property (nonatomic, strong) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISlider *opacitySlider;
@property (nonatomic, strong) AGSDynamicMapServiceLayer *dynamicLayer;
@property (nonatomic,strong) AGSTiledMapServiceLayer *tiledLayer;

@property (nonatomic, strong) AGSGDBSyncTask *geodatabaseTask;
@property (nonatomic, strong) id<AGSCancellable> geodatabaseJob;
@property (nonatomic, strong) AGSGDBGenerateParameters *generateParameters;

@property (nonatomic, strong) AGSGDBFeatureTable *localFeatureTable;
@property (nonatomic, strong) AGSFeatureTableLayer *localFeatureTableLayer;
@property (nonatomic, strong) AGSGDBGeodatabase *geodatabase;

@property (nonatomic, strong) AGSLocalTiledLayer *localTiledLayer;
@property (nonatomic, strong) AGSWMTSInfo *wmtsInfo;

@end

