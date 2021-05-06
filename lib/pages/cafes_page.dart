import 'package:flutter/material.dart';
import 'package:flutter_google_maps_exemplo/controllers/cafes_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CafesPage extends StatelessWidget {
  CafesPage({Key key}) : super(key: key);

  filtro() {
    return SimpleDialog(
      title: Text('Filtrar por Proximidade'),
      children: [
        Obx(
          () => Slider(
            value: CafesController.to.raio.value,
            min: 0,
            max: 10,
            divisions: 10000,
            label: CafesController.to.distancia,
            onChanged: (value) => CafesController.to.raio.value = value,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 24, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => CafesController.to.filtrarCafes(),
                child: Text('Filtrar'),
              ),
              TextButton(onPressed: () => Get.back(), child: Text('Cancelar')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CafesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafés'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(context: context, builder: (context) => filtro());
            },
          ),
        ],
      ),
      body: GetBuilder<CafesController>(
        init: controller,
        builder: (value) => GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          initialCameraPosition: CameraPosition(
            target: controller.position,
            zoom: 13,
          ),
          onMapCreated: controller.onMapCreated,
          myLocationEnabled: true,
          markers: controller.markers,
        ),
      ),
    );
  }
}
