import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakaoo/app/utils/constants.dart';
import 'package:kakaoo/app/view/petani/pages/jual/jual.dart';
import 'package:map_picker/map_picker.dart';

import 'package:flutter_svg/flutter_svg.dart';

const kGoogleApiKey = "AIzaSyAISwXwMy9RIBS6qnrxkC3fPRL3hfSrJSg";

class MapPick extends StatefulWidget {
  const MapPick({
    Key? key,
  }) : super(key: key);

  @override
  _MapPickState createState() => _MapPickState();
}

class _MapPickState extends State<MapPick> {
  late GoogleMapController _controller;
  MapPickerController mapPickerController = MapPickerController();

  late Position _currentPosition;
  // ignore: unused_field
  var _currentAddress;

  TextEditingController _textEditingController = TextEditingController();

  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(-5.1475787, 119.3977117),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: SvgPicture.asset(
              "assets/location_icon.svg",
              height: 60,
            ),
            //add map picker controller
            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              // hide location button
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              //  camera position
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onCameraMoveStarted: () {
                // notify map is moving
                mapPickerController.mapMoving!();
                _textEditingController.text = "Checking ...";
              },
              onCameraMove: (cameraPosition) {
                this.cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                // notify map stopped moving
                mapPickerController.mapFinishedMoving!();
                //get address name from camera position
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition.target.latitude,
                  cameraPosition.target.longitude,
                );

                // update the ui with the address
                _textEditingController.text =
                    '${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}';
              },
            ),
          ),
          Positioned(
            bottom: 180,
            right: 24,
            left: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColor().colorChocolate,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.my_location,
                          color: AppColor().colorChocolate,
                        ),
                      ),
                      onTap: () {
                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              padding: EdgeInsets.all(paddingDefault),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12)),
                  color: Colors.white),
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none),
                    controller: _textEditingController,
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Jual(
                                    isEdit: false,
                                    location: _textEditingController.text,
                                    coordinate: GeoPoint(cameraPosition.target.latitude, cameraPosition.target.longitude),
                                  )));
                      print("Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                      print("Address: ${_textEditingController.text}");
                    },
                    child: Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor().colorCreamy,
                      ),
                      child: Center(
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            // height: 19/19,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
