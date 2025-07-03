#import <Foundation/Foundation.h>

@interface TSStreamingInstaller : NSObject
- (instancetype)initWithIPAAtPath:(NSString *)ipaPath;
- (BOOL)installToDestination:(NSString *)destinationPath;
@property (nonatomic, copy) void (^progressHandler)(float progress);
@end
