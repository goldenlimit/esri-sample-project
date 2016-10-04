# Attribution Sample for Runtime Quartz SDK iOS 

## About

Since Esri is stating this attribution requirement as a legal requirement based on the Terms of Use, developers will be required to do it in any deployed app. However, the various SDKs provide different levels of support of this service for developers. If not easy, developers may decide to not implement the requirement. Therefore, it is in Esri's and the customer's best interest to make this as easy and painless as possible for developers regardless of which SDK they choose to build their app. 


Current Demo:

![](https://media.giphy.com/media/xYf9bp9wcJYFa/giphy.gif)

## Current challenge and need to be done

- [ ] Probably need to extend our current API for triggering the event when mapview extent changed, currently we did everything in [mapView.viewpointChangedHandler](https://developers.arcgis.com/ios/beta/api-reference/interface_a_g_s_map_view.html#a60cb3ce397fbb676e8906a0a0e574a8b), and in our doc it said, do not perform any heavy-lifting in this handler as it may adversely impact the rendering performance. 

- [ ] Need to convert the scale level to Level of Detail (LOD) in order to match with the zoom max/min 
- [ ] Need create a function to get all the current mapview information, compared with the attribution from JSON 
- [ ] Need create another function to update the compare result and show the best candidate attributors on the UILabel

## Resources

* [Attribution in your app](https://developers.arcgis.com/terms/attribution/)
* [Esri Leaflet](https://github.com/Esri/esri-leaflet)
* [Esri Leaflet - Util.js](https://github.com/Esri/esri-leaflet/blob/62b348210eb68012fe82b2bf2b1953b360f1553f/src/Util.js)




