
import 'dart:async';

import 'package:bm_aliyun_oss/upload_method_call_listener.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'download_methoad_call_listener.dart';
import 'method_channel_aliyun_oss.dart';

class BmAliyunOss  extends PlatformInterface {
  BmAliyunOss() : super(token: _token);

  static final Object _token = Object();

  static BmAliyunOss _instance = MethodChannelAliyunOSS();

  static BmAliyunOss get instance => _instance;

  static set instance(BmAliyunOss instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  init({
    required String endpoint,
    required String accessKeyId,
    required String secretKeyId,
    required String securityToken,
  }) {
    throw UnimplementedError(
        'init() has not been implemented.');
  }

  /*
  * bucketName
  * objectKey 完整的文件路径
  * filePath 本地文件路径
  * */
  Future<dynamic> upload({
    required String bucketName,
    required String objectKey,
    required String filePath,
  }) {
    throw UnimplementedError(
        'upload() has not been implemented.');
  }

  Future<dynamic>  download({
    String? bucketName,
    required String objectKey,
  }) {
    throw UnimplementedError(
        'download() has not been implemented.');
  }

  addUploadMethodCallListener(UploadMethodCallListener listener) {
    throw UnimplementedError(
        'addUploadMethodCallListener() has not been implemented.');
  }

  removeUploadMethodCallListener(UploadMethodCallListener listener) {
    throw UnimplementedError(
        'removeUploadMethodCallListener() has not been implemented.');
  }

  addDownloadMethodCallListener(DownloadMethodCallListener listener) {
    throw UnimplementedError(
        'addDownloadMethodCallListener() has not been implemented.');
  }

  removeDownloadMethodCallListener(DownloadMethodCallListener listener) {
    throw UnimplementedError(
        'removeDownloadMethodCallListener() has not been implemented.');
  }
}
