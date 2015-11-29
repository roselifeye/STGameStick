//
//  ViewController.m
//  STGameStick
//
//  Created by sy2036 on 2015-11-29.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import "ViewController.h"
#import "STGameStick.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    STGameStick *stickView = [[STGameStick alloc] initWithFrame:CGRectMake(200, 200, 128, 128)];
    [self.view addSubview:stickView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
