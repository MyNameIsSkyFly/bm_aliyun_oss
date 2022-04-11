import 'dart:collection';
import 'package:bm_aliyun_oss/bm_aliyun_oss.dart';
import 'package:bm_aliyun_oss/upload_method_call_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'Model/init_model.dart';
import 'Model/upload_progress_model.dart';
import 'Model/upload_result_model.dart';
import 'download_methoad_call_listener.dart';

const MethodChannel _methodChannel = MethodChannel('bm_aliyun_oss');

class MethodChannelAliyunOSS extends BmAliyunOss {
  MethodChannelAliyunOSS() {
    _methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  final List<UploadMethodCallListener> _uploadMethodCallListeners = [];
  final List<DownloadMethodCallListener> _downloadMethodCallListeners = [];

  void _notifyUploadListeners(
      void Function(UploadMethodCallListener listener) callback) {
    _notifyListeners(callback, _uploadMethodCallListeners);
  }

  void _notifyDownloadListeners(
      void Function(DownloadMethodCallListener listener) callback) {
    _notifyListeners(callback, _downloadMethodCallListeners);
  }

  void _notifyListeners<T>(
      void Function(T listner) callback, List<T> listeners) {
    for (var element in UnmodifiableListView(listeners)) {
      if (listeners.contains(element)) {
        callback(element);
      }
    }
  }

  _toMap(dynamic data) {
    return (data as Map<dynamic, dynamic>)
        .map((key, value) => MapEntry('$key', value));
  }

  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    debugPrint('回调方法: ${methodCall.method}, 参数: ${methodCall.arguments}');
    switch (methodCall.method) {
      /// 上传文件
      case 'upload_init':
        InitModel initModel = InitModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("上传初始化: ${initModel.toJson()}");
        _notifyUploadListeners(
            (listener) => listener.initListener?.call(initModel));
        break;
      case "upload_progress":
        UploadProgressModel progressModel =
            UploadProgressModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("上传进度: ${progressModel.toJson()}");
        _notifyUploadListeners(
            (listener) => listener.progressListener?.call(progressModel));
        break;
      case "upload_success":
        UploadResultModel successModel =
            UploadResultModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("上传成功: ${successModel.toJson()}");
        _notifyUploadListeners(
            (listener) => listener.successListener?.call(successModel));
        break;
      case "upload_fail":
        UploadResultModel failModel =
            UploadResultModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("上传失败: ${failModel.toJson()}");
        _notifyUploadListeners(
            (listener) => listener.failListener?.call(failModel));
        break;
      /// 下载文件
      case "download_progress":
        UploadProgressModel progressData =
            UploadProgressModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("下载进度: ${progressData.toJson()}");
        _notifyDownloadListeners(
            (listener) => listener.progressListener?.call(progressData));
        break;
      case "download_success":
        UploadResultModel successData =
            UploadResultModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("下载成功: ${successData.toJson()}");
        _notifyDownloadListeners(
            (listener) => listener.successListener?.call(successData));
        break;
      case "download_fail":
        UploadResultModel failData =
            UploadResultModel.fromJson(_toMap(methodCall.arguments));
        debugPrint("下载失败: ${failData.toJson()}");
        _notifyDownloadListeners(
            (listener) => listener.failListener?.call(failData));
        break;
    }
  }

  @override
  init({
    required String endpoint,
    required String accessKeyId,
    required String secretKeyId,
    required String securityToken,
  }) {
    return _methodChannel.invokeMethod(
      'init',
      {
        "endpoint": endpoint,
        'accessKeyId': accessKeyId,
        'secretKeyId': secretKeyId,
        'securityToken': securityToken
      },
    );
  }

  @override
  Future<dynamic> upload({
    required String bucketName,
    required String objectKey,
    required String filePath,
  }) async {
    return _methodChannel.invokeMethod(
      'upload',
      {
        "bucketName": bucketName,
        'objectKey': objectKey,
        'filePath': filePath,
      },
    );
  }

  @override
  Future<dynamic> download({
    String? bucketName,
    required String objectKey,
  }) async {
    return _methodChannel.invokeMethod(
      'download',
      {
        "bucketName": bucketName,
        'objectKey': objectKey,
      },
    );
  }

  @override
  void addUploadMethodCallListener(UploadMethodCallListener listener) {
    _uploadMethodCallListeners.add(listener);
  }

  @override
  void removeUploadMethodCallListener(UploadMethodCallListener listener) {
    _uploadMethodCallListeners.remove(listener);
  }

  @override
  void addDownloadMethodCallListener(DownloadMethodCallListener listener) {
    _downloadMethodCallListeners.add(listener);
  }

  @override
  void removeDownloadMethodCallListener(DownloadMethodCallListener listener) {
    _downloadMethodCallListeners.remove(listener);
  }

}
