
import 'Model/init_model.dart';
import 'Model/upload_progress_model.dart';
import 'Model/upload_result_model.dart';

typedef UploadInitListener = void Function(InitModel initModel);
typedef UploadProgressListener = void Function(UploadProgressModel progressModel);
typedef UploadResultListener = void Function(UploadResultModel resultModel);

class UploadMethodCallListener {
  UploadMethodCallListener({
    this.initListener,
    this.progressListener,
    this.successListener,
    this.failListener,
  });

  final UploadInitListener? initListener;
  final UploadProgressListener? progressListener;
  final UploadResultListener? successListener;
  final UploadResultListener? failListener;
}




