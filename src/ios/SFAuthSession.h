#import <Cordova/CDVPlugin.h>
#import <AuthenticationServices/AuthenticationServices.h>

@interface SFAuthSession : CDVPlugin<ASWebAuthenticationPresentationContextProviding> {
}

// The hooks for our plugin commands
- (void)start:(CDVInvokedUrlCommand *)command;

- (void)_start;

@end
