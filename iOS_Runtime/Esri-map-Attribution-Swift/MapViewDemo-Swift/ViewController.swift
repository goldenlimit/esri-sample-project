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
//

import UIKit
import ArcGIS

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var attributionLabel: UILabel!
    @IBOutlet weak var esriURL: UITextView!
    @IBOutlet weak var mapView: AGSMapView!
    
    private var tiledLayer: AGSArcGISTiledLayer!
    var map:AGSMap!
    var intialViewPoint: AGSViewpoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create an instance of a map with ESRI topographic basemap
        self.tiledLayer = AGSArcGISTiledLayer(URL: NSURL(string: "http://services.arcgisonline.com/arcgis/rest/services/World_Topo_Map/MapServer")!)
        
        self.map = AGSMap(basemap: AGSBasemap(baseLayer: self.tiledLayer))
        
        self.intialViewPoint = AGSViewpoint(center: AGSPoint(x: -13045884, y: 4036331, spatialReference: AGSSpatialReference.webMercator()), scale: 1e6)
        
        self.map.initialViewpoint = self.intialViewPoint

        self.mapView.map = self.map
        self.esriURL.delegate = self
        
        //Setup a completion handler until the map loaded then show the attribution label
        self.map.loadWithCompletion { (error) -> Void in
            if let error = error {
                print(error)
            } else {
                
                //set map attribution to show once map load up
                let attributeFont = UIFont(name: "Helvetica Neue", size: 6)
                
                let mapAttributes = [
                    NSFontAttributeName: attributeFont!
                ]
                
                let mapAttributionString = NSMutableAttributedString(string: self.tiledLayer.mapServiceInfo!.attributionText, attributes: mapAttributes)
                
                self.attributionLabel.attributedText = mapAttributionString
                self.attributionLabel.numberOfLines = 2
                self.attributionLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                self.attributionLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
                self.attributionLabel.textAlignment = NSTextAlignment.Left
                
                print(self.tiledLayer.mapServiceInfo!.attributionText)
                
                //set the Esri URL clickable URL
                let esriAttribution = "Powered by Esri"
                let esriAttributionString = NSMutableAttributedString(string: esriAttribution, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 7.5)!]
                )
                
                esriAttributionString.addAttribute(NSLinkAttributeName, value: "www.esri.com", range:NSMakeRange(11, 4))
                self.esriURL.attributedText = esriAttributionString
                self.esriURL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                self.esriURL.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
                self.esriURL.textAlignment = NSTextAlignment.Right
                
            }
        }
        
        self.mapView.viewpointChangedHandler = {
            () -> Void in
            self.intialViewPoint = self.mapView.currentViewpointWithType(AGSViewpointType.BoundingGeometry)
            print(self.intialViewPoint)
        }
        //self.mapView.currentViewpointWithType(AGSViewpointType)
        
    }
    
    //MARK: - UITextViewDelegate triggerred when "Powered by Esri" TextView clicked, open Safari to open the webpage
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        self.esriURL.dataDetectorTypes = UIDataDetectorTypes.Link;
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.esri.com")!)
        return true

    }
}

