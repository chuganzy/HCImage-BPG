//
//  AppDelegate.m
//  Example-Mac
//
//  Created by Takeru Chuganji on 3/22/15.
//
//

#import "AppDelegate.h"
#import "HCImage+BPG.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *imageView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"bpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.imageView.animates = YES;
    self.imageView.image = [NSImage imageWithBPGData:data];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
