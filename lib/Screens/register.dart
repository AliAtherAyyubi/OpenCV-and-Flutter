import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:opencv_flutter/OpenCV/controller.dart';
import 'package:opencv_flutter/OpenCV/image.dart';
import 'package:opencv_flutter/Screens/alert.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
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
      // Process the registration with the provided data

      String res = await FacialRecognition().registerPerson(
              name: _usernameController.text,
              id: _idController.text,
              imageFile: _imageFile!) ??
          "Not Registered";

      MyAlert().alert(context, res);
    } else {
      // Show error message if the form is not valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please complete all fields and select an image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: "ID"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your ID";
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
                  child: Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
