//
//  YYView.h
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RootView.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FileUpAndDown.h"
#import "MBProgressHUD.h"
@protocol YYDelegate <NSObject>
- (void)sendYYNews:(NSString*)yyString;
@end

@interface YYView : RootView<AVAudioRecorderDelegate,AVAudioPlayerDelegate,FileUpAndDownDelegate>
{
    NSString *yyString;
    NSURL *recordUrl;
    NSURL *mp3FilePath;
    NSURL *audioFileSavePath;
}

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）

@property (strong, nonatomic) UIButton *record;//开始录音
@property (strong, nonatomic) UIButton *pause;//暂停录音
@property (strong, nonatomic) UIButton *resume;//恢复录音
@property (strong, nonatomic) UIButton *stop;//停止录音

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIImageView *talkPhone;
@property (nonatomic, strong) UIImageView *imageViewAnimation;
@property (nonatomic, strong) UIImageView *cancelTalk;
@property (nonatomic, strong) UIImageView *shotTime;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *countDownLabel;

@property(nonatomic,assign)id<YYDelegate>delegate;

- (void)startAudioPlayer:(NSString*)startYYString;
@end
