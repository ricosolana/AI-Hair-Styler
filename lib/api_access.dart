import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> api_barber_post(String host, String accessToken, String imagePath,
    String hairStyle, String hairColor,) async {
  final bytes = await File(imagePath).readAsBytes();

  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http', 
    host: rootUri.host, // host, 
    port: rootUri.port,
    path: '/api/barber', 
    queryParameters: {
    'style': hairStyle,
    'color': hairColor,
  });

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpeg'),);

  final responseStream = await request.send();
  final response = await http.Response.fromStream(responseStream);

  // TODO parse response image and display?
  if (response.statusCode == 200) {
    //final data = jsonDecode(response.body);
    log("success");
    log(response.body);
  } else {
    log('failed');
  }
}
