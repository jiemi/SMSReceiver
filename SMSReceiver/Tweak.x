//
//  Tweak.x
//  SMSReceiver
//

//
// This tweak is based on libwebmessage, created by Aziz H. Many thanks for the great code!
// https://github.com/sgtaziz/WebMessage-Tweak/tree/main/libwebmessage
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "Tweak.h"

@implementation NSString(SMSReceiver)
- (BOOL)isAppleCodeSMS {
    if ([self containsString:@"http://"]
        || [self containsString:@"https://"]) {
        return NO;
    }

    NSString *pattern = @".*Apple ID.*\\b\\d{6}\\b";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSTextCheckingResult *result = [regex firstMatchInString:self
                                                     options:0
                                                       range:NSMakeRange(0, self.length)];
    if (result) {
        return YES;
    }
    return NO;
}
@end

@implementation SMSReceiver
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken = 0;
    __strong static SMSReceiver* sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"[SMSReceiver] init");

        IMDaemonController* controller = [%c(IMDaemonController) sharedController];
        if ([controller connectToDaemon]) {
            NSLog(@"[SMSReceiver] Connected to deamon.");
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:)
                                                         name:@"__kIMChatMessageReceivedNotification"
                                                       object:nil];
        } else {
            NSLog(@"[SMSReceiver] Unable to connect to deamon.");
        }
    }
    return self;
}

- (void)receivedNotification: (NSConcreteNotification *)notif {
    IMMessage *message = [[notif userInfo] objectForKey:@"__kIMChatValueKey"];

    if (message == nil) return;

    IMMessageItem *item = [message _imMessageItem];
    NSString *text = [[item body] string];

    NSLog(@"[SMSReceiver] received message:%@", text);

    if (text.isAppleCodeSMS) {
        [self postToSlack:text];
    }
}

- (void)postToSlack: (NSString *)text {
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"dev.yourcompany.smsreceiverprefs"];

    NSString *urlString = [[bundleDefaults objectForKey:@"urlString"] stringValue];
    if (urlString.length == 0) {
        NSLog(@"[SMSReceiver] URL is empty.");
        return;
    }

    NSString *payload = [NSString stringWithFormat:@"{\"text\":\"%@\"}", text];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [payload dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"[SMSReceiver] POST failed with Error: %@", error);
            return;
        }

        NSLog(@"[SMSReceiver] POST succeeded.");

    }];

    [task resume];
}
@end

%hook IMDaemonController
- (unsigned)_capabilities {
    return 17159;
}
%end

%hook SBHomeScreenViewController
-(void)viewDidLoad {
    %orig;

    NSLog(@"[SMSReceiver] SBHomeScreenViewController#viewDidLoad");

    [SMSReceiver sharedInstance];
}
%end
