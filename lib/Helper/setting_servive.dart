import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SettingsService {
  static Future<File> _getSettingsFile() async {
    final directory = await getApplicationDocumentsDirectory();

    final systemFolder = Directory(
      '${directory.path}/DailyReportGenerator/system',
    );

    if (!await systemFolder.exists()) {
      await systemFolder.create(recursive: true);
    }

    return File('${systemFolder.path}/settings.json');
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final file = await _getSettingsFile();

      if (!await file.exists()) {
        return {};
      }

      final content = await file.readAsString();

      if (content.trim().isEmpty) {
        return {};
      }

      final decoded = jsonDecode(content);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (e) {
      print('Error loading settings: $e');
      return {};
    }
  }

  static Future<void> saveSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final file = await _getSettingsFile();

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(settings),
      );
    } catch (e) {
      print('Error saving settings: $e');
      rethrow;
    }
  }

  static Future<void> updateSettings(
    Map<String, dynamic> updates,
  ) async {
    final settings = await loadSettings();

    settings.addAll(updates);

    await saveSettings(settings);
  }

  static Future<bool> hasCompletedInitialSetup() async {
    final settings = await loadSettings();

    return settings['hasCompletedInitialSetup'] == true;
  }

  static Future<String> getUsername() async {
    final settings = await loadSettings();

    return settings['username']?.toString() ?? '';
  }
}