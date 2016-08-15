package com.example.goldenlimit.wmtslayer;


import java.io.File;

import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;

import com.esri.android.map.FeatureLayer;
import com.esri.android.map.MapView;
import com.esri.android.map.ags.ArcGISFeatureLayer;
import com.esri.android.map.ags.ArcGISLocalTiledLayer;
import com.esri.android.map.event.OnStatusChangedListener;
import com.esri.android.map.ogc.WMTSLayer;
import com.esri.core.geodatabase.Geodatabase;
import com.esri.core.geodatabase.GeodatabaseFeatureTable;
import com.esri.core.geometry.SpatialReference;
import com.esri.core.map.Feature;
import com.esri.core.ogc.wmts.WMTSLayerInfo;
import com.esri.core.ogc.wmts.WMTSServiceInfo;
import com.esri.core.ogc.wmts.WMTSServiceMode;
import com.esri.core.ogc.wmts.WMTSTileMatrixSet;


public class MainActivity extends AppCompatActivity {

    private static final String TAG = MainActivity.class.getSimpleName();

    private static File demoDataFile;
    private static String fileName;
    //ProgressDialog progress;

    private MapView mMapView;
    private WMTSLayer wmtsLayer;

    private WMTSLayerInfo wmtsLayerInfo;
    private WMTSServiceInfo wmtsServiceInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //create mapView
        mMapView = (MapView) findViewById(R.id.map);

        DownloadMWMTSLayerTask wmtsLoad = new DownloadMWMTSLayerTask();
        wmtsLoad.execute();
        //mMapView.addLayer(wmtsLayer);
    }

    private class DownloadMWMTSLayerTask extends AsyncTask<WMTSLayer, Void, WMTSLayer> {

            @Override
            protected WMTSLayer doInBackground(WMTSLayer... params) {

                try {
                    wmtsServiceInfo = WMTSServiceInfo.fetch("http://tiles.craig.fr/ortho/service?service=WMTS", null, WMTSServiceMode.KVP);
                    wmtsLayerInfo = wmtsServiceInfo.getLayerInfos().get(1);
                    //wmtsServiceInfo.getTileMatrixSet(wmtsLayerInfo.getTileMatrixSetIds().get(1));
                    //wmtsServiceInfo.getTileMatrixSets().get(1);
                    //TileMatrixSet

                    //Log.d(TAG, "Checkpoint 3");
                    //WMTSTileMatrixSet wmtsTileMatrixSet = WMTSTileMatrixSet()
                    Log.d(TAG, "Get WMTSLayerInfo");
                    wmtsLayer = new WMTSLayer(wmtsLayerInfo, SpatialReference.create(2154));
                    wmtsLayer.setTileMatrixSet(wmtsServiceInfo.getTileMatrixSets().get(1).toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    return null;
                }
                return wmtsLayer;
            }

            @Override
            protected void onPostExecute(WMTSLayer wmtsLayer) {
                if (wmtsLayer == null) {
                    Log.d(TAG, "WMTSLayer is null");
                }
                Log.d(TAG, "WMTSLayer has content");
                try {
                    //wmtsLayer = new WMTSLayer()
                    //WMTSTileMatrixSet wmtsTileMatrixSet = WMTSTileMatrixSet()
                    //wmtsLayerInfo.getTileMatrixSetIds().get(1);
                    //String wmtsSpatialReference = wmtsLayerInfo.getServiceInfo().getTileMatrixSets().get(1).d.toString();
                    //wmtsSpatialReference = wmtsSpatialReference.replaceAll("EPSG:","");
                    //wmtsLayer = new WMTSLayer(wmtsLayerInfo, SpatialReference.create(2154));
                    wmtsLayer.layerInitialise();
                    Log.d(TAG, "Trying to initialize wmtsLayer");
                    mMapView.addLayer(wmtsLayer);
                } catch (Exception e){
                    Log.e(TAG, "Return Error");
                }
//                //enable panning over date line
                //mMapView.enableWrapAround(true);
//                //set Esri logo
//                mMapView.setEsriLogoVisible(true);
            }
        }

//        Log.d(TAG, "Checkpoint 3");
//        wmtsLayer.layerInitialise();
//        Log.d(TAG, "Checkpoint 4");
//        mMapView.addLayer(wmtsLayer);


//    private class AsyncWTMSTask extends AsyncTask<WMTSLayerInfo, Void, WMTSLayerInfo> {
//
//        @Override
//        protected void onPreExecute() {
//            progress = new ProgressDialog(MainActivity.this);
//
//            progress = ProgressDialog.show(MainActivity.this, "",
//                    "Please wait....loading WMTSLayer");
//        }
//
//        @Override
//        protected WMTSLayerInfo doInBackground(WMTSLayerInfo...params) {
//            WMTSLayerInfo wmtsLayerInfo = null;
//            WMTSServiceInfo wmtsServiceInfo = null;
//            try {
//                wmtsServiceInfo = WMTSServiceInfo.fetch("http://tiles.craig.fr/ortho/service?service=WMTS", null, WMTSServiceMode.KVP);
//                wmtsLayerInfo = wmtsServiceInfo.getLayerInfos().get(1);
//                wmtsServiceInfo.getTileMatrixSet(wmtsLayerInfo.getTileMatrixSetIds().get(1));
//                //WMTSTileMatrixSet wmtsTileMatrixSet = WMTSTileMatrixSet()
//                Log.d(TAG, "Check 1");
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            return wmtsLayerInfo;
//        }
//
//        protected void onPostExecute(WMTSLayerInfo wmtsLayerInfo) {
//            if(wmtsLayerInfo == null) {
//                Log.d(TAG, "wmtsLayer is null");
//            }
//            Log.d(TAG, "Checkpoint 2");
//            //WMTSTileMatrixSet wmtsTileMatrixSet = WMTSTileMatrixSet()
//            //wmtsLayerInfo.getTileMatrixSetIds().get(1);
//            //String wmtsSpatialReference = wmtsLayerInfo.getServiceInfo().getTileMatrixSets().get(1).d.toString();
//            //wmtsSpatialReference = wmtsSpatialReference.replaceAll("EPSG:","");
//            wmtsLayer = new WMTSLayer(wmtsLayerInfo,SpatialReference.create(2154));
//            Log.d(TAG, "Checkpoint 3");
//            wmtsLayer.layerInitialise();
//            Log.d(TAG, "Checkpoint 4");
//            mMapView.addLayer(wmtsLayer);
//            //enable panning over date line
//            mMapView.enableWrapAround(true);
//            //set Esri logo
//            mMapView.setEsriLogoVisible(true);
//        }
//    };

    private void loadOfflineGDBfile() {
        //create the path to local gdb

        demoDataFile = Environment.getExternalStorageDirectory();
        fileName = this.getResources().getString(R.string.offline_gdb);

        //create the path to get offline geodatabase
        String gdbPath = demoDataFile + File.separator + fileName;

        // add layers from the geodatabase
        try {
            Geodatabase geodatabase = new Geodatabase(gdbPath);
            for (GeodatabaseFeatureTable gdbFeatureTable: geodatabase.getGeodatabaseTables()){
                if(gdbFeatureTable.hasGeometry()){
                    Feature searchFeature = gdbFeatureTable.getFeature(2);
                    System.out.print(searchFeature);

                    mMapView.addLayer(new FeatureLayer(gdbFeatureTable));
                }
            }
//                for (int i = 0; i < geodatabase.getGeodatabaseTables().size(); i++) {
//                    System.out.println(geodatabase.getGeodatabaseTables().get(i));
//                }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

}
