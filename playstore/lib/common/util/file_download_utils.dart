import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ismart/common/util/custom_toast.dart';
import 'package:ismart/common/util/file_utils.dart';
import 'package:ismart/feature/authentication/resource/user_repository.dart';
import 'package:open_filex/open_filex.dart';

enum FileType {
  excel("xlsx"),
  pdf("pdf"),
  jpeg("jpeg"),
  png("png");

  final String extension;
  const FileType(this.extension);
}

class FileDownloadUtils {
  static Timer? _timer;
  static String? _currentTaskId;

  /// Download file and auto-open when complete
  static Future<String?> downloadFile({
    required String downloadLink,
    required String fileName,
    required BuildContext context,
  }) async {
    final String? _downloadPath = await FileUtils.getDownloadPath;
    final _token = RepositoryProvider.of<UserRepository>(context).token;

    if (_downloadPath != null) {
      final String? _taskID = await FlutterDownloader.enqueue(
        url: downloadLink,
        savedDir: _downloadPath,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
        headers: {"Authorization": "Bearer $_token"},
      );

      if (_taskID != null) {
        CustomToast.success(message: "Downloading...");
        _currentTaskId = _taskID;

        // Start polling for download completion
        _startCheckingDownloadStatus(_taskID, _downloadPath, fileName);
      }
      return _taskID;
    } else {
      CustomToast.error(message: "Could not access download directory");
      return null;
    }
  }

  /// Poll download status and open file when complete
  static void _startCheckingDownloadStatus(
    String taskId,
    String downloadPath,
    String fileName,
  ) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskId'",
      );

      if (tasks != null && tasks.isNotEmpty) {
        final task = tasks.first;

        if (task.status == DownloadTaskStatus.complete) {
          timer.cancel();
          _timer = null;

          // Wait a bit to ensure file is fully written
          await Future.delayed(const Duration(milliseconds: 500));

          // Open the file
          final filePath = '$downloadPath/$fileName';
          final result = await OpenFilex.open(filePath);

          if (result.type == ResultType.done) {
            CustomToast.success(message: "File opened successfully");
          } else if (result.type == ResultType.noAppToOpen) {
            CustomToast.error(message: "No app available to open this file");
          } else if (result.type == ResultType.fileNotFound) {
            CustomToast.error(message: "File not found");
          } else if (result.type == ResultType.permissionDenied) {
            CustomToast.error(message: "Permission denied to open file");
          } else {
            CustomToast.error(message: "Could not open file");
          }
        } else if (task.status == DownloadTaskStatus.failed) {
          timer.cancel();
          _timer = null;
          CustomToast.error(message: "Download failed");
        } else if (task.status == DownloadTaskStatus.canceled) {
          timer.cancel();
          _timer = null;
          CustomToast.error(message: "Download canceled");
        }
      }
    });
  }

  static String generateDownloadFileName({
    required String name,
    required FileType filetype,
  }) {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return "$name $timeStamp.${filetype.extension}";
  }

  /// Cancel any ongoing checks
  static void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
