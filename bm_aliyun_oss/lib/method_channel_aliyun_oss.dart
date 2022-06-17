import 'dart:typed_data';

import 'package:bm_aliyun_oss/bm_aliyun_oss.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const MethodChannel _methodChannel = MethodChannel('bm_aliyun_oss');

class MethodChannelAliyunOSS extends BmAliyunOss {
  MethodChannelAliyunOSS() {
    _methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    debugPrint('回调方法: ${methodCall.method}, 参数: ${methodCall.arguments}');

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
    String? filePath,
    Uint8List? data,
  }) async {
    return _methodChannel.invokeMethod(
      'upload',
      {
        "bucketName": bucketName,
        'objectKey': objectKey,
        'filePath': filePath,
        'data': data,
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
  Future<dynamic> url({
    String? bucketName,
    required String objectKey,
  }) async {
    return _methodChannel.invokeMethod(
      'getTemp',
      {
        "bucketName": bucketName,
        'objectKey': objectKey,
      },
    );
  }

}
