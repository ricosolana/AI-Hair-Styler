import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<http.Response> bapiApiBarberPost(
  String host,
  String accessToken,
  String imagePath,
  String hairStyle,
  String hairColor, {
  bool demo = false,
}) async {
  final bytes = await File(imagePath).readAsBytes();

  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: '/api/barber',
    queryParameters: {
      'style-file': hairStyle,
      'color-file': hairColor,
      if (demo) 'demo': '1',
    },
  );

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: 'image.jpeg'),
    );

  final responseStream =
      await request.send().timeout(const Duration(seconds: 5));
  return http.Response.fromStream(responseStream);
}

Future<http.Response> bapiGet(String host, {String path = '/'}) async {
  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: path,
  );

  final request = http.Request('GET', uri);

  final responseStream =
      await request.send().timeout(const Duration(seconds: 5));
  return http.Response.fromStream(responseStream);
}

/*
Future<http.Response> bapiRootPath(
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

  final responseStream =
      await request.send().timeout(const Duration(seconds: 5));
  return http.Response.fromStream(responseStream);
}*/

Future<http.Response> bapiApiTemplatesStyles(
  String host,
) async {
  return bapiGet(host, path: '/api/templates/styles');
}

Future<http.Response> bapiApiTemplatesList(
  String host,
) async {
  return bapiGet(host, path: '/api/templates/list');
}

String bapiUrl(
  String host,
  String path,
) {
  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: path,
  );

  return uri.toString();
}

String bapiGeneratedUrl(
  String host,
  String imageName,
) {
  return bapiUrl(host, '/generated/$imageName');
}

String bapiTemplatesUrl(
  String host,
  String imageName,
) {
  return bapiUrl(host, '/templates/$imageName');
}
