import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/fake_api.dart';
import 'area_protegida.dart';

class MapaAreasScreen extends StatefulWidget {
  @override
  State<MapaAreasScreen> createState() => _MapaAreasScreenState();
}

class _MapaAreasScreenState extends State<MapaAreasScreen> {
  Set<Marker> _markers = {};
  AreaProtegida? _areaSeleccionada; // ← Guardamos el área seleccionada

  @override
  void initState() {
    super.initState();
    cargarMarkers();
  }

  void cargarMarkers() {
    final areas = FakeApi.obtenerAreas();

    setState(() {
      _markers = areas.map((area) {
        return Marker(
          markerId: MarkerId(area.id.toString()),
          position: LatLng(area.lat, area.lng),
          infoWindow: InfoWindow(
            title: area.nombre,
            snippet: area.tipo,
          ),
          onTap: () {
            setState(() {
              _areaSeleccionada = area; // ← Mostrar tarjeta en pantalla
            });
          },
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Áreas Protegidas"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(18.7357, -70.1627),
              zoom: 7.2,
            ),
            markers: _markers,
          ),

          /// 📌 TARJETA QUE SALE AL TOCAR UN MARKER
          if (_areaSeleccionada != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _areaSeleccionada!.nombre,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),

                        Text(
                          "Tipo: ${_areaSeleccionada!.tipo}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 6),

                        Text(
                          _areaSeleccionada!.descripcion,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 6),

                        Text(
                          "Coordenadas: (${_areaSeleccionada!.lat}, ${_areaSeleccionada!.lng})",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),

                        SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              setState(() => _areaSeleccionada = null); // Ocultar tarjeta
                            },
                            child: Text("Cerrar"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
