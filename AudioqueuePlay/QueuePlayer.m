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
AudioQueueBufferRef rBuffer[QUEUE_BUFFER_SIZE];
AudioQueueBufferRef pBuffer[QUEUE_BUFFER_SIZE];



@interface QueuePlayer ()
{
    AudioQueueRef mQueue;
    
    AudioQueueRef playQueue;
    
    
    NSLock *lock;
}

@end

@implementation QueuePlayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
//        [[AVAudioSession sharedInstance] setPreferredInputNumberOfChannels:1 error:nil];
//        [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:0.1 error:nil];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        
        
        
        AudioStreamBasicDescription ASBD;
        ASBD.mBitsPerChannel = 16;
        ASBD.mBytesPerFrame = 2;
        ASBD.mBytesPerPacket = 2;
        ASBD.mChannelsPerFrame = 1;
        ASBD.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        ASBD.mFormatID = kAudioFormatLinearPCM;
        ASBD.mFramesPerPacket = 1;
        ASBD.mSampleRate = 8000;
        
        
        
        AudioQueueNewOutput(&ASBD, OutputCallback, (__bridge void * _Nullable)(self), nil, nil, 0, &playQueue);
        
        
        AudioQueueNewInput(&ASBD, InputCallback,(__bridge void * _Nullable)(self), nil, nil, 0, &mQueue);
        
        
        
        
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueAllocateBuffer(mQueue, MIN_SIZE_PER_FRAME, rBuffer+i);
            AudioQueueAllocateBuffer(playQueue, MIN_SIZE_PER_FRAME, pBuffer+i);
         
            
        }
        
        
        
        
        AudioQueueStart(mQueue, 0);
        AudioQueueStart(playQueue, 0);
        for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
            AudioQueueEnqueueBuffer(mQueue, rBuffer[i], 0, nil);
        }
        
        
        
        
        
        
        
    }
    return self;
}


- (void)startRecord
{
    
}


- (void)playerWithData:(NSData *)data
{
    AudioQueueBufferRef theBuffer = NULL;
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        if (audioQueueUsed[i]) {
            continue;
        }
        theBuffer = pBuffer[i];
        audioQueueUsed[i] = YES;
        
        
        memcpy(theBuffer->mAudioData, data.bytes, data.length);
        theBuffer->mAudioDataByteSize = data.length;
        AudioQueueEnqueueBuffer(playQueue, theBuffer, 0, nil);
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
        if (inBuffer == pBuffer[i]) {
            audioQueueUsed[i] = NO;
            
            NSLog(@"buff(%d) 使用完成",i);
            break;
            
        }
    }
}


void InputCallback(
                                void * __nullable               inUserData,
                                AudioQueueRef                   inAQ,
                                AudioQueueBufferRef             inBuffer,
                                const AudioTimeStamp *          inStartTime,
                                UInt32                          inNumberPacketDescriptions,
                                const AudioStreamPacketDescription * __nullable inPacketDescs)
{
    QueuePlayer *player = (__bridge QueuePlayer *)(inUserData);
     [player playWithbuffer:inBuffer];
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil);
   
}


- (void)playWithbuffer:(AudioQueueBufferRef )buffRef
{
    
    
    NSData *data = [NSData dataWithBytes:buffRef->mAudioData length:buffRef->mAudioDataByteSize];
    [self playerWithData:data];
    
    
}

@end
