package com.example.bm_aliyun_oss;

import android.content.Context;

import androidx.annotation.NonNull;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSS;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSStsTokenCredentialProvider;
import com.alibaba.sdk.android.oss.model.GetObjectRequest;
import com.alibaba.sdk.android.oss.model.GetObjectResult;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectResult;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class BmAliyunOssPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context context;
    private OSS oss;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bm_aliyun_oss");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init":
                Map<String, String> map1 = (Map<String, String>) call.arguments;
                OSSCredentialProvider credentialProvider = new OSSStsTokenCredentialProvider(map1.get("accessKeyId"), map1.get("secretKeyId"), map1.get("securityToken"));
                oss = new OSSClient(context, map1.get("endpoint"), credentialProvider, new ClientConfiguration());
                result.success(true);
                break;
            case "upload":
                Map<String, String> map2 = (Map<String, String>) call.arguments;
                PutObjectRequest put = new PutObjectRequest(map2.get("bucketName"), map2.get("objectKey"), map2.get("filePath"));
                oss.asyncPutObject(put, new OSSCompletedCallback<PutObjectRequest, PutObjectResult>() {
                    @Override
                    public void onSuccess(PutObjectRequest request, PutObjectResult putObjectResult) {
                        result.success(request.getObjectKey());
                    }

                    @Override
                    public void onFailure(PutObjectRequest request, ClientException clientExcepion, ServiceException serviceException) {
                        result.error("-1", "上传文件错误", null);
                    }
                });
                break;
            case "download":
                Map<String, String> map3 = (Map<String, String>) call.arguments;
                GetObjectRequest get = new GetObjectRequest(map3.get("bucketName"), map3.get("objectKey"));
                oss.asyncGetObject(get, new OSSCompletedCallback<GetObjectRequest, GetObjectResult>() {
                    @Override
                    public void onSuccess(GetObjectRequest request, GetObjectResult getObjectResult) {
                        result.success(getObjectResult.getObjectContent());
                    }

                    @Override
                    public void onFailure(GetObjectRequest request, ClientException clientExcepion, ServiceException serviceException) {
                        result.error("-1", "下载文件错误", null);
                    }
                });
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        oss = null;
    }
}
