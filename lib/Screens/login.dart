import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_flutter/OpenCV/controller.dart';
import 'dart:io';

import 'package:opencv_flutter/OpenCV/image.dart';
import 'package:opencv_flutter/Screens/alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ID = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await ImageController().pickImage();

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      // Process the login with the provided data'
      String res = await FacialRecognition()
              .verifyPerson(id: _ID.text, imageFile: _imageFile!) ??
          "Not Found";
      MyAlert().alert(context, res);
    } else {
      // Show error message if the form is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please enter your username and select an image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ID,
                decoration: InputDecoration(labelText: "ID"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your id";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pick Image"),
              ),
              SizedBox(height: 16.0),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : Text("No image selected"),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Start Recognise"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
