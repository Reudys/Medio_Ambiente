import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/normativa.dart';

class NormativaDetalleScreen extends StatefulWidget {
  const NormativaDetalleScreen({super.key});

  @override
  State<NormativaDetalleScreen> createState() => _NormativaDetalleScreenState();
}

class _NormativaDetalleScreenState extends State<NormativaDetalleScreen> {
  int? normativaId;
  Normativa? normativa;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      normativaId = args as int;
      _loadNormativa();
    }
  }

  Future<void> _loadNormativa() async {
    if (normativaId != null) {
      final normativaData = await ApiService.getNormativa(normativaId!);
      if (mounted) {
        setState(() {
          normativa = normativaData;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle Normativa')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : normativa == null
          ? const Center(child: Text('Normativa no encontrada'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              normativa!.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Fecha: ${normativa!.fecha}'),
            const SizedBox(height: 20),
            Text(
              normativa!.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contenido Completo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(normativa!.contenido),
          ],
        ),
      ),
    );
  }
}
