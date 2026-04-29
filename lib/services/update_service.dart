import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateService extends GetxService {
  final Dio _dio = Dio();
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final updateUrl = dotenv.env['UPDATE_METADATA_URL'];
      if (updateUrl == null || updateUrl.isEmpty) {
        debugPrint('UPDATE_METADATA_URL not set in .env');
        return;
      }

      // Fetch metadata
      final response = await _dio.get(updateUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> metadata;
        if (response.data is String) {
          metadata = jsonDecode(response.data);
        } else {
          metadata = response.data;
        }

        final remoteVersion = metadata['version'] as String?;
        final downloadUrl = metadata['download_url'] as String?;
        final releaseNotes =
            metadata['release_notes'] as String? ?? 'New version available.';

        if (remoteVersion != null && downloadUrl != null) {
          final packageInfo = await PackageInfo.fromPlatform();
          final localVersion = packageInfo.version;

          if (_isRemoteVersionGreater(localVersion, remoteVersion)) {
            _showUpdateDialog(
              context,
              remoteVersion,
              downloadUrl,
              releaseNotes,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
    }
  }

  bool _isRemoteVersionGreater(String localVersion, String remoteVersion) {
    List<int> localParts = localVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    List<int> remoteParts = remoteVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    for (int i = 0; i < 3; i++) {
      int local = i < localParts.length ? localParts[i] : 0;
      int remote = i < remoteParts.length ? remoteParts[i] : 0;
      if (remote > local) return true;
      if (remote < local) return false;
    }
    return false;
  }

  void _showUpdateDialog(
    BuildContext context,
    String version,
    String downloadUrl,
    String releaseNotes,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Obx(() {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E2C),
            title: Text(
              'Update Available ($version)',
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  releaseNotes,
                  style: const TextStyle(color: Colors.white70),
                ),
                if (isDownloading.value) ...[
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: downloadProgress.value,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(downloadProgress.value * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ],
            ),
            actions: [
              if (!isDownloading.value)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Later',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              if (!isDownloading.value)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    _downloadAndInstall(downloadUrl);
                  },
                  child: const Text('Update Now'),
                ),
            ],
          );
        });
      },
    );
  }

  Future<void> _downloadAndInstall(String downloadUrl) async {
    isDownloading.value = true;
    downloadProgress.value = 0.0;

    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/app-update.apk';

      await _dio.download(
        downloadUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      // Open the APK
      final result = await OpenFilex.open(filePath);
      debugPrint('OpenFilex result: ${result.message}');
    } catch (e) {
      debugPrint('Error downloading update: $e');
      Get.snackbar('Error', 'Failed to download update.');
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }
}
