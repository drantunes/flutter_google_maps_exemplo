import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_exemplo/database/db.dart';
import 'package:flutter_google_maps_exemplo/widgets/cafe_details.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CafesController extends GetxController {
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final raio = 0.0.obs;

  StreamSubscription<Position> positionStream;
  LatLng _position = LatLng(-23.571505, -46.689104);
  GoogleMapController _mapsController;
  final markers = Set<Marker>();

  static CafesController get to => Get.find<CafesController>();
  get mapsController => _mapsController;
  get position => _position;
  String get distancia => raio.value < 1
      ? '${(raio.value * 1000).toStringAsFixed(0)} m'
      : '${(raio.value).toStringAsFixed(1)} km';

  filtrarCafes() {
    final geo = Geoflutterfire();
    final db = DB.get();

    GeoFirePoint center = geo.point(
      latitude: latitude.value,
      longitude: longitude.value,
    );

    CollectionReference ref = db.collection('cafes');

    String field = 'position';

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: ref)
        .within(center: center, radius: raio.value, field: field);

    stream.listen((List<DocumentSnapshot> cafes) {
      markers.clear();
      cafes.forEach((cafe) {
        addMarker(cafe);
        update();
      });
      Get.back();
    });
  }

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    getPosicao();
    loadCafes();

    var style = await rootBundle.loadString('assets/map/light.json');
    _mapsController.setMapStyle(style);
  }

  loadCafes() async {
    FirebaseFirestore db = DB.get();
    final cafes = await db.collection('cafes').get();

    cafes.docs.forEach((cafe) => addMarker(cafe));
  }

  addMarker(cafe) async {
    GeoPoint point = cafe.get('position.geopoint');

    markers.add(
      Marker(
        markerId: MarkerId(cafe.id),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: cafe.get('nome')),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          'assets/cafe_40.png',
        ),
        onTap: () => showDetails(cafe.data()),
      ),
    );
    update();
  }

  showDetails(cafe) {
    Get.bottomSheet(
      CafeDetails(
        nome: cafe['nome'],
        imagem: cafe['imagem'],
      ),
      barrierColor: Colors.transparent,
    );
  }

  watchPosicao() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (position != null) {
        latitude.value = position.latitude;
        longitude.value = position.longitude;
      }
    });
  }

  @override
  void onClose() {
    positionStream.cancel();
    super.onClose();
  }

  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone.');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosicao() async {
    try {
      final posicao = await _posicaoAtual();
      latitude.value = posicao.latitude;
      longitude.value = posicao.longitude;
      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)));
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[900],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
