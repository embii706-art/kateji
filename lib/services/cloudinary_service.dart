import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // TODO: Replace with your Cloudinary credentials
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'karteji_preset';
  
  late CloudinaryPublic cloudinary;

  CloudinaryService() {
    cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
  }

  Future<String?> uploadImage({
    required File file,
    required String folder,
    String? publicId,
  }) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          publicId: publicId,
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  Future<String?> uploadDocument({
    required File file,
    required String folder,
    String? publicId,
  }) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          file.path,
          folder: folder,
          publicId: publicId,
          resourceType: CloudinaryResourceType.Auto,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading document to Cloudinary: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String publicId) async {
    try {
      await cloudinary.deleteFile(
        url: publicId,
        resourceType: CloudinaryResourceType.Image,
        invalidate: true,
      );
      return true;
    } catch (e) {
      print('Error deleting from Cloudinary: $e');
      return false;
    }
  }

  String getOptimizedUrl(String url, {int? width, int? height, String? quality}) {
    // Transform Cloudinary URL for optimization
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments.toList();
    
    List<String> transformations = [];
    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (quality != null) transformations.add('q_$quality');
    
    if (transformations.isNotEmpty) {
      pathSegments.insert(pathSegments.indexOf('upload') + 1, transformations.join(','));
    }
    
    return uri.replace(pathSegments: pathSegments).toString();
  }
}
