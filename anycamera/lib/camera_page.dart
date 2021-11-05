import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  // 1
  final CameraDescription camera;
  // 2
  final ValueChanged didProvideImagePath;

  const CameraPage(
      {Key? key, required this.camera, required this.didProvideImagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 3
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // 4
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      // 5
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera), onPressed: _takePicture),
    );
  }

  // 6
  void _takePicture() async {
    try {
      await _initializeControllerFuture;

      final tmpDirectory = await getTemporaryDirectory();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(tmpDirectory.path, filePath);

      await _controller.takePicture();

      widget.didProvideImagePath(path);
    } catch (e) {
      print(e);
    }
  }

  // 7
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
