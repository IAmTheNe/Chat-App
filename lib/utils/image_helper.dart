import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  final ImagePicker _picker;

  ImagePickerHelper({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// It picks an image from the gallery or camera and returns a list of XFile.
  ///
  /// Args:
  ///   source (ImageSource): The source of the image. Can be either the camera or the gallery. Defaults
  /// to ImageSource
  ///   imageQuality (int): The quality of the image. Defaults to 100
  ///   isMultiple (bool): Whether to select multiple images or not. Defaults to false
  ///
  /// Returns:
  ///   A list of XFile objects.
  Future<List<XFile>> pickImage({
    required ImageSource source,
    int imageQuality = 100,
  }) async {
    bool isMultiple = source == ImageSource.gallery ? true : false;
    if (isMultiple) {
      return await _picker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    if (file == null) return [];
    return [file];
  }
}
