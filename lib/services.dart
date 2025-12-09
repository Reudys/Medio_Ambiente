import 'package:flutter/material.dart';
import 'package:medio_ambiente/api_service.dart';

class ServiciosActivity extends StatefulWidget {
  const ServiciosActivity({super.key});
  @override
  _ServiciosActivityState createState() => _ServiciosActivityState();
}

class _ServiciosActivityState extends State<ServiciosActivity> {
  final MedioAmbienteService _service = MedioAmbienteService();
  late Future<List<Servicio>> _serviciosFuture;

  @override
  void initState() {
    super.initState();
    _serviciosFuture = _service.getServicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Servicios'), backgroundColor: Colors.green),
      body: FutureBuilder<List<Servicio>>(
        future: _serviciosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay servicios disponibles"));
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final servicio = snapshot.data![index];
              return ListTile(
                leading: Text(
                  servicio.icono.isNotEmpty ? servicio.icono : "📋",
                  style: TextStyle(fontSize: 30),
                ),
                title: Text(servicio.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  servicio.descripcion, 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicioDetalleActivity(servicio: servicio),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ServicioDetalleActivity extends StatelessWidget {
  final Servicio servicio;
  const ServicioDetalleActivity({Key? key, required this.servicio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(servicio.nombre), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(servicio.icono, style: TextStyle(fontSize: 80)),
            SizedBox(height: 20),
            Text(
              servicio.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                servicio.descripcion,
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}