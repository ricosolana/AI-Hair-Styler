
import 'package:camera/camera.dart';

class CameraProvider {
  final List<CameraDescription> _cameras;

  CameraProvider({required List<CameraDescription> cameras}) : _cameras = cameras;

  CameraDescription getFrontCamera() {
    return _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  }

  CameraDescription getBackCamera() {
    return _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
  }
}
