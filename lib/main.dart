import 'package:flutter/material.dart';
import 'area_protegida/area_list_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AreaListPage(),
    );
  }
}
