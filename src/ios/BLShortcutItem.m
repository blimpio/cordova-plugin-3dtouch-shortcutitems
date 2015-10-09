//
//  MyFirstPlugin.m
//  HelloCordova
//
//  Created by Giovanni Collazo on 10/8/15.
//
//

#import "BLShortcutItem.h"

@implementation BLShortcutItem

- (void) webViewDidFinishLoad: (CDVInvokedUrlCommand *) command {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewDidFinishLoad" object:nil];

    NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"success", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
