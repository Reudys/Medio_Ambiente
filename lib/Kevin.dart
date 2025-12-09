import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KevinPage extends StatefulWidget {
  const KevinPage({super.key});

  @override
  State<KevinPage> createState() => _KevinPageState();
}

class VideoItem {
  final String title;
  final String assetPath;

  const VideoItem({required this.title, required this.assetPath});
}

class _KevinPageState extends State<KevinPage> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  String _currentAsset = '';

  final List<VideoItem> videos = const [
    VideoItem(title: 'Reciclaje', assetPath: 'assets/videos/Reciclaje.mp4'),
    VideoItem(title: 'Conservación', assetPath: 'assets/videos/Conser.mp4'),
    VideoItem(title: 'Cambio Climático', assetPath: 'assets/videos/CambioClimatico.mp4'),
    VideoItem(title: 'Biodiversidad', assetPath: 'assets/videos/Biodiversidad.mp4'),
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo(videos[0].assetPath);
  }

  void _loadVideo(String asset) async {
    _currentAsset = asset;
    _initialized = false;
    setState(() {});

    _controller = VideoPlayerController.asset(asset);
    await _controller.initialize();
    _controller.pause();

    if (!mounted) return;
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos ambientales'),
        backgroundColor: Colors.green[800],
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      body: Column(
        children: [
          // Video Player
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: _initialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                        if (!_controller.value.isPlaying)
                          const Icon(Icons.play_arrow, size: 60, color: Colors.white),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: VideoProgressIndicator(_controller, allowScrubbing: true),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: IconButton(
                            icon: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 8),
          // Lista de Videos
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, i) {
                final v = videos[i];
                final selected = v.assetPath == _currentAsset;
                return Card(
                  color: selected ? Colors.blue.shade50 : Colors.white,
                  elevation: selected ? 6 : 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(v.title),
                    trailing: Icon(selected ? Icons.play_circle_fill : Icons.play_arrow),
                    onTap: () => _loadVideo(v.assetPath),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
