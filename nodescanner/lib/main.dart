import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tesseract OCR',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  String? _recognizedText;

  Future<void> _captureImage() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() => _imageFile = File(imageFile!.path));
  }

  Future<void> _scanImage() async {
    final url = Uri.parse('http://192.168.1.44:3000/scan');
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes(
        'image', _imageFile!.readAsBytesSync(),
        filename: _imageFile!.path.split('/').last));
    final response = await http.Response.fromStream(await request.send());

    setState(() => _recognizedText = response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Tesseract OCR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) ...[
              Image.file(_imageFile!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _scanImage,
                child: const Text('Scan Image'),
              ),
              if (_recognizedText != null) ...[
                const SizedBox(height: 16),
                Text(_recognizedText!),
              ],
            ] else ...[
              const Text('No image selected'),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureImage,
        tooltip: 'Capture Image',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
