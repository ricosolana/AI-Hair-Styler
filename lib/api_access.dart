import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const int timeout = 5;

class TaskProgress {
  late String status;
  late String statusLabel;
  int? currentTransformerPercentage;
  int? utcQueued;
  int? utcAlignStarted;
  int? utcBarberStarted;
  int? utcBarberEnded;
  int? initialBarberDurationEstimate;

  TaskProgress.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String;
    statusLabel = json['status-label'] as String;
    currentTransformerPercentage = json['current-transformer-percentage'];
    utcQueued = json['utc-queued'];
    utcAlignStarted = json['utc-align-started'];
    utcBarberStarted = json['utc-barber-started'];
    utcBarberEnded = json['utc-barber-ended'];
    initialBarberDurationEstimate = json['initial-barber-duration-estimate'];
  }

  bool isDone() {
    return status.contains('DONE');
  }

  bool isSuccess() {
    return status.contains('SUCCESS');
  }

  String getEstimatedRemainingTimeString() {
    if (utcBarberStarted != null && initialBarberDurationEstimate != null) {
      final utcEstEndBarber = utcBarberStarted! + initialBarberDurationEstimate!;
      final utcNow = (DateTime.now().toUtc().millisecondsSinceEpoch) ~/ 1000.0;

      final diffSeconds = utcEstEndBarber - utcNow;

      if (diffSeconds >= 0) {
        final rSeconds = diffSeconds % 60;

        final diffMinutes = (diffSeconds - rSeconds) ~/ 60;
        final rMinutes = diffMinutes % 60;

        final diffHours = (diffMinutes - rMinutes) ~/ 60;
        final rHours = diffHours % 60;

        final diffDays = (diffHours - rHours) ~/ 24;
        final rDays = diffHours % 24;

        final diffWeeks = (diffDays - rDays) ~/ 7;
        final rWeeks = diffWeeks % 7;

        //
        return '~${rWeeks > 0 ? '${rWeeks}w' : ''}'
            '${rDays > 0 ? '${rDays}d' : ''}'
            '${rHours > 0 ? '${rHours}h' : ''}'
            '${rMinutes > 0 ? '${rMinutes}m' : ''}'
            '${rSeconds > 0 ? '${rSeconds}s' : ''}';
      }
    }
    return 'TBD';
  }

  String getElapsedTimeString() {
    final utcNow = (DateTime
        .now()
        .toUtc()
        .millisecondsSinceEpoch) ~/ 1000.0;
    final diffSeconds = utcNow - utcQueued!;

    final rSeconds = diffSeconds % 60;

    final diffMinutes = (diffSeconds - rSeconds) ~/ 60;
    final rMinutes = diffMinutes % 60;

    final diffHours = (diffMinutes - rMinutes) ~/ 60;
    final rHours = diffHours % 60;

    final diffDays = (diffHours - rHours) ~/ 24;
    final rDays = diffHours % 24;

    final diffWeeks = (diffDays - rDays) ~/ 7;
    final rWeeks = diffWeeks % 7;

    //
    return '${rWeeks > 0 ? '${rWeeks}w' : ''}'
        '${rDays > 0 ? '${rDays}d' : ''}'
        '${rHours > 0 ? '${rHours}h' : ''}'
        '${rMinutes > 0 ? '${rMinutes}m' : ''}'
        '${rSeconds > 0 ? '${rSeconds}s' : ''}';
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
    } else if (code == 404 || code >= 500) {
      Fluttertoast.showToast(msg: 'Server error or backend unavailable ($code)');
    } else if (code >= 400 && code < 500) {
      Fluttertoast.showToast(msg: 'Expired or invalid access token ($code)');
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
      await request.send().timeout(const Duration(seconds: timeout));
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
