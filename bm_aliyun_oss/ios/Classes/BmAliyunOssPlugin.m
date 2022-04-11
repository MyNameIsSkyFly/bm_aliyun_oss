#import "BmAliyunOssPlugin.h"
#if __has_include(<bm_aliyun_oss/bm_aliyun_oss-Swift.h>)
#import <bm_aliyun_oss/bm_aliyun_oss-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bm_aliyun_oss-Swift.h"
#endif

@implementation BmAliyunOssPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBmAliyunOssPlugin registerWithRegistrar:registrar];
}
@end
