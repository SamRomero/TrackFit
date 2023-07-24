import 'package:flutter/material.dart';
import 'package:trackfit/Pantallas/registro.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../LocalStorage.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa>{

  final LocalStorage _localStorage = LocalStorage();
  Set<Marker> _markers = {};

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _localStorage.init();
    _fetchMarkers();
  }

  Future<void> _fetchMarkers() async {
    final url = Uri.parse('http://192.168.0.99:8000/api/ubicacions');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_localStorage.authToken}'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final Set<Marker> markers = {};

      for (var data in jsonData) {
        final double lat = double.parse(data['latitud']);
        final double lng = double.parse(data['longitud']);
        final markerIcon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(40,40)),
            'assets/images/sport_icon.png'
        );
        final marker = Marker(
          markerId: MarkerId(data['id'].toString()),
          position: LatLng(lat, lng),
          icon: markerIcon,
          onTap: () => _showMarkerDetails(MarkerId(data['id'].toString())),
        );

        markers.add(marker);
      }

      setState(() {
        _markers = markers;
      });
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _showMarkerDetails(MarkerId markerId) async {

    Navigator.push(
      context,MaterialPageRoute(builder: (context) =>
        Registro(selectedUbication: int.parse(markerId.value))),
    );
  }


  @override
  Widget build(BuildContext context) {
    LatLng initialCameraPosition;
    initialCameraPosition = LatLng(13.72127684213604, -89.2019177456896);

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialCameraPosition,
          zoom: 18.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}


