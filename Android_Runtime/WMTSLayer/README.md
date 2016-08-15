# Load thrid party OGC WMTSLayer

## About

Using ArcGIS Runtime SDK for Android 10.2.8 to load third party OGC WMTSLayer, try the workflow in Runtime iOS SDK works but only in Objective-C not Swift. Logged a swift BUG internally BUG-000094940.

## How's the workflow

1. Use AsyncTask to load the WMTSLayer (not sure if this is the best option), however in this way it should not block the main thread

2. Since the WMTSLayer is from a third party url, therefore we can't directly load the WMTSLayer directly usin URL like ESRI format. It requires WMTSLayerInfo, wmtsTileMatrixSet to eventually create an instance of WMTSLayer

3. Witnin the doInBackground function, it returns a wmtsLayer object. And in onPostExecute function, confirmed that wmtsLayer is existed. The current issue narrow down to execute this line "mMapView.addLayer(wmtsLayer);" it returns this error "E/ArcGIS: The map or layer has been destroyed or recycled."

PS: Another find in e.class, set break point in line 126 it will return this error message:
E/ArcGIS.TileCache: Exception occur:0,2,2

```java
java.lang.NullPointerException: Attempt to invoke virtual method 'java.lang.String java.lang.String.toLowerCase()' on a null object reference
```

Here is a screenshot ![alt text](http:// "Java error")

## Resources

* [WMTSServiceInfo - ArcGIS Android 10.2.8 API](https://developers.arcgis.com/android/api-reference/reference/com/esri/core/ogc/wmts/WMTSServiceInfo.html)
* [WMTSLayer - ArcGIS Android 10.2.8 API](https://developers.arcgis.com/android/api-reference/reference/com/esri/android/map/ogc/WMTSLayer.html#setTileMatrixSet(java.lang.String))
* [Android AsyncTask](https://developer.android.com/reference/android/os/AsyncTask.html)



