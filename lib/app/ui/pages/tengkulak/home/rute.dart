import 'dart:async';
import 'dart:math' show cos, sqrt, asin;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakaoo/app/ui/pages/constants.dart';

class Rute extends StatefulWidget {
  final String location;
  final GeoPoint initialPosition;

  const Rute({Key? key, required this.initialPosition, required this.location})
      : super(key: key);

  @override
  _RuteState createState() => _RuteState();
}

Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _RuteState extends State<Rute> {
  final String _googleApiKey = "AIzaSyAISwXwMy9RIBS6qnrxkC3fPRL3hfSrJSg";
  var _currentPosition;
  var _currentAddress;
  var _originLatitude;
  var _originLongitude;

  Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController _controller) {
    _mapController.complete(_controller);
  }

  @override
  void initState() {
    /// add origin marker origin marker
    getCurrentLocation();
    // Add destination marker
    _addMarker(
      LatLng(widget.initialPosition.latitude, widget.initialPosition.longitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    super.initState();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 8,
        color: Colors.blue);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(double originLatitude, double originLongitude) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _googleApiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(
          widget.initialPosition.latitude, widget.initialPosition.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  @override
  Widget build(BuildContext context) {
    if (_originLatitude == null || _originLongitude == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            child: Container(
          child: Column(
            children: [widgetLocation(), widgetMap()],
          ),
        )),
      ),
    );
  }

  widgetLocation() {
    return Container(
        height: 160.0,
        padding: EdgeInsets.symmetric(
            vertical: paddingDefault, horizontal: paddingDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: AppColor().colorChocolate,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.only(left: paddingDefault),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                Container(
                    width: 280.0,
                    padding: EdgeInsets.symmetric(
                        vertical: paddingDefault / 2,
                        horizontal: paddingDefault),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black12)),
                    child: Text('Lokasi Anda'))
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            padding: EdgeInsets.only(left: paddingDefault),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.green,
                ),
                Container(
                    width: 280.0,
                    padding: EdgeInsets.symmetric(
                        vertical: paddingDefault / 2,
                        horizontal: paddingDefault),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black12)),
                    child: Text('${widget.location}'))
              ],
            ),
          )
        ]));
  }

  widgetMap() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.4,
        child: GoogleMap(
          onMapCreated: onMapCreated,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(_originLatitude, _originLongitude), zoom: 14.0),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
        ),
      ),
    );
  }

  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        _originLatitude = position.latitude;
        _originLongitude = position.longitude;
        _addMarker(
          LatLng(position.latitude, position.longitude),
          "origin",
          BitmapDescriptor.defaultMarker,
        );
      });
      await getAddressFromLatLong();
      _getPolyline(_originLatitude, _originLongitude);
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLong() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.subAdministrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }
}
