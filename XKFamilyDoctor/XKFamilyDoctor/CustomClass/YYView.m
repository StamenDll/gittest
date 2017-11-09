//
//  YYView.m
//  XKFamilyDoctor
//
//  Created by Apple on 16/12/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYView.h"
#import "lame.h"
#define GetImage(imageName)  [UIImage imageNamed:imageName]
@implementation YYView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    UIButton *voiceButton=[UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [voiceButton addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchDown];
    [voiceButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
    [voiceButton addTarget:self action:@selector(promptCancelRecordOnclick) forControlEvents:UIControlEventTouchDragExit];
    [voiceButton addTarget:self action:@selector(promptCancelRecordOnclick) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:voiceButton];
    [voiceButton.layer setCornerRadius:5];
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    UILabel *voiceLabel=[UILabel new];
    voiceLabel.text=@"按住说话";
    voiceLabel.textColor=TEXTCOLOR;
    voiceLabel.textAlignment=1;
    voiceLabel.font=[UIFont fontWithName:FONTTYPEME size:MIDDLEFONT];
    [voiceButton addSubview:voiceLabel];
    [voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(voiceButton);
        make.centerY.equalTo(voiceButton);
        make.height.mas_equalTo(20);
    }];
}
/**
 *  点击开始按钮
 *
 *  @param sender 开始按钮
 */
- (void)recordClick:(UIButton *)sender {
    [self initHUBViewWithView:self];
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer stop];
    }
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    if(self.audioRecorder == nil) {
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        //....其他设置等
        recordUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"]];
        
        //初始化AVAudioRecorder
        NSError *err = nil;
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordUrl settings:recordSetting error:&err];
        self.audioRecorder.delegate=self;
    }
    if (![self.audioRecorder isRecording]) {
       	[self.audioRecorder prepareToRecord];
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder record];
        [self.audioRecorder recordForDuration:0];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.0001 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
}

- (void)promptCancelRecordOnclick{
    [_HUD removeFromSuperview];
    _HUD = nil;
    [self.timer invalidate];
    self.timer = nil;
    [self.audioRecorder deleteRecording];
    [self.audioRecorder stop];
}

- (void)initHUBViewWithView:(UIView *)view {
    if (_HUD) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    if (view == nil) {
        view = [[[UIApplication sharedApplication] windows] lastObject];
    }
    if (_HUD == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:view];
        _HUD.opacity = 0.4;
        
        CGFloat left = 22;
        CGFloat top = 0;
        top = 18;
        
        UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 120)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 37, 70)];
        _talkPhone = imageView;
        _talkPhone.image = GetImage(@"toast_microphone");
        [cv addSubview:_talkPhone];
        left += CGRectGetWidth(_talkPhone.frame) + 16;
        
        top+=7;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 29, 64)];
        _imageViewAnimation = imageView;
        [cv addSubview:_imageViewAnimation];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 52, 61)];
        _cancelTalk = imageView;
        _cancelTalk.image = GetImage(@"toast_cancelsend");
        [cv addSubview:_cancelTalk];
        _cancelTalk.hidden = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 24, 18, 60)];
        self.shotTime = imageView;
        _shotTime.image = GetImage(@"toast_timeshort");
        [cv addSubview:_shotTime];
        _shotTime.hidden = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 70, 71)];
        self.countDownLabel = label;
        self.countDownLabel.backgroundColor = [UIColor clearColor];
        self.countDownLabel.textColor = [UIColor whiteColor];
        self.countDownLabel.textAlignment = NSTextAlignmentCenter;
        self.countDownLabel.font = [UIFont systemFontOfSize:60.0];
        [cv addSubview:self.countDownLabel];
        self.countDownLabel.hidden = YES;
        
        left = 0;
        top += CGRectGetHeight(_imageViewAnimation.frame) + 20;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 130, 14)];
        self.textLable = label;
        _textLable.backgroundColor = [UIColor clearColor];
        _textLable.textColor = [UIColor whiteColor];
        _textLable.textAlignment = NSTextAlignmentCenter;
        _textLable.font = [UIFont systemFontOfSize:14.0];
        _textLable.text = @"手指上滑，取消发送";
        [cv addSubview:_textLable];
        
        _HUD.customView = cv;
        
        // Set custom view mode
        _HUD.mode = MBProgressHUDModeCustomView;
    }
    if ([view isKindOfClass:[UIWindow class]]) {
        [view addSubview:_HUD];
    } else {
        [view.window addSubview:_HUD];
    }
    [_HUD show:YES];
}


