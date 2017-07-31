//
//  QueuePlayer.h
//  audioqueue 录音
//
//  Created by Hellen Yang on 2017/7/19.
//  Copyright © 2017年 yjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#define QUEUE_BUFFER_SIZE 6//队列缓冲个数
#define MIN_SIZE_PER_FRAME 1024 //每帧最小数据长度
@interface QueuePlayer : NSObject



@property (nonatomic, copy)void (^recordBack)(NSData *data);
- (void)playerWithData:(NSData *)data;


- (void)startRecord;
- (void)startPlay;
- (void)endRecord;
- (void)endPlay;







@end
