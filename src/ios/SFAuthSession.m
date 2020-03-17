#import <Availability.h>
#import "SFAuthSession.h"

#import <SafariServices/SFAuthenticationSession.h>
#import <AuthenticationServices/ASWebAuthenticationSession.h>

#import <Cordova/CDVAvailability.h>

SFAuthenticationSession *_sfAuthenticationSession = nil;
ASWebAuthenticationSession *_asWebAuthenticationSession = nil;

@implementation SFAuthSession;

- (void)pluginInitialize {
}

-(void)_start {
    if (_asWebAuthenticationSession != nil) {
        [_asWebAuthenticationSession start];
    }
}

- (void)start:(CDVInvokedUrlCommand *)command {
    NSString* redirectScheme = [command.arguments objectAtIndex:0];
    NSURL* requestURL = [NSURL URLWithString:[command.arguments objectAtIndex:1]];

    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iOSVersion >= 12.0f) {
        _asWebAuthenticationSession =
        [[ASWebAuthenticationSession alloc] initWithURL:requestURL
                                   callbackURLScheme:redirectScheme
                                   completionHandler:^(NSURL * _Nullable callbackURL,
                                                       NSError * _Nullable error) {
                                       CDVPluginResult *result;
                                       if (callbackURL) {
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: callbackURL.absoluteString];
                                       } else {
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"];
                                       }
                                       [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                                       _asWebAuthenticationSession = nil;
                                   }];
        if (iOSVersion >= 13.0f) {
            _asWebAuthenticationSession.presentationContextProvider = self;
        }

        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state != UIApplicationStateActive) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_start) name:UIApplicationDidBecomeActiveNotification object:nil];
        } else {
            [self _start];
        }
    } else if (iOSVersion >= 11.0f) {
        _sfAuthenticationSession =
        [[SFAuthenticationSession alloc] initWithURL:requestURL
                                   callbackURLScheme:redirectScheme
                                   completionHandler:^(NSURL * _Nullable callbackURL,
                                                       NSError * _Nullable error) {
                                       CDVPluginResult *result;
                                       if (callbackURL) {
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: callbackURL.absoluteString];
                                       } else {
                                           result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"];
                                       }
                                       [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                                       _sfAuthenticationSession = nil;
                                   }];
        [_sfAuthenticationSession start];
    }
}

- (ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(ASWebAuthenticationSession *)session API_AVAILABLE(ios(13.0)){
    return [[[UIApplication sharedApplication] windows] firstObject];
}

@end