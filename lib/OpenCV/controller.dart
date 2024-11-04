import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

///
class FacialRecognition {
  final String API_KEY =
      'elnFfi8NTkxYjdjNzYtOGQxNS00ZDNkLWI0NWYtYjQwYmU0MGQ5ZmMy';
  final String region = 'us';

  /// Register a Person Face /////
  Future<String?> registerPerson({
    String? name,
    String? id,
    required File imageFile,
  }) async {
    try {
      final String url = 'https://${region}.opencv.fr/person';

      // Encode image to base64
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      //
      print(base64Image.length);
      // Create the request body
      Map<String, dynamic> requestBody = {
        // "collections": null,
        // "date_of_birth": null,
        // "gender": null,
        "id": id,
        // "is_bulk_insert": null,
        "name": name,
        // "nationality": null,
        // "notes": null,
        "images": [base64Image],
      };

      // Custom JSON encoding to include null values

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-API-Key': API_KEY,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      // print(jsonEncode(requestBodyb));

      if (response.statusCode == 201) {
        print('Person registered : ${response.body}');
        return 'Face Registered Successfully';
      } else {
        print('Failed to register person. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      //
      return null;
      // print('Response body: ${response.body}');
    } catch (e) {
      print('Error in System: $e');
    }
  }

  /// to search a person face or recognize //

  Future<String?> verifyPerson({
    required String id,
    required File imageFile,
    double minScore = 0.7,
    String verificationMode = "FAST",
  }) async {
    try {
      // API URL
      final String url = 'https://${region}.opencv.fr/verify';

      // Encode the image to base64
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      // Create the request body
      Map<String, dynamic> requestBody = {
        "id": id,
        "images": [base64Image],
        "min_score": minScore,
        "verification_mode": verificationMode,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
        },
        body: jsonEncode(requestBody),
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      // Handle the response
      if (response.statusCode == 200) {
        print('Verification successful: ${response.body}');
        if (data['match'] != null) return 'Recognized Successfull';

        return 'Not Recognized';
      } else {
        print('Failed to verify person. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error while verifying person: $e');
    }
  }

  Future<void> searchPerson({
    required File imageFile,
  }) async {
    try {
      // API URL
      final String url = 'https://${region}.opencv.fr/search';

      // Encode the image to base64
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      // Create the request body
      Map<String, dynamic> requestBody = {
        "images": [base64Image],
        "max_results": 5,
        "min_score": 0.7,
        "search_mode": "ACCURATE"
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY,
        },
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        // print(' ${response.body}');
        print(data[0]['score']);
      } else {
        print('Failed to Found person. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error while verifying person: $e');
    }
  }
}
