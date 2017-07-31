//
//  ViewController.m
//  AudioqueuePlay
//
//  Created by Hellen Yang on 2017/7/27.
//  Copyright © 2017年 yjl. All rights reserved.
//

#import "ViewController.h"
#import "QueuePlayer.h"
#import <AVFoundation/AVFoundation.h>
QueuePlayer *myPlayer;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test.pcm" ofType:nil]];
    NSData *data2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"浪花一朵朵片段8k16bit单声道.pcm" ofType:nil]];
    //    _pcmPlayer = [[PCMDataPlayer alloc] init];
    //
    //    [_pcmPlayer play:data.bytes length:data.length];
    
    data = [NSData dataWithBytes:data.bytes length:6000];
    data2 = [NSData dataWithBytes:data2.bytes+3000 length:80000];
    
    short * mData = malloc(160000);
    
    for (int i = 0; i < MAX(data.length, data2.length) / 2; ++i) {
        short mixed = 0;
        short * d1 = data.bytes;
        short * d2 = data2.bytes;
        if (i < MIN(data.length, data2.length)/2) {
            
            
            mixed = d1[i] + d2[i];
        } else {
            if (data.length > data2.length) {
                mixed = d2[i];
            } else {
                mixed = d2[i];
            }
        }
        
        
        mData[i] =  mixed ;
    }
    
//    myPlayer = [[QueuePlayer alloc] init];
    
    
    
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithData:data2 error:nil];
    play.delegate = self;
    if ([play play])
    {
    
    } else {
        NSLog(@"播放失败");
    }
    
    
//    NSData *mixdata = [NSData dataWithBytes:mData length:MAX(data.length, data2.length)];
//    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [myPlayer playerWithData:mixdata];
//    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
