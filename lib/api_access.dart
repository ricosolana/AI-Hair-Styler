import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:senior_project_hair_ai/preferences_provider.dart';
import 'package:senior_project_hair_ai/screens/settings.dart';

class TaskProgress {
  //late TaskStatus status; //': task.status.name,
  late String status;
  //'status-value': task.status.value,
  int? currentTransformerPercentage;
  late double timeQueued;
  late double timeAlignStarted;
  late double timeBarberStarted;
  //#'time-barber-started': task.time_barber_started(),
  late double timeBarberEnded;
  late double initialBarberDurationEstimate;
  //#'initial-barber-duration-estimate': task.initial_barber_duration_estimate(),
  late double durationBarber;
  //late double estimateTimeBarberEnded;

  TaskProgress.fromJson(Map<String, dynamic> json) {
    //status = TaskStatus.values.byName((json['status'] as String).toLowerCase().);
    //status = TaskStatus.values[json['status-value'] as int];
    status = json['status-label'] as String;
    currentTransformerPercentage = json['current-transformer-percentage'];
    timeQueued = json['time-queued'].toDouble();
    timeAlignStarted = json['time-align-started'].toDouble();
    timeBarberStarted = json['time-barber-started'].toDouble();
    timeBarberEnded = json['time-barber-ended'].toDouble();
    initialBarberDurationEstimate =
        json['initial-barber-duration-estimate'].toDouble();
    durationBarber = json['duration-barber'].toDouble();
  }
}

Future<TaskProgress> getBarberStatus(
    String host, String accessToken, String workID,) async {
  final response = await bapiApiBarberStatus(
      host: host, accessToken: accessToken, workID: workID,);
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return TaskProgress.fromJson(json);
}

Future<http.Response> bapiApiBarberPost({
  required String host,
  required String accessToken,
  @Deprecated('specify the imageBytes instead') String? imagePath,
  Uint8List? imageBytes,
  required String hairStyle,
  required String hairColor,
  bool demo = false,
  double quality = 1.0,
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
      http.MultipartFile.fromBytes(
        'image',
        imageBytes!,
        filename: 'image.jpeg',
      ),
    );

  // TODO
  final responseStream =
      await request.send().timeout(Duration(seconds: getPreferences().ensure<int>(apiTimeoutPrefKey)));
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
      await request.send().timeout(Duration(seconds: getPreferences().ensure<int>(apiTimeoutPrefKey)));
  return http.Response.fromStream(responseStream);
}

Future<bool> checkAccessToken(
  String host,
  String accessToken, {
  bool quietSuccess = false,
}) async {
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
      Fluttertoast.showToast(
        msg: 'Unknown error (${response.reasonPhrase}, $code)',
      );
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
      await request.send().timeout(Duration(seconds: getPreferences().ensure<int>(apiTimeoutPrefKey)));
  return http.Response.fromStream(responseStream);
}

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

Future<http.Response> bapiApiBarberStatus({
  required String host,
  required String accessToken,
  required String workID,
}) async {
  final rootUri = Uri.parse(host);

  final uri = Uri(
    scheme: rootUri.scheme, //'http',
    host: rootUri.host, // host,
    port: rootUri.port,
    path: '/api/status',
    queryParameters: {
      'work-id': workID,
    },
  );

  final request = http.Request('GET', uri)
    ..headers['Authorization'] = 'Bearer $accessToken';

  final responseStream =
      await request.send().timeout(Duration(seconds: getPreferences().ensure<int>(apiTimeoutPrefKey)));
  return http.Response.fromStream(responseStream);
}

Uri bapiUrl(
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

  return uri;
}

Uri bapiGeneratedUrl(
  String host,
  String workID,
) {
  return bapiUrl(host, '/generated/$workID');
}

Uri bapiTemplatesUrl(
  String host,
  String imageName,
) {
  return bapiUrl(host, '/templates/$imageName');
}
