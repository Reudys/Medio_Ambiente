import 'package:flutter/material.dart';
import 'area_model.dart';
import 'area_service.dart';
import 'area_detail_page.dart';

class AreaListPage extends StatefulWidget {
  @override
  _AreaListPageState createState() => _AreaListPageState();
}

class _AreaListPageState extends State<AreaListPage> {
  final AreaService service = AreaService();
  List<Area> areas = [];
  List<Area> filtro = [];

  @override
  void initState() {
    super.initState();
    cargarAreas();
  }

  void cargarAreas() async {
    areas = await service.getAreas();
    filtro = areas;
    setState(() {});
  }

  void filtrar(String txt) {
    txt = txt.toLowerCase();
    filtro = areas.where((a) => a.area.toLowerCase().contains(txt)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: AppBar(
        title: const Text(
          "Áreas Protegidas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            /// ----- Barra de búsqueda moderna -----
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: TextField(
                onChanged: filtrar,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Buscar área...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 15),

            /// ----- Lista -----
            Expanded(
              child: filtro.isEmpty
                  ? const Center(
                      child: Text(
                        "No se encontraron resultados",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtro.length,
                      itemBuilder: (context, i) {
                        final area = filtro[i];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              area.area,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              area.provincia,
                              style: TextStyle(color: Colors.black54),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 18),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AreaDetailPage(area: area),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
