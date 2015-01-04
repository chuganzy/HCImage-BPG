//
//  ViewController.m
//  Example-Mac
//
//  Created by Takeru Chuganji on 1/4/15.
//
//

#import "ViewController.h"
#import "HCImage+BPG.h"

@interface ViewController ()
@property (weak) IBOutlet NSImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"bpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.imageView.image = [NSImage imageWithBPGData:data];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
