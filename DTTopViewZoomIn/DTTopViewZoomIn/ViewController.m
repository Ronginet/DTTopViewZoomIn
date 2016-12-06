//
//  ViewController.m
//  DTTopViewZoomIn
//
//  Copyright © 2016年 dtlr. All rights reserved.
//

#import "ViewController.h"
#import "HeaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)RightBarBtn:(id)sender {
    
    HeaderViewController *headerVC = [[HeaderViewController alloc]init];
    [self.navigationController pushViewController:headerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
