import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medio_ambiente/api_service.dart';

class ReportesActivity extends StatefulWidget {
  const ReportesActivity({super.key});
  @override
  _ReportesActivityState createState() => _ReportesActivityState();
}

class _ReportesActivityState extends State<ReportesActivity> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    ReportarDanoActivity(),
    MisReportesActivity(),
    MapaReportesActivity(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Reportes'),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reportar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mis Reportes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}

class ReportarDanoActivity extends StatefulWidget {
  const ReportarDanoActivity({super.key});
  @override
  _ReportarDanoActivityState createState() => _ReportarDanoActivityState();
}

class _ReportarDanoActivityState extends State<ReportarDanoActivity> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final MedioAmbienteService _service = MedioAmbienteService();
  
  File? _imageFile;
  String? _imageBase64;
  Position? _currentPosition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
        );
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        List<int> imageBytes = await _imageFile!.readAsBytes();
        setState(() {
          _imageBase64 = base64Encode(imageBytes);
        });
      }
    } catch (e) {
      print('Error seleccionando imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen')),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _enviarReporte() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, agrega una foto del daño')),
      );
      return;
    }
    
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo obtener la ubicación. Intenta de nuevo.')),
      );
      _getCurrentLocation();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final reporte = Reporte(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
      fotoBase64: _imageBase64!,
      latitud: _currentPosition!.latitude,
      longitud: _currentPosition!.longitude,
    );

    bool success = await _service.crearReporte(reporte);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reporte enviado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      _tituloController.clear();
      _descripcionController.clear();
      setState(() {
        _imageFile = null;
        _imageBase64 = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar el reporte. Intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reportar Daño Ambiental',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: 'Título del reporte',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un título';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción detallada',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una descripción';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            Card(
              elevation: 2,
              child: InkWell(
                onTap: _showImageOptions,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Toca para agregar foto'),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.location_on, color: Colors.green),
                title: Text('Ubicación GPS'),
                subtitle: Text(
                  _currentPosition != null
                      ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}'
                      : 'Obteniendo ubicación...',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _getCurrentLocation,
                ),
              ),
            ),
            SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _enviarReporte,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Enviar Reporte',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}

class MisReportesActivity extends StatefulWidget {
  const MisReportesActivity({super.key});
  @override
  _MisReportesActivityState createState() => _MisReportesActivityState();
}

class _MisReportesActivityState extends State<MisReportesActivity> {
  final MedioAmbienteService _service = MedioAmbienteService();
  late Future<List<Reporte>> _reportesFuture;

  @override
  void initState() {
    super.initState();
    _reportesFuture = _service.getMisReportes();
  }

  Color _getEstadoColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'resuelto':
        return Colors.green;
      case 'en proceso':
        return Colors.orange;
      case 'pendiente':
      default:
        return Colors.red;
    }
  }

  IconData _getEstadoIcon(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'resuelto':
        return Icons.check_circle;
      case 'en proceso':
        return Icons.hourglass_empty;
      case 'pendiente':
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _reportesFuture = _service.getMisReportes();
        });
      },
      child: FutureBuilder<List<Reporte>>(
        future: _reportesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes reportes todavía',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final reporte = snapshot.data![index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReporteDetalleActivity(reporte: reporte),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: reporte.fotoBase64.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    base64Decode(reporte.fotoBase64),
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                              : Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reporte.titulo,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                reporte.descripcion,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    _getEstadoIcon(reporte.estado),
                                    size: 16,
                                    color: _getEstadoColor(reporte.estado),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    reporte.estado ?? 'Pendiente',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _getEstadoColor(reporte.estado),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (reporte.fecha != null) ...[
                                    SizedBox(width: 12),
                                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      '${reporte.fecha!.day}/${reporte.fecha!.month}/${reporte.fecha!.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
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

class ReporteDetalleActivity extends StatelessWidget {
  final Reporte reporte;
  const ReporteDetalleActivity({Key? key, required this.reporte}) : super(key: key);

  Color _getEstadoColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'resuelto':
        return Colors.green;
      case 'en proceso':
        return Colors.orange;
      case 'pendiente':
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (reporte.fotoBase64.isNotEmpty)
              Container(
                height: 250,
                child: Image.memory(
                  base64Decode(reporte.fotoBase64),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 80),
                      ),
                ),
              ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reporte.titulo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getEstadoColor(reporte.estado).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Estado: ${reporte.estado ?? "Pendiente"}',
                      style: TextStyle(
                        color: _getEstadoColor(reporte.estado),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            reporte.descripcion,
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.location_on, color: Colors.green),
                      title: Text('Ubicación GPS'),
                      subtitle: Text(
                        'Latitud: ${reporte.latitud.toStringAsFixed(6)}\nLongitud: ${reporte.longitud.toStringAsFixed(6)}',
                      ),
                    ),
                  ),
                  
                  if (reporte.fecha != null) ...[
                    SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.green),
                        title: Text('Fecha del reporte'),
                        subtitle: Text(
                          '${reporte.fecha!.day}/${reporte.fecha!.month}/${reporte.fecha!.year} ${reporte.fecha!.hour}:${reporte.fecha!.minute.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ],
                  
                  if (reporte.comentarioOficial != null && reporte.comentarioOficial!.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Card(
                      elevation: 2,
                      color: Colors.blue[50],
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.comment, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'Respuesta Oficial',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              reporte.comentarioOficial!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapaReportesActivity extends StatefulWidget {
  const MapaReportesActivity({super.key});
  @override
  _MapaReportesActivityState createState() => _MapaReportesActivityState();
}

class _MapaReportesActivityState extends State<MapaReportesActivity> {
  final MedioAmbienteService _service = MedioAmbienteService();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Reporte> _reportes = [];
  bool _isLoading = true;
  LatLng _center = LatLng(18.735693, -70.162651); // Centro de República Dominicana

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    try {
      List<Reporte> reportes = await _service.getMisReportes();
      setState(() {
        _reportes = reportes;
        _isLoading = false;
        if (reportes.isNotEmpty) {
          _center = LatLng(reportes.first.latitud, reportes.first.longitud);
        }
        _crearMarcadores();
      });
    } catch (e) {
      print('Error cargando reportes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _crearMarcadores() {
    List<Marker> markers = [];
    for (var reporte in _reportes) {
      markers.add(
        Marker(
          point: LatLng(reporte.latitud, reporte.longitud),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              _mostrarDetalleReporte(reporte);
            },
            child: Icon(
              Icons.location_on,
              color: _getMarkerColor(reporte.estado),
              size: 40,
            ),
          ),
        ),
      );
    }
    setState(() {
      _markers = markers;
    });
  }

  void _mostrarDetalleReporte(Reporte reporte) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reporte.titulo,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Estado: ${reporte.estado ?? "Pendiente"}'),
            SizedBox(height: 8),
            Text(
              reporte.descripcion,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReporteDetalleActivity(reporte: reporte),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Ver Detalles', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMarkerColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'resuelto':
        return Colors.green;
      case 'en proceso':
        return Colors.orange;
      case 'pendiente':
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_reportes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay reportes para mostrar en el mapa',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 12.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.medio_ambiente',
            ),
            MarkerLayer(
              markers: _markers,
            ),
          ],
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Leyenda del Mapa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLeyendaItem('Pendiente', Colors.red),
                      _buildLeyendaItem('En Proceso', Colors.orange),
                      _buildLeyendaItem('Resuelto', Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeyendaItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}