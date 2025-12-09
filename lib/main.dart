import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:medio_ambiente/services.dart';
import 'package:medio_ambiente/team.dart';
import 'package:medio_ambiente/Kevin.dart';
import 'package:medio_ambiente/reportes.dart';
import 'package:medio_ambiente/mapa_areas.dart';

import '../utils/session_manager.dart'; 
import '../screens/login_screen.dart';
import '../screens/recuperar_contrasena_screen.dart';
import '../screens/normativas_screen.dart';
import '../screens/normativa_detalle_screen.dart';
import '../screens/cambiar_contrasena_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Medio Ambiente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      // La ruta inicial es el Splash para verificar si hay sesión
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        '/inicio': (context) => InicioScreen(), // Esta es tu pantalla principal con el Slider
        '/login': (context) => const LoginScreen(),
        '/recuperar': (context) => const RecuperarContrasenaScreen(),
        '/normativas': (context) => const NormativasScreen(),
        '/normativa-detalle': (context) => const NormativaDetalleScreen(),
        '/cambiar-contrasena': (context) => const CambiarContrasenaScreen(),
      },
    );
  }
}

// --- SPLASH SCREEN (Lógica de Sesión) ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final isLoggedIn = await SessionManager.isLoggedIn();
    
    if (!mounted) return;

    if (isLoggedIn) {
      // Si está logueado, vamos al Dashboard principal (InicioScreen)
      Navigator.pushReplacementNamed(context, '/inicio');
    } else {
      // Si NO está logueado, vamos al Login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.lightGreen],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Ministerio de Medio Ambiente',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- INICIO SCREEN (Dashboard con Slider y Drawer) ---
class InicioScreen extends StatelessWidget {
  
  final List<Map<String, String>> slides = [
    {
      'image': 'https://images.unsplash.com/photo-1421789665209-c9b2a435e3dc?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'title': 'Protección de nuestros manatíes',
      'message': 'El manatí antillano está clasificado como una especie en peligro crítico de extinción.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
      'title': 'Reserva de Biosfera Madre de las Aguas',
      'message': 'Es una de las áreas de conservación más importantes del país y la región del Caribe.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1445462657202-a0893228a1e1?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
          fontSize: 22, // Ajusté un poco el tamaño
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Para que el icono del menú sea blanco
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.eco, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Menú Principal",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            
            // --- NUEVA OPCIÓN AGREGADA ---
            ListTile(
              leading: Icon(Icons.gavel, color: Colors.green), // Icono de leyes/normas
              title: Text("Normativas Ambientales"),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                Navigator.pushNamed(context, '/normativas'); // Navega a la pantalla importada
              },
            ),
            Divider(), // Separador visual
            // -----------------------------

            ListTile(
              leading: Icon(Icons.miscellaneous_services, color: Colors.green),
              title: Text("Servicios"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ServiciosActivity()),
              ),
            ),

            ListTile(
              leading: Icon(Icons.people, color: Colors.green),
              title: Text("Equipo"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EquipoActivity()),
              ),
            ),

            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.green),
              title: Text("Videos"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => KevinPage()),
              ),
            ),

            ListTile(
              leading: Icon(Icons.map, color: Colors.green),
              title: Text("Mapa"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MapaAreasScreen()),
              ),
            ),
            
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text("Cerrar Sesión"),
              onTap: () async {
                await SessionManager.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                    child: Icon(Icons.image_not_supported, size: 50),
                                  ),
                            ),
                          ),
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

            // Mensaje introductorio
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
                      'Conservando la biodiversidad y haciendo uso sostenible de los recursos genéticos. El Ministerio de Medio Ambiente y Recursos Naturales se compromete a proteger nuestros recursos naturales.',
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
            // Ejemplo de acceso directo a Normativas desde el cuerpo (opcional)
            Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.gavel, color: Colors.green),
                title: Text('Normativas Ambientales'),
                subtitle: Text('Consulta las leyes y regulaciones vigentes.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.pushNamed(context, '/normativas'),
              ),
            ),
            
            // Tus cards anteriores
            Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(Icons.eco, color: Colors.green),
                title: Text('Protección de nuestros manatíes'),
                subtitle: Text('El manatí antillano está clasificado como una especie en peligro crítico.'),
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
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.miscellaneous_services, color: Colors.white),
                  label: Text("Servicios", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServiciosActivity()));
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.people, color: Colors.white),
                  label: Text("Equipo", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EquipoActivity()));
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt, color: Colors.white),
                  label: Text("Videos", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => KevinPage()));
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.report, color: Colors.white),
                  label: Text("Reportes", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportesActivity()));
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