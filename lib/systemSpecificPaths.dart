import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform, Directory;

Future<Directory> systemSpecificFilePath() async {
  Directory appDocDirectory;
  if (Platform.isIOS) {
    appDocDirectory = await getApplicationDocumentsDirectory();
  } else {
    appDocDirectory = await getExternalStorageDirectory();
  }

  return appDocDirectory;
}
