class InitModel {
  InitModel({
    this.filePath,
    this.objectKey,
  });

  InitModel.fromJson(dynamic json) {
    filePath = json['filePath'];
    objectKey = json['objectKey'];
  }

  String? filePath;
  String? objectKey;
  int? bytesSent;
  int? totalBytesSent;
  int? totalBytesExpectedToSend;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['filePath'] = filePath;
    map['objectKey'] = objectKey;

    return map;
  }
}