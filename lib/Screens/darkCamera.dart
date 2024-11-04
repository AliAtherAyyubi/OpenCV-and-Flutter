import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class DarkCameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<DarkCameraScreen> {
  CameraController? _controller;
  bool _flashOn = false;
  final double _circleDiameter = 300.0;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );

    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      final XFile? file = await _controller!.takePicture();
      setState(() {
        _imageFile = File(file!.path);
      });
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Camera Screen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              setState(() {
                _flashOn = !_flashOn;
                _controller!
                    .setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Center(
            child: ClipPath(
              clipper: CircleClipper(_circleDiameter / 2),
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Center(
            child: Container(
              width: _circleDiameter,
              height: _circleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 3),
              ),
              child: ClipOval(
                child: CameraPreview(_controller!),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final double radius;

  CircleClipper(this.radius);

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2), radius: radius))
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) => oldClipper.radius != radius;
}
