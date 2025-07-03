#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TSModuleType) {
    TSModuleTypeExploit,
    TSModuleTypeInstallation,
    TSModuleTypePersistence,
    TSModuleTypeSecurity
};

@protocol TSModuleProtocol <NSObject>
- (BOOL)executeWithParameters:(NSDictionary *)params;
- (void)cleanupResources;
@property (nonatomic, readonly) TSModuleType moduleType;
@end

@interface TSModuleManager : NSObject
+ (instancetype)sharedManager;
- (void)registerModule:(id<TSModuleProtocol>)module forType:(TSModuleType)type;
- (nullable id<TSModuleProtocol>)moduleForType:(TSModuleType)type;
- (BOOL)executeModule:(TSModuleType)type parameters:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
