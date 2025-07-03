#import "TSStreamingInstaller.h"
#import "TSExploitManager.h"

- (void)installIPAAtPath:(NSString *)ipaPath {
    // 选择最佳漏洞
    TSExploitDescriptor *descriptor = [[TSExploitManager sharedManager] bestDescriptorForCurrentDevice];
    if (!descriptor) {
        [self showErrorAlert:@"No compatible exploit"];
        return;
    }
    
    // 使用流式安装器
    TSStreamingInstaller *installer = [[TSStreamingInstaller alloc] initWithIPAAtPath:ipaPath];
    installer.progressHandler = ^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress:progress];
        });
    };
    
    [installer installToDestination:[self installationPath]];
}
