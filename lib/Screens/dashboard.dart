import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_flutter/OpenCV/controller.dart';
import 'package:opencv_flutter/OpenCV/image.dart';
import 'package:opencv_flutter/Screens/login.dart';
import 'package:opencv_flutter/Screens/register.dart';

class RegisterLoginScreen extends StatefulWidget {
  @override
  _RegisterLoginScreenState createState() => _RegisterLoginScreenState();
}

class _RegisterLoginScreenState extends State<RegisterLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register & Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
              child: Text('Register'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Login'),
            ),
            SizedBox(height: 50),
            Text('Search Person by a Face '),
            ElevatedButton(
              onPressed: () async {
                final image = await ImageController().pickImage();
                await FacialRecognition().searchPerson(imageFile: image!);
              },
              child: Text('Get Person'),
            ),
          ],
        ),
      ),
    );
  }
}
