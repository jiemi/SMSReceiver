//
//  Tweak.h
//  SMSReceiver
//

@interface IMDaemonController
+ (id)sharedController;
- (BOOL)connectToDaemon;
@end

@interface NSConcreteNotification
- (id)userInfo;
@end

@interface IMItem
@end

@interface IMMessageItem: IMItem
- (NSAttributedString *)body;
@end

@interface IMMessage: NSObject
- (IMMessageItem *)_imMessageItem;
@end

@interface NSString(SMSReceiver)
- (BOOL)isAppleCodeSMS;
@end

@interface SMSReceiver: NSObject
@end