- (void)stopClick:(UIButton *)sender {
    if (self.audioRecorder.currentTime<1.0f) {
        _imageViewAnimation.hidden = YES;
        _talkPhone.hidden = YES;
        _cancelTalk.hidden = YES;
        _shotTime.hidden = NO;
        _countDownLabel.hidden = YES;
        [_textLable setFrame:CGRectMake(0, 100, 130, 25)];
        _textLable.text = @"说话时间太短";
        _textLable.backgroundColor = [UIColor clearColor];
        
        [self performSelector:@selector(stopSoundRecord) withObject:nil afterDelay:1.5f];
    }else{
        [_HUD removeFromSuperview];
        _HUD = nil;
        [self.timer invalidate];
        self.timer = nil;
        [self.audioRecorder stop];
        [self transformCAFToMP3];
    }
}

- (void)stopSoundRecord{
    [_HUD removeFromSuperview];
    _HUD = nil;
    [self.timer invalidate];
    self.timer = nil;
    [self.audioRecorder deleteRecording];
    [self.audioRecorder stop];
}

- (void)startAudioPlayer:(NSString*)startYYString{
    NSError *error=nil;
    NSString *PICURL=@"";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICURL,startYYString]];
    
    NSData * audioData =[NSData dataWithContentsOfURL:url];
    NSLog(@"===========%@",audioData);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //将数据保存到本地指定位置
    //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3",docDirPath,@"temp"];
    //    [audioData writeToFile:filePath atomically:YES];
    //    //播放本地音乐
    //    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    _audioPlayer=[[AVAudioPlayer alloc]initWithData:audioData error:&error];
    _audioPlayer.volume = 1.0f;
    _audioPlayer.numberOfLoops=0;
    _audioPlayer.delegate=self;
    
    if (!_audioPlayer||!audioData){
        return;
    }
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
}

- (void)transformCAFToMP3 {
    mp3FilePath = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"myselfRecord.mp3"]];
    @try {
        int read, write;
        
        FILE *pcm = fopen([[recordUrl absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read=fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        audioFileSavePath = mp3FilePath;
        NSData *yyData = [NSData dataWithContentsOfFile:mp3FilePath.absoluteString];
        
        FileUpAndDown *file=[FileUpAndDown new];
        file.delegate=self;
        yyString=[NSString stringWithFormat:@"%@.mp3",[self getUniqueStrByUUID]];
//        [file uploadFile:UPLOADFILE andData:yyData andFileName:yyString andController:nil];
        [self.audioRecorder deleteRecording];
    }
}

- (void)uploadDataSuccess:(id)message{
    if ([self.delegate respondsToSelector:@selector(sendYYNews:)]) {
        [self.delegate sendYYNews:yyString];
    }
}

- (void)uploadDataFail{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:nil message:@"语音发送失败请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    _audioPlayer.delegate=nil;
    _audioPlayer=nil;
}

- (void)levelTimerCallback:(NSTimer *)timer {
    if (_audioRecorder&&_imageViewAnimation) {
        [_audioRecorder updateMeters];
        double ff = [_audioRecorder averagePowerForChannel:0];
        ff = ff+60;
        if (ff>0&&ff<=10) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_0")];
        } else if (ff>10 && ff<20) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_1")];
        } else if (ff >=20 &&ff<30) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_2")];
        } else if (ff >=30 &&ff<40) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_3")];
        } else if (ff >=40 &&ff<50) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_4")];
        } else if (ff >= 50 && ff < 60) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_5")];
        } else if (ff >= 60 && ff < 70) {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_6")];
        } else {
            [_imageViewAnimation setImage:GetImage(@"toast_vol_7")];
        }
    }
}


@end
