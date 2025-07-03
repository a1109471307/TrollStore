#import "TSStreamingInstaller.h"
#import "TSExploitManager.h"

- (void)installIPAAtPath:(NSString *)ipaPath {
    TSExploitDescriptor *descriptor = [[TSExploitManager sharedManager] bestExploitDescriptorForCurrentDevice];
    
    if (!descriptor) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误"
                                                                       message:@"当前设备或iOS版本没有可用的漏洞"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (![[TSExploitManager sharedManager] applyExploitWithDescriptor:descriptor]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误"
                                                                       message:@"漏洞应用失败"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    TSStreamingInstaller *installer = [[TSStreamingInstaller alloc] initWithIPAAtPath:ipaPath];
    
    __weak typeof(self) weakSelf = self;
    installer.progressHandler = ^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progressView setProgress:progress animated:YES];
            weakSelf.statusLabel.text = [NSString stringWithFormat:@"安装中: %.0f%%", progress * 100];
        });
    };
    
    installer.completionHandler = ^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [weakSelf showSuccessAlert:@"安装成功"];
            } else {
                [weakSelf showErrorAlert:[NSString stringWithFormat:@"安装失败: %@", error.localizedDescription]];
            }
            [weakSelf.progressView setHidden:YES];
        });
    };
    
    NSString *destinationPath = [self trollStoreInstallPath];
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0 animated:NO];
    self.statusLabel.text = @"准备安装...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [installer installToDestination:destinationPath];
    });
}
