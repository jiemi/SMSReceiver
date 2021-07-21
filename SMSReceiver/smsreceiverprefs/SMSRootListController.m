//
//  SMSRootListController.m
//  SMSReceiver
//

#include "SMSRootListController.h"

@implementation SMSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

@end
