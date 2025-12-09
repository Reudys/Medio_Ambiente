import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:medio_ambiente/services.dart';
import 'package:medio_ambiente/team.dart';
import 'package:medio_ambiente/Kevin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Medio Ambiente',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InicioScreen(),
    );
  }
}

class InicioScreen extends StatelessWidget {
  // Lista de slides: cada uno con imagen y mensaje
  final List<Map<String, String>> slides = [
    {
      'image':
          'https://images.unsplash.com/photo-1421789665209-c9b2a435e3dc?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Protección de nuestros manatíes',
      'message':
          'El manatí antillano está clasificado como una especie en peligro crítico de extinción.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
      'title': 'Reserva de Biosfera Madre de las Aguas',
      'message':
          'Es una de las áreas de conservación más importantes del país y la región del Caribe.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1445462657202-a0893228a1e1?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Contaminación por plásticos',
      'message': 'Seguimiento a las negociaciones del acuerdo global.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ministerio de Medio Ambiente'),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal actualizado
            Text(
              'Ministerio de Medio Ambiente y Recursos Naturales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),

            // SLIDER
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: slides.map((slide) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              slide['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    ),
                                  ),
                            ),
                          ),
                          // Overlay con texto
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    slide['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    slide['message']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Mensaje introductorio actualizado
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre el Ministerio',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Conservando la biodiversidad y haciendo uso sostenible de los recursos genéticos. El Ministerio de Medio Ambiente y Recursos Naturales se compromete a proteger nuestros recursos naturales. Únete a nosotros en la lucha contra el cambio climático y la conservación de la biodiversidad.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sección de "¿Qué Hacemos?"
            Text(
              '¿Qué Hacemos?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.eco, color: Colors.green),
                title: Text('Protección de nuestros manatíes'),
                subtitle: Text(
                  'El manatí antillano está clasificado como una especie en peligro crítico de extinción.',
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.eco, color: Colors.green),
                title: Text('Reserva de Biosfera Madre de las Aguas'),
                subtitle: Text(
                  'Es una de las áreas de conservación más importantes del país y la región del Caribe.',
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.eco, color: Colors.green),
                title: Text('Contaminación por plásticos'),
                subtitle: Text(
                  'Seguimiento a las negociaciones del acuerdo global.',
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),

            SizedBox(height: 16),
            // --- NUEVOS BOTONES AGREGADOS PARA ACCEDER A LOS MÓDULOS ---
            Text(
              'Accesos Rápidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.miscellaneous_services),
                  label: Text("Servicios"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServiciosActivity()));
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.people),
                  label: Text("Equipo"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EquipoActivity()));
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.people),
                  label: Text("Videos"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => KevinPage()));
                  },
                ),
                
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}