// Flutter: Video Cards Player - Versión con un solo controller
// Archivo: lib/main.dart
// Dependencias (pubspec.yaml):
//   video_player: ^2.5.0

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Cards Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const VideoCardsPage(),
    );
  }
}

class VideoItem {
  final String title;
  final String url; // puede ser network o path local

  const VideoItem({
    required this.title,
    required this.url,
  });
}



class VideoCardsPage extends StatelessWidget {
  const VideoCardsPage({Key? key}) : super(key: key);

  // Aquí agrega los títulos y URLs de video que tú quieras
  final List<VideoItem> items = const [
    VideoItem(title: 'Video 1', url: 'https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4'),
    VideoItem(title: 'Video 2', url: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4'),
    VideoItem(title: 'Video 3', url: 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproductor en Cards')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return VideoCard(item: items[index]);
          },
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoItem item;
  const VideoCard({Key? key, required this.item}) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isVisible = false; // para mostrar controles al tocar

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.item.url)
      ..initialize().then((_) {
        // evita setState si el widget ya fue desmontado
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Contenedor del video con relación de aspecto
          AspectRatio(
            aspectRatio: _isInitialized ? _controller.value.aspectRatio : 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video o placeholder
                if (_isInitialized)
                  GestureDetector(
                    onTap: () {
                      _togglePlay();
                      setState(() => _isVisible = !_isVisible);
                    },
                    child: VideoPlayer(_controller),
                  )
                else
                  // Placeholder mientras inicializa
                  const Center(child: CircularProgressIndicator()),

                // Play / Pause overlay
                if (_isInitialized)
                  Positioned(
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Barra de progreso simple abajo
                if (_isInitialized)
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
              ],
            ),
          ),

          // Título y acciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // ejemplo: reiniciar video
                    if (_isInitialized) {
                      _controller.seekTo(Duration.zero);
                      _controller.pause();
                    }
                  },
                  icon: const Icon(Icons.replay),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
Notas y recomendaciones:
- Agrega en pubspec.yaml: video_player: ^2.5.0
- Si vas a reproducir muchos videos en lista, considera usar un solo controller
  para el video visible (por ejemplo con VisibilityDetector o PageView) para
  ahorrar recursos y evitar que varios videos se reproducen a la vez.
- Para controles más completos (velocidad, subtítulos, diseños), usa el paquete
  chewie.
- Para videos locales, usa VideoPlayerController.file(File(path)).
- Si quieres que solo un video se reproduzca a la vez, puedes pausar todos los
  demás desde un controlador central o usando un callback hacia el padre.
*/
