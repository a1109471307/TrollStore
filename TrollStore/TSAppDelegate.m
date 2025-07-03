#import "TSModuleManager.h"
#import "TSExploitManager.h"
@implementation TSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化漏洞管理器
    NSString *exploitsPath = [[NSBundle mainBundle] pathForResource:@"Exploits" ofType:nil];
    [[TSExploitManager sharedManager] loadExploitDescriptorsFromDirectory:exploitsPath];
    
    // 注册核心模块（这里需要实际模块实现）
    // id<TSModuleProtocol> exploitModule = [TSExploitModule new];
    // [[TSModuleManager sharedManager] registerModule:exploitModule forType:TSModuleTypeExploit];
    //
    // id<TSModuleProtocol> installModule = [TSInstallationModule new];
    // [[TSModuleManager sharedManager] registerModule:installModule forType:TSModuleTypeInstallation];
    
    // 其余初始化代码...
    
    return YES;
}(NSDictionary *)launchOptions {
	return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
