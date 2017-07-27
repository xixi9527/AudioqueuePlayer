//
//  QueuePlayer.m
//  audioqueue 录音
//
//  Created by Hellen Yang on 2017/7/19.
//  Copyright © 2017年 yjl. All rights reserved.
//

#import "QueuePlayer.h"
#import <AVFoundation/AVFoundation.h>

BOOL audioQueueUsed[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef mBuffer[3];



@interface QueuePlayer ()
{
    AudioQueueRef mQueue;
    
    
    
    NSLock *lock;
}

@end

@implementation QueuePlayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        AudioStreamBasicDescription ASBD;
        ASBD.mBitsPerChannel = 16;
        ASBD.mBytesPerFrame = 2;
        ASBD.mBytesPerPacket = 2;
        ASBD.mChannelsPerFrame = 1;
        ASBD.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        ASBD.mFormatID = kAudioFormatLinearPCM;
        ASBD.mFramesPerPacket = 1;
        ASBD.mSampleRate = 8000;
        
        
        
        AudioQueueNewOutput(&ASBD, OutputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &mQueue);
        
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueAllocateBuffer(mQueue, MIN_SIZE_PER_FRAME, &mBuffer[i]);
        }
        
        
        AudioQueueStart(mQueue, 0);
        
        
        lock = [[NSLock alloc] init];
    }
    return self;
}





- (void)playerWithData:(NSData *)data
{
    AudioQueueBufferRef theBuffer = NULL;
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (audioQueueUsed[i]) {
            continue;
        }
        theBuffer = mBuffer[i];
        audioQueueUsed[i] = YES;
        
        
        memcpy(theBuffer->mAudioData, data.bytes, data.length);
        theBuffer->mAudioDataByteSize = data.length;
        AudioQueueEnqueueBuffer(mQueue, theBuffer, 0, nil);
        break;
    }
    
    
    
    //

}


void OutputCallback(
                 void * __nullable       inUserData,
                 AudioQueueRef           inAQ,
                 AudioQueueBufferRef     inBuffer)
{
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (inBuffer == mBuffer[i]) {
            audioQueueUsed[i] = NO;
            
            NSLog(@"buff(%d) 使用完成",i);
            break;
            
        }
    }
}

@end
