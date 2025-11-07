import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

/*
 this section : mybe we update at future on the App, 
 at that time we will update that. 
*/

class MapDisplay extends StatefulWidget{

  State<StatefulWidget> createState()=> _mapDisplay();
}

class _mapDisplay extends State<StatefulWidget>{

  Widget build(BuildContext context){

    return Scaffold(

      body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 300,
                height: 300,
                child: FlutterMap(
                    options: MapOptions(
                        initialCenter:LatLng(40.1467542, 47.1714202),
                        initialZoom: 13,
                        onTap: (tapPosition, point) {
                          print(tapPosition.global.direction);
                          print(point.latitude);
                        },
                    ),
                    children: [
                        TileLayer( // Bring your own tiles
                            urlTemplate: 'https://api.maptiler.com/maps/streets-v2-dark/256/{z}/{x}/{y}.png?key=pVv1CwffcaxSWs6wRp2S', // For demonstration only
                            userAgentPackageName: 'delivery_app', // Add your app identifier
                            // And many more recommended properties!
                        ),
                        MarkerLayer(
                            markers: [
                                Marker(
                                    width: 60,
                                    height: 60,
                                    point: const LatLng(40.1467542, 47.1714202),
                                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                                ),
                            ],
                        ),
                        
                    ],
                ),
              )  
            ],
         ),
    );
  }
}