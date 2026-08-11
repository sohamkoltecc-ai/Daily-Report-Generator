import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageHelper {

  static Future<Directory> getProjectImageFolder(String projectName) async {

    final docs = await getApplicationDocumentsDirectory();

    final folder = Directory(
      "${docs.path}/DailyReportGenerator/images/$projectName",
    );

    if(!await folder.exists()){
      await folder.create(recursive: true);
    }

    return folder;
  }

  static Future<String?> saveImage(
    File image,
    String projectName,
) async {

  final folder =
      await getProjectImageFolder(projectName);

  final filename =
      "IMG_${DateTime.now().millisecondsSinceEpoch}.png";

  final destination =
      "${folder.path}/$filename";

  await image.copy(destination);

  return destination;
}


}