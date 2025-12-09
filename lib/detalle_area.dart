import 'package:flutter/material.dart';
import 'area_protegida.dart';

class DetalleAreaScreen extends StatelessWidget {
  final AreaProtegida area;
  const DetalleAreaScreen({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(area.nombre),
        backgroundColor: Colors.green[800],
        titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${area.tipo}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(area.descripcion, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Coordenadas: ${area.lat}, ${area.lng}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
