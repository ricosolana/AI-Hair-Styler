import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const int timeout = 5;

Future<http.Response> bapiApiBarberPost(
  {
    required String host,
    required String accessToken,
    @Deprecated('specify the imageBytes instead') String ?imagePath, 
    Uint8List ?imageBytes, 
    required String hairStyle,
    required String hairColor,
    bool demo = false,
    double quality = 1.0
}) async {
  if (imagePath != null) {
    imageBytes = await File(imagePath).readAsBytes();
  }  

  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: '/api/barber',
    queryParameters: {
      'style-file': hairStyle,
      'color-file': hairColor,
      'demo': demo ? 'true' : 'false',
      'quality': quality.toString(),
    },
  );

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..files.add(
      http.MultipartFile.fromBytes('image', imageBytes!, filename: 'image.jpeg'),
    );

  final responseStream =
      await request.send().timeout(const Duration(seconds: timeout));
  return http.Response.fromStream(responseStream);
}

Future<http.Response> bapiAuthCheck(String host, String accessToken) async {
  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: '/auth/check',
  );

  final request = http.Request('GET', uri)
    ..headers['Authorization'] = 'Bearer $accessToken';

  final responseStream =
      await request.send().timeout(const Duration(seconds: timeout));
  return http.Response.fromStream(responseStream);
}

Future<bool> checkAccessToken(String host, String accessToken, {bool quietSuccess=false}) async {  
  if (accessToken.isEmpty) {  
    Fluttertoast.showToast(msg: 'Set an access token first');
    return false;
  }

  return bapiAuthCheck(host, accessToken).then((response) {
    final code = response.statusCode;
    if (code == 200) {
      if (!quietSuccess) {
        Fluttertoast.showToast(msg: 'Verified');
      }
      return true;
    } else if (code >= 400 && code < 500) {
      Fluttertoast.showToast(msg: 'Expired or invalid access token ($code)');
    } else if (code >= 500) {
      Fluttertoast.showToast(msg: 'Server error or backend unavailable($code)');
    } else {
      Fluttertoast.showToast(msg: 'Unknown error (${response.reasonPhrase}, $code)');
    }
    return false;
  }).onError((error, stackTrace) {
    Fluttertoast.showToast(msg: 'Error connecting ($error)');
    return false;
  });
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
      await request.send().timeout(const Duration(seconds: timeout));
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
  String workID,
) {
  return bapiUrl(host, '/generated/$workID');
}

String bapiTemplatesUrl(
  String host,
  String imageName,
) {
  return bapiUrl(host, '/templates/$imageName');
}
