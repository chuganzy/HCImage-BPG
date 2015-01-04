//
//  ViewController.m
//  Example-iOS
//
//  Created by Takeru Chuganji on 1/4/15.
//
//

#import "ViewController.h"
#import "HCImage+BPG.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"bpg"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.imageView.image = [UIImage imageWithBPGData:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
