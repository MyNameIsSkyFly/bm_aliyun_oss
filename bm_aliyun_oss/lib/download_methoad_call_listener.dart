
import 'Model/init_model.dart';
import 'Model/upload_progress_model.dart';
import 'Model/upload_result_model.dart';

typedef DownloadInitListener = void Function(InitModel initModel);
typedef DownloadProgressListener = void Function(UploadProgressModel progressModel);
typedef DownloadResultListener = void Function(UploadResultModel resultModel);

class DownloadMethodCallListener {
  DownloadMethodCallListener({
    this.initListener,
    this.progressListener,
    this.successListener,
    this.failListener,
  });

  final DownloadInitListener? initListener;
  final DownloadProgressListener? progressListener;
  final DownloadResultListener? successListener;
  final DownloadResultListener? failListener;
}




