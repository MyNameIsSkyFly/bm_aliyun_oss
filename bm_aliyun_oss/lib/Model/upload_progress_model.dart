class UploadProgressModel {
  UploadProgressModel({
    this.objectKey,
    this.bytesSent,
    this.totalBytesSent,
    this.totalBytesExpectedToSend,
  });

  UploadProgressModel.fromJson(dynamic json) {
    objectKey = json['objectKey'];
    bytesSent = json['bytesSent'];
    totalBytesSent = json['totalBytesSent'];
    totalBytesExpectedToSend = json['totalBytesExpectedToSend'];
  }

  String? objectKey;
  int? bytesSent;
  int? totalBytesSent;
  int? totalBytesExpectedToSend;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['objectKey'] = objectKey;
    map['bytesSent'] = bytesSent;
    map['totalBytesSent'] = totalBytesSent;
    map['totalBytesExpectedToSend'] = totalBytesExpectedToSend;

    return map;
  }
}