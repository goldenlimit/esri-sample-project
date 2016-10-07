//
// Copyright 2016 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
// Developer: Nathan (Yue) Wu

import UIKit
import ArcGIS

class ViewController: UIViewController {
    
    @IBOutlet weak var attributionLabel: UILabel!
    @IBOutlet weak var mapView: AGSMapView!
    
    private var useServiceBasemap = false
    private var useVectorBasemap =  true
    private var tiledLayer: AGSArcGISTiledLayer!
    var map:AGSMap!
    var currentViewPoint: AGSViewpoint!
    var currentLOD: AGSViewpoint!
    var ymin: Double!
    var xmin: Double!
    var ymax: Double!
    var xmax: Double!
    var scale: Double!
    
    func createBasemapTiledLayer(URL:NSURL) -> AGSArcGISTiledLayer {
        //create an instance of a map with requested basemap
        let tiledLayer = AGSArcGISTiledLayer(URL:URL)
        return tiledLayer
    }
    
    func createBasemapVectorTiledLayer(URL:NSURL) -> AGSArcGISVectorTiledLayer {
        //create an instance of map with requested vector tiled basemap
        let tiledLayer = AGSArcGISVectorTiledLayer(URL:URL)
        return tiledLayer
    }
    
    func createBasemapFromEsri() -> AGSBasemap {
        var basemap: AGSBasemap
        if (useServiceBasemap) {
            basemap = AGSBasemap.streetsBasemap()
        } else if (useVectorBasemap) {
            basemap = AGSBasemap(baseLayer: self.createBasemapVectorTiledLayer(NSURL(string: "http://basemaps.arcgis.com/b2/arcgis/rest/services/World_Basemap/VectorTileServer")!))
        } else {
            basemap = AGSBasemap(baseLayer: self.createBasemapTiledLayer(NSURL(string: "http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer")!))
        }
        return basemap
    }
    
    //Change the logic of this func and conditionally return the right attributions for different service
    //However one thing I found that for in our current API seems that we doesn't have any interface to get the attribution
    //The only thing I can find is AGSVectorTileSourceInfo
    //https://developers.arcgis.com/ios/beta/api-reference/interface_a_g_s_vector_tile_source_info.html
    func getBasemapAttribution(vectorTile:Bool) -> String {
            if (!vectorTile) {
                return (self.map.basemap.baseLayers[0].mapServiceInfo!?.attribution)!
            } else {
                return (self.map.basemap.baseLayers[0].sourceInfo!?.name)!
            }
}
    
    func configAttributionLabel() {
        self.attributionLabel.numberOfLines = 3
        //self.attributionLabel.lineBreakMode = .ByTruncatingTail
        self.attributionLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        self.attributionLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        self.attributionLabel.textAlignment = NSTextAlignment.Left
    }
    
    func updateAttribution() {
        //set map attribution to show once map load up
        let attributeFont = UIFont(name: "Helvetica Neue", size: 6)
        let mapAttributes = [NSFontAttributeName: attributeFont!]
        let mapAttributionString = NSMutableAttributedString(string: self.getBasemapAttribution(useVectorBasemap), attributes: mapAttributes)
        self.attributionLabel.attributedText = mapAttributionString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create an instance of a map with ESRI topographic basemap
        self.tiledLayer = AGSArcGISTiledLayer(URL: NSURL(string: "http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer")!)
        
        self.map = AGSMap(basemap: self.createBasemapFromEsri())
        
        map.initialViewpoint = AGSViewpoint(center: AGSPoint(x: -13045884, y: 4036331, spatialReference: AGSSpatialReference.webMercator()), scale: 1e6)

        self.mapView.map = self.map
        self.configAttributionLabel()
        
        //Setup a completion handler until the map loaded then show the attribution label
        self.map.loadWithCompletion { (error) -> Void in
            if let error = error {
                print(error)
            } else {
                
                self.updateAttribution()
            }
        }
        
        //this may not good for performance since we may call it too often and we can't return anything back
        self.mapView.viewpointChangedHandler = {
            () -> Void in
            
           
            self.currentViewPoint = self.mapView.currentViewpointWithType(AGSViewpointType.BoundingGeometry)
            self.currentLOD = self.mapView.currentViewpointWithType(AGSViewpointType.CenterAndScale)
            do {
                let jsonBbox = try self.currentViewPoint.toJSON()
                let jsonScale = try self.currentLOD.toJSON()
                
                //print(jsonScale)
                //print(jsonBbox)
                
              //check the current bound
             if let targetGeometry = jsonBbox["targetGeometry"] as? [String: AnyObject]{
                if let ymax = targetGeometry["ymax"] as? Double {
                    print("Ymax: \(ymax)")
                    self.ymax = ymax
                }
                if let xmin = targetGeometry["xmin"] as? Double {
                    print("Xmin: \(xmin)")
                    self.xmin = xmin
                }
                if let ymin = targetGeometry["ymin"] as? Double {
                    print("Ymin: \(ymin)")
                    self.ymin = ymin
                }
                if let xmax = targetGeometry["xmax"] as? Double {
                    print("Xmax: \(xmax)")
                    self.xmax = xmax
                }
            }
               //check the current scale
                if let currentScale = jsonScale["scale"] as? Double {
                    print("Current Scale: \(currentScale)")
                    self.scale = currentScale
                    print("--------------------")
                }
                
            } catch let error as NSError {
                print ("JSON Error: \(error.localizedDescription)")
                
            }
        }
    }
}

