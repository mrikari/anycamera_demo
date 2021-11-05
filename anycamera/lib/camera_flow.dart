import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:anycamera/camera_page.dart';
import 'package:anycamera/gallery_page.dart';

class CameraFlow extends StatefulWidget {
  // 1
  final VoidCallback shouldLogOut;

  const CameraFlow({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;

  // 2
  bool _shouldShowCamera = false;

  // 3
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
              shouldLogOut: widget.shouldLogOut,
              shouldShowCamera: () => _toggleCameraOpen(true))),

      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  _toggleCameraOpen(false);
                }))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
  }

  @override
  Widget build(BuildContext context) {
    // 4
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      _shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      _camera = firstCamera;
    });
  }
}
