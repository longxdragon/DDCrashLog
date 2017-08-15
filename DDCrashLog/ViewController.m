//
//  ViewController.m
//  DDCrashLog
//
//  Created by longxdragon on 2017/4/26.
//  Copyright © 2017年 longxdragon. All rights reserved.
//

#import "ViewController.h"

@interface Test : NSObject {
    @public
    int a;
    int b;
}
@end

@implementation Test

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signalExceptionCall:(id)sender {
    Test *t = [[Test alloc] init];
    free(&t);
    t->a = 5;
}

- (IBAction)uncautchExceptionCall:(id)sender {
    NSArray *array = @[@"Jack"];
    [array objectAtIndex:2];
}

@end
