import Flutter
import UIKit
import AliyunOSSiOS

public class SwiftBmAliyunOssPlugin: NSObject, FlutterPlugin {

    let channel: FlutterMethodChannel
    var client: OSSClient!
    var bucketName: String!

    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bm_aliyun_oss", binaryMessenger: registrar.messenger())
        let instance = SwiftBmAliyunOssPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method{
        case "init":
            initClient(call)
            result(true);
        case "upload":
            upload(call,result)
        case "download":
            download(call,result)
        case "getTemp":
            getUrl(call,result)
        default:
            break
        }
    }

    func initClient(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any?]
        let endpoint = params["endpoint"] as! String
        let accessKeyId = params["accessKeyId"] as! String
        let secretKeyId = params["secretKeyId"] as! String
        let securityToken = params["securityToken"] as? String

        var credential: OSSCredentialProvider
        if (securityToken == nil) {
            credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: accessKeyId, secretKey: secretKeyId)
        } else {
            credential = OSSStsTokenCredentialProvider(accessKeyId: accessKeyId, secretKeyId: secretKeyId, securityToken: securityToken!)
        }
        client = OSSClient(endpoint: endpoint, credentialProvider: credential)

    }

    func upload(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let params = call.arguments as! [String: Any?]
        let bucketName = params["bucketName"] as! String
        let objectKey = params["objectKey"] as! String
        let filePath = params["filePath"] as? String
        let data = params["data"] as? FlutterStandardTypedData

        let request = OSSPutObjectRequest()
        request.bucketName = bucketName
        request.objectKey = objectKey //文件完整路径
        if(filePath != nil) {
            request.uploadingFileURL = URL.init(fileURLWithPath: filePath!)
        }

        if(data != nil){
            request.uploadingData = data!.data
        }

        let task = client.putObject(request)
        task.continue ({ t in
            self.showUpload(task: t, objectKey: request.objectKey, result: result)
        })

    }


    func download(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let params = call.arguments as! [String: Any?]
        let bucketName = params["bucketName"] as! String
        let objectKey = params["objectKey"] as! String

        let request = OSSGetObjectRequest()
        request.bucketName = bucketName
        request.objectKey = objectKey //文件完整路径

        let task = client.getObject(request)
        task.continue ({ t in
            self.showDownload(task: t, objectKey: request.objectKey,result: result)
        })

    }
    
    func getUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let params = call.arguments as! [String: Any?]
        let bucketName = params["bucketName"] as! String
        let objectKey = params["objectKey"] as! String

        let request = OSSGetObjectRequest()
        request.bucketName = bucketName
        request.objectKey = objectKey //文件完整路径

        let task = client.presignConstrainURL(withBucketName: bucketName, withObjectKey: objectKey, withExpirationInterval: 60*30)
        if(task.error != nil){
            result(nil);
        } else {
            result(task.result);
        }

    }




    func uploadProgressCallback(objectKey: String,
                                bytesSent: Int64,
                                totalBytesSent: Int64,
                                totalBytesExpectedToSend: Int64) {
      channel.invokeMethod("upload_progress", arguments: [
        "objectKey": objectKey,
        "bytesSent": bytesSent,
        "totalBytesSent": totalBytesSent,
        "totalBytesExpectedToSend": totalBytesExpectedToSend,
      ]);
    }

    func downloadProgressCallback(objectKey: String,
                                bytesSent: Int64,
                                totalBytesSent: Int64,
                                totalBytesExpectedToSend: Int64) {
      channel.invokeMethod("download_progress", arguments: [
        "objectKey": objectKey,
        "bytesSent": bytesSent,
        "totalBytesSent": totalBytesSent,
        "totalBytesExpectedToSend": totalBytesExpectedToSend,
      ]);
    }


    func showUpload(task: OSSTask<AnyObject>?, objectKey: String, result: @escaping FlutterResult) -> Void {

      if (task?.error != nil) {
        let error: NSError = (task?.error)! as NSError
        print(error)
//         uploadFailCallback(objectKey: objectKey, error: error)
        result("")
      } else {
        let taskResult = task?.result
//         uploadSuccessCallback(objectKey: objectKey)
        result(objectKey)
      }
    }

    func uploadSuccessCallback(objectKey: String, result: AnyObject? = nil) {
      channel.invokeMethod("upload_success", arguments: [
        "objectKey": objectKey,
        "result": result
      ])
    }

    func uploadFailCallback(objectKey: String, error: NSError) {
      channel.invokeMethod("upload_fail", arguments: [
        "objectKey": objectKey,
        "error": error
      ])
    }

    func showDownload(task: OSSTask<AnyObject>?, objectKey: String,result: @escaping FlutterResult) -> Void {

      if (task?.error != nil) {
        let error: NSError = (task?.error)! as NSError
//           downloadFailCallback(objectKey: objectKey, error: error)
          result(nil)

      } else {
          let taskResult = task?.result
//           downloadSuccessCallback(objectKey: objectKey,result: taskResult)
          let resultObject = taskResult as! OSSGetObjectResult
          result(FlutterStandardTypedData(bytes: resultObject.downloadedData))
      }
    }

    func downloadSuccessCallback(objectKey: String, result: AnyObject? = nil) {
        let resultObject = result as! OSSGetObjectResult
      channel.invokeMethod("download_success", arguments: [
        "objectKey": objectKey,
        "result": FlutterStandardTypedData(bytes: resultObject.downloadedData)
      ])
    }

    func downloadFailCallback(objectKey: String, error: NSError) {
      channel.invokeMethod("download_fail", arguments: [
        "objectKey": objectKey,
        "error": error
      ])
    }
}
