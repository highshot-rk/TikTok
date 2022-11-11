
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorController extends GetxController {
  final _faceDetector = FaceDetector(options: FaceDetectorOptions(
    enableClassification: true,
    enableLandmarks: true
  ));

  Future<String> processImage(inputImage) async {
    final faces = await _faceDetector.processImage(inputImage);
    print(faces);
    if (faces.isNotEmpty) {
      return detectSmile(faces.first.smilingProbability);
    }

    return 'Not Detected';
  }

  Future<Uint8List> bytesFromNetworkImage(String imageUrl) async {
  final ByteData data = await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
  final Uint8List bytes = data.buffer.asUint8List();
  return bytes;
}

  String detectSmile(smileProb) {
    if (smileProb > 0.86) {
      return 'Big smile with teeth';
    } else if (smileProb > 0.8) {
      return 'Big Smile';
    } else if (smileProb > 0.3) {
      return 'Smile';
    } else {
      return 'Sad';
    }
  }

}