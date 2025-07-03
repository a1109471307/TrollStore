#import "TSStreamingInstaller.h"
#import "minizip/unzip.h"

#define CHUNK_SIZE 16384

@implementation TSStreamingInstaller {
    unzFile _zipFile;
    BOOL _cancelled;
}

- (BOOL)installToDestination:(NSString *)destPath {
    // 打开ZIP文件
    _zipFile = unzOpen64([self.ipaPath UTF8String]);
    if (!_zipFile) return NO;
    
    // 遍历ZIP条目并流式解压
    unz_global_info64 globalInfo;
    unzGetGlobalInfo64(_zipFile, &globalInfo);
    
    for (int i = 0; i < globalInfo.number_entry; i++) {
        if (_cancelled) break;
        
        // 获取文件信息并解压
        unz_file_info64 fileInfo;
        char filename[256];
        unzGetCurrentFileInfo64(_zipFile, &fileInfo, filename, sizeof(filename), NULL, 0, NULL, 0);
        
        NSString *fullPath = [destPath stringByAppendingPathComponent:[NSString stringWithUTF8String:filename]];
        
        if (filename[strlen(filename)-1] == '/') {
            // 创建目录
            [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            // 流式解压文件
            FILE *fp = fopen([fullPath UTF8String], "wb");
            unzOpenCurrentFile(_zipFile);
            
            void *buffer = malloc(CHUNK_SIZE);
            while (true) {
                int bytes = unzReadCurrentFile(_zipFile, buffer, CHUNK_SIZE);
                if (bytes <= 0) break;
                fwrite(buffer, 1, bytes, fp);
            }
            
            fclose(fp);
            free(buffer);
            unzCloseCurrentFile(_zipFile);
        }
        
        // 更新进度
        float progress = (float)(i+1) / (float)globalInfo.number_entry;
        if (self.progressHandler) self.progressHandler(progress);
        
        unzGoToNextFile(_zipFile);
    }
    
    unzClose(_zipFile);
    return !_cancelled;
}

@end
