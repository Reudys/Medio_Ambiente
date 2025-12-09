import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart'; // Para abrir PDFs locales

class NormativasPage extends StatefulWidget {
  const NormativasPage({super.key});

  @override
  _NormativasPageState createState() => _NormativasPageState();
}

class _NormativasPageState extends State<NormativasPage> {
  bool isLoading = true;
  List<Map<String, String>> normativas = [];

  @override
  void initState() {
    super.initState();
    _loadNormativas();
  }

  void _loadNormativas() async {
    await Future.delayed(const Duration(seconds: 1)); // Simula tiempo de carga
    setState(() {
      normativas = [
        {
          'titulo': 'Ley de Recursos Naturales',
          'tipo': 'Ley',
          'fecha_publicacion': '2020-01-15',
          'url_documento': 'https://observatoriop10.cepal.org/es/instrumento/ley-general-ambiente-recursos-naturales-ley-no-217-1996'
        },
        {
          'titulo': 'Reglamento de Residuos',
          'tipo': 'Reglamento',
          'fecha_publicacion': '2019-06-20',
          'url_documento': 'Recursos.pdf' // PDF local en assets/docs/
        },
        {
          'titulo': 'Normativa de Agua Potable',
          'tipo': 'Reglamento',
          'fecha_publicacion': '2021-03-12',
          'url_documento': 'https://example.com/agua.pdf'
        },
      ];
      isLoading = false;
    });
  }

  // Abrir URL externa
  void abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el documento')),
      );
    }
  }

  // Abrir PDF local
  void abrirDocumentoLocal(String assetPath) async {
    await OpenFilex.open(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normativas Ambientales'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: normativas.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final n = normativas[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.gavel, color: Colors.green),
                    title: Text(n['titulo']!),
                    subtitle: Text('${n['tipo']} - ${n['fecha_publicacion']}'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      if (n['url_documento']!.startsWith('http')) {
                        abrirUrl(n['url_documento']!); // enlace externo
                      } else {
                        abrirDocumentoLocal('assets/docs/${n['url_documento']}'); // PDF local
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
