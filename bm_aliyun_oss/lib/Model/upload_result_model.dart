class UploadResultModel {
  UploadResultModel({
    this.objectKey,
    this.result,
    this.error,
  });

  UploadResultModel.fromJson(dynamic json) {
    objectKey = json['objectKey'];
    result = json['result'];
  }

  String? objectKey;
  dynamic result;
  dynamic error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['objectKey'] = objectKey;
    map['result'] = result;
    map['error'] = error;
    return map;
  }
}