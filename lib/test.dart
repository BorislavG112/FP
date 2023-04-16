import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController;
  Map<Marker, File> markers = {};

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(51.5, -0.09),
            zoom: 12.0,
          ),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
                maxZoom: 22,
                maxNativeZoom: 19),
            Builder(
              builder: (BuildContext context) {
                return MarkerLayer(
                  markers: markers.keys.toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void _loadMarkers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> markerKeys = prefs.getStringList('markerKeys') ?? [];
    for (String key in markerKeys) {
      double? latitude = prefs.getDouble('$key-latitude');
      double? longitude = prefs.getDouble('$key-longitude');
      String? filePath = prefs.getString('$key-filePath');
      // Add the marker to the map

      // markers[Marker(
      //   width: 80.0,
      //   height: 80.0,
      //   point: LatLng(latitude!, longitude!),
      //   builder: (ctx) => const FlutterLogo(),
      //   onTap: () => _showImageDialog(File(filePath!)),
      //   //onTap: () => _showImageDialog(File(filePath!)),
      // )] = File(filePath!);
      markers[Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(latitude!, longitude!),
        builder: (ctx) => InkWell(
          onTap: () => _showImageDialog(File(filePath!), context),
          child: const FlutterLogo(),
        ),
      )] = File(filePath!);
    }
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _takePhoto() async {
    ImagePicker()
        .getImage(source: ImageSource.camera)
        .then((PickedFile? recordedImage) async {
      if (recordedImage != null && recordedImage.path != null) {
        // Get the device's current location
        Position pos = await _determinePosition();
        GallerySaver.saveImage(recordedImage.path, albumName: 'Media')
            .then((bool? success) {
          // Add a marker to the map at the device's location
          Marker marker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(pos.latitude, pos.longitude),
            builder: (ctx) => const FlutterLogo(
              textColor: Colors.black,
            ),
          );
          markers[marker] = File(recordedImage.path);
          setState(() {}); // Save the marker to SharedPreferences
          SharedPreferences.getInstance().then((prefs) {
            int markerCount = (prefs.getInt('markerCount') ?? 0) + 1;
            prefs.setInt('markerCount', markerCount);
            prefs.setDouble(
                'marker${markerCount}-latitude', marker.point.latitude);
            prefs.setDouble(
                'marker${markerCount}-longitude', marker.point.longitude);
            prefs.setString(
                'marker${markerCount}-filePath', recordedImage.path);
            List<String> markerKeys = prefs.getStringList('markerKeys') ?? [];
            markerKeys.add('marker${markerCount}');
            prefs.setStringList('markerKeys', markerKeys);
          });
        });
      }
    });
  }
}

void _showImageDialog(File imageFile, context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onDoubleTap: () {
                      Navigator.of(context).pop();
                      showImageViewer(context, FileImage(File(imageFile.path)),
                          swipeDismissible: true, doubleTapZoomable: true);
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Image.file(imageFile),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.zoom_out_map_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showImageViewer(
                            context, FileImage(File(imageFile.path)),
                            swipeDismissible: true, doubleTapZoomable: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text("This is a caption for the image"),
            ),
          ],
        ),
      );
    },
  );
}
