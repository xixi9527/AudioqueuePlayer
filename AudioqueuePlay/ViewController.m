//
//  ViewController.m
//  AudioqueuePlay
//
//  Created by Hellen Yang on 2017/7/27.
//  Copyright © 2017年 yjl. All rights reserved.
//

#import "ViewController.h"
#import "QueuePlayer.h"

QueuePlayer *myPlayer;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    
    myPlayer = [[QueuePlayer alloc] init];
    [myPlayer startPlay];
    [myPlayer startRecord];
    

    myPlayer.recordBack = ^(NSData *data) {
        [myPlayer playerWithData:data];
    };
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
