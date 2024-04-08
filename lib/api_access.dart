import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<http.Response> apiBarberPost(
  String host,
  String accessToken,
  String imagePath,
  String hairStyle,
  String hairColor,
) async {
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

  //http.get(uri)

  //http.post(
  //  uri,
  //  headers: {'Authorization': 'Bearer $accessToken'},
  //  body:)
  //  .
  //  .timeout(const Duration(seconds: 5));

  //HttpClient().pos(host, port, path)

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpeg'),
    );

  final responseStream = 
    await request
    .send()
    .timeout(const Duration(seconds: 5));
  final response = await http.Response.fromStream(responseStream);

  return response;

  // TODO parse response image and display?
  //if (response.statusCode == 200) {
  //  //final data = jsonDecode(response.body);
  //  log("success");
  //  log(response.body);
  //  //return jsonDecode(response.body);
  //  // TODO now we must add the work url to the awaiting list
  //  //  so that the client may query it later
  //} else if (response.statusCode == 422) {
  //  log('access token expired');
  //}
  //else {
  //  log('failed');
  //}
}

Future<dynamic> apiRootPath(
  String host,
) async {
  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: '/',
  );

  final request = http.Request('GET', uri);

  final responseStream = await request.send();
  final response = await http.Response.fromStream(responseStream);

  if (response.statusCode == 200) {
    //final data = jsonDecode(response.body);
    log("success");
    log(response.body);

    //Fluttertoast.showToast(msg: 'Online');

    return jsonDecode(response.body);

    // TODO now we must add the work url to the awaiting list
    //  so that the client may query it later
  } else {
    log('failed');
  }
}
