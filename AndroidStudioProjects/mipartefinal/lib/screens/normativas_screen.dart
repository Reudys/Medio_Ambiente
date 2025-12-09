import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/normativa.dart';
import 'normativa_detalle_screen.dart';
import '../utils/session_manager.dart';

class NormativasScreen extends StatefulWidget {
  const NormativasScreen({super.key});

  @override
  State<NormativasScreen> createState() => _NormativasScreenState();
}

class _NormativasScreenState extends State<NormativasScreen> {
  List<Normativa> _normativas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNormativas();
  }

  Future<void> _loadNormativas() async {
    final normativas = await ApiService.getNormativas();
    if (mounted) {
      setState(() {
        _normativas = normativas;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normativas Ambientales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionManager.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _normativas.isEmpty
          ? const Center(child: Text('No hay normativas disponibles'))
          : ListView.builder(
        itemCount: _normativas.length,
        itemBuilder: (context, index) {
          final normativa = _normativas[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(normativa.titulo),
              subtitle: Text(normativa.descripcion),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(
                context,
                '/normativa-detalle',
                arguments: normativa.id,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNormativas,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
