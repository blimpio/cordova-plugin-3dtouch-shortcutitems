//
//  AppDelegate+Notification.m
//
// Created by Olivier Louvignes on 2012-05-06.
// Modified by Giovanni Collazo on 2015-10-09
//
// Copyright 2012 Olivier Louvignes. All rights reserved.
// MIT Licensed

#import "AppDelegate+Notification.h"
#import <objc/runtime.h>

UIApplicationShortcutItem *shortcutItem;
BOOL shouldRespondToShortcut = NO;

@implementation AppDelegate (Notification)

// its dangerous to override a method from within a category.
// Instead we will use method swizzling. we set this up in the load call.
+ (void)load {
    Method original, swizzled;
    original = class_getInstanceMethod(self, @selector(init));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_init));
    method_exchangeImplementations(original, swizzled);
}

- (AppDelegate *)swizzled_init {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationFinishedLaunching:)
               name:@"UIApplicationDidFinishLaunchingNotification" object:nil];

  // This actually calls the original init method over in AppDelegate. Equivilent to calling super
  // on an overrided method, this is not recursive, although it appears that way. neat huh?
  return [self swizzled_init];
}

- (void) applicationFinishedLaunching: (NSNotification *) notification {
    NSDictionary *launchOptions = notification.userInfo;
    launchOptions = notification.userInfo;

    if (launchOptions != nil) {
        UIApplicationShortcutItem *item = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];

        if (item) {
            shouldRespondToShortcut = YES;
            shortcutItem = item;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWebViewReady:) name:@"webViewDidFinishLoad" object:nil];
        }
    }
}

- (void) onWebViewReady: (NSNotification *)notification {
    if (shouldRespondToShortcut) {
        NSLog(@"Reacting to shorctutItem: %@", shortcutItem.type);
        NSString* jsString = [NSString stringWithFormat:@"window.onShortcutEvent({ data: '%@'})", shortcutItem.type];
        [self.viewController.commandDelegate evalJs:jsString];
        shouldRespondToShortcut = NO;
    }
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    // react to shortcut item selections
    NSLog(@"Reacting to shorctutItem: %@", shortcutItem.type);
    NSString* jsString = [NSString stringWithFormat:@"window.onShortcutEvent({ data: '%@'})", shortcutItem.type];
    [self.viewController.commandDelegate evalJs:jsString];
}

@end
