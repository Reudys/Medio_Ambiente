import 'package:flutter/material.dart';
import 'package:medio_ambiente/api_service.dart';

class EquipoActivity extends StatefulWidget {
  const EquipoActivity({super.key});
  @override
  _EquipoActivityState createState() => _EquipoActivityState();
}

class _EquipoActivityState extends State<EquipoActivity> {
  final MedioAmbienteService _service = MedioAmbienteService();
  late Future<List<MiembroEquipo>> _equipoFuture;

  @override
  void initState() {
    super.initState();
    _equipoFuture = _service.getEquipo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuestro Equipo'), backgroundColor: Colors.green),
      body: FutureBuilder<List<MiembroEquipo>>(
        future: _equipoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No se encontró información del equipo"));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final miembro = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EquipoDetalleActivity(miembro: miembro),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            miembro.fotoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => 
                                Container(color: Colors.grey[300], child: Icon(Icons.person, size: 50)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              miembro.nombre,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              miembro.cargo,
                              style: TextStyle(fontSize: 12, color: Colors.green),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EquipoDetalleActivity extends StatelessWidget {
  final MiembroEquipo miembro;
  const EquipoDetalleActivity({Key? key, required this.miembro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(miembro.fotoUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
                ),
              ),
              child: miembro.fotoUrl.isEmpty 
                  ? Icon(Icons.person, size: 100, color: Colors.grey) 
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    miembro.nombre,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    miembro.cargo,
                    style: TextStyle(fontSize: 18, color: Colors.green[700], fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  Chip(
                    label: Text(miembro.departamento),
                    backgroundColor: Colors.green[50],
                  ),
                  Divider(height: 30),
                  Text("Biografía", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    miembro.biografia,
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}