import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _flashOn = false;
  final double _circleDiameter = 300.0; // Adjust diameter as needed
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
      appBar: AppBar(
        title: Text('Camera Screen'),
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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 3),
              ),
              width: _circleDiameter,
              height: _circleDiameter,
              child: ClipOval(child: CameraPreview(_controller!)),
            ),
          ),
          Text("Snapped Image:"),
          SizedBox(
            height: 20,
          ),
          _imageFile != null
              ? Container(
                  height: 400,
                  width: 400,
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.contain,
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
