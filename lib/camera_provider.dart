import 'package:camera/camera.dart';

class Wrapmeras {
  final List<CameraDescription> _cameras;

  Wrapmeras({required List<CameraDescription> cameras})
      : _cameras = cameras;

  CameraDescription getFrontCamera() {
    return _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
  }

  CameraDescription getBackCamera() {
    return _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
  }
}
