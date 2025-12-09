import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NormativasPage extends StatefulWidget {
  @override
  _NormativasPageState createState() => _NormativasPageState();
}

class _NormativasPageState extends State<NormativasPage> {
  List<dynamic> normativas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNormativas();
  }

  Future<void> fetchNormativas() async {
    final url = Uri.parse('https://adamix.net/medioambiente/normativas');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          normativas = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar normativas');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudieron cargar las normativas')),
      );
    }
  }

  void abrirUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el documento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Normativas Ambientales'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: normativas.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final n = normativas[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.gavel, color: Colors.green),
                    title: Text(n['titulo']),
                    subtitle: Text('${n['tipo']} - ${n['fecha_publicacion']}'),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () => abrirUrl(n['url_documento']),
                  ),
                );
              },
            ),
    );
  }
}
