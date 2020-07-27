//
//  SFBMMutableEditingMessageDetailController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/20.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMMutableEditingMessageDetailController.h"
#import "AvatarObject.h"

#import "CWVoiceView.h"
#import "UIView+CWChat.h"
#import "CWAudioPlayer.h"
#import "CWRecordModel.h"

#import "SFBMTextView.h"
//-------
//#import <Masonry.h>
#import "Masonry.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UtilMacro.h"
#import "MMFileUploadUtil.h"
#import "MMRichContentUtil.h"

#import "MMRichTitleModel.h"
#import "MMRichTextModel.h"
#import "MMRichImageModel.h"
#import "MMRichImageVoiceModel.h"
//日记模板
#import "SFBMDiaryModel.h"
#import "MMManage.h"
#import "NSDate+Extension.h"

#import "MMRichTitleCell.h"
#import "MMRichTextCell.h"
#import "MMRichImageCell.h"
#import "MMRichImageVoiceCell.h"

#import "MMRichEditAccessoryView.h"
#define PICKER_PowerBrowserPhotoLibirayText  @"请在iPhone的“设置->隐私->相机”中允许访问相机"
#import "WSDatePickerView.h"//时间选择器

@interface SFBMMutableEditingMessageDetailController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RichTextEditDelegate, MMRichEditAccessoryViewDelegate,UITextViewDelegate,ImagePickerDelegate,CWVoiceViewDelegate>
{
    NSInteger _selectColor;
    NSString *_selectTime;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomAllViewBottomConstraint;

//等距离排列
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button2X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button3X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button4X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button5X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button6X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button7X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

@property (weak, nonatomic) IBOutlet UIButton *viewButtonTime;
@property (weak, nonatomic) IBOutlet UIButton *viewButtonAddress;
@property (weak, nonatomic) IBOutlet UIButton *viewButtonPeople;
@property (weak, nonatomic) IBOutlet UIButton *viewButtonWrite;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor1;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor2;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor3;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor4;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor5;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor6;
@property (weak, nonatomic) IBOutlet UIButton *bottomButtonColor7 ;
@property (weak, nonatomic) IBOutlet UIView *bottonButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *traingleImageV;
//@property (weak, nonatomic) IBOutlet UILabel *placeHolderL;
//@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//@property (weak, nonatomic) IBOutlet SFBMTextView *contentTextView;

//图片
@property(nonatomic,strong)UIImage *picture;
//语音 view
@property(nonatomic,strong)CWVoiceView *voiceView;
//-------------------------------------------------
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) MMRichEditAccessoryView *contentInputAccessoryView;
@property (nonatomic, strong) MMRichTitleModel* titleModel;
@property (nonatomic, strong) NSMutableArray* datas;
@property (nonatomic, strong) NSMutableArray* extraDatas;
@property (nonatomic, strong) NSMutableArray* bottomBtnArray;

@property (nonatomic, strong) NSIndexPath* activeIndexPath;

@end

@implementation SFBMMutableEditingMessageDetailController

-(void)setButtonCornerUI
{
//    MYNSLog(@"self.mode.time.length==%ld",self.mode.time.length)
    _selectTime = [NSDate getCurrentTime];//默认获取当前时间

    if (self.mode.time.length>0) {
        _selectTime = self.mode.time;
        NSString *extraStr = [NSString stringWithFormat:@"   %@   ",self.mode.time];
        [self.viewButtonTime setTitle:extraStr forState:UIControlStateNormal];
    }

    [self baseCornerRaduisView:self.viewButtonTime radius:13 color:BASEBLUECOLOR wide:0.5];
    [self baseCornerRaduisView:self.viewButtonAddress radius:13 color:BASEBLUECOLOR wide:0.5];
    [self baseCornerRaduisView:self.viewButtonPeople radius:13 color:BASEBLUECOLOR wide:0.5];
    [self baseCornerRaduisView:self.viewButtonWrite radius:13 color:[UIColor lightGrayColor] wide:0.5];
    
    [self baseCornerRaduisView:self.bottomButtonColor1 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor2 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor3 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor4 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor5 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor6 radius:16.5 color:nil wide:0];
    [self baseCornerRaduisView:self.bottomButtonColor7 radius:16.5 color:nil wide:0];
    self.bottomButtonColor2.tag = 1;
    self.bottomButtonColor3.tag = 2;
    self.bottomButtonColor4.tag = 3;
    self.bottomButtonColor5.tag = 4;
    self.bottomButtonColor6.tag = 5;
    self.bottomButtonColor7.tag = 6;
    _bottomBtnArray = [NSMutableArray arrayWithObjects:self.bottomButtonColor2,self.bottomButtonColor3,self.bottomButtonColor4,self.bottomButtonColor5,self.bottomButtonColor6,self.bottomButtonColor7, nil];
    [self selectBottomBtn:_selectColor];


    
    self.bottomViewHeight.constant = 80;
    self.bottonButtonView.hidden = YES;
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self autoArrangeWithConstranints:@[self.button1X,self.button2X,self.button3X,self.button4X,self.button5X,self.button6X,self.button7X] with:self.buttonWidth.constant];
}
//醍醐灌顶 约束适配  代码适配
//宽度固定，间距不定
- (void)autoArrangeWithConstranints:(NSArray *)constraintArray with:(CGFloat )width
{
    CGFloat step = (SCREEN_WIDTH - width * constraintArray.count)/ (constraintArray.count + 1);
    for (int i = 0; i<constraintArray.count; i++) {
        NSLayoutConstraint *constraint = constraintArray[i];
        constraint.constant = step + (width + step) * i;
    }
}

#pragma mark--CWRecordViewDelegate
-(void)playSendVoiceFile2:(NSString *)filePath
{
    NSLog(@"filePath4-mao==%@",filePath);
    self.view.backgroundColor = [UIColor whiteColor];
    self.voiceView.hidden = YES;
    //aio_voice_operate_listen_nor  忽略
    UIImage *image = [UIImage imageNamed:@"aio_voice_operate_listen_press"];
    
    //    [self showCurrentImageInImgeview:image];
    [self handleInsertImageFromVoice:image voicePath:filePath];
}

-(void)cancleSendVoiceFile2:(NSString *)filePath
{
    NSLog(@"filePath4-hong==%@",filePath);
    self.view.backgroundColor = [UIColor whiteColor];
    self.voiceView.hidden = YES;
    
    //播放录音
    //    [[CWAudioPlayer shareInstance] playAudioWith:[CWRecordModel shareInstance].path];
}
- (IBAction)colorButtonClickAnimation:(id)sender {
    UIButton *colorBtn = (UIButton *)sender;
    colorBtn.selected = !colorBtn.selected;
    if (colorBtn.selected) {
        [UIView animateWithDuration:1 animations:^{
            //
            self.bottomViewHeight.constant = 140;
            self.bottonButtonView.hidden = NO;
            self.traingleImageV.image = [UIImage imageNamed:@"triangle16"];
        }];
    }else{
        
        self.bottomViewHeight.constant = 80;
        self.bottonButtonView.hidden = YES;
        self.traingleImageV.image = [UIImage imageNamed:@"triangle17"];
        
    }
}

- (IBAction)viewButtonTopClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    MYNSLog(@"btn.tag=%ld",(long)btn.tag);
    switch (btn.tag) {
        case 10:
        {
            //年-月-日-时-分
            WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
                
                NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
                _selectTime = dateString;
                NSLog(@"选择的日期：%@",dateString);
                NSString *extraStr = [NSString stringWithFormat:@"   %@   ",dateString];
                [btn setTitle:extraStr forState:UIControlStateNormal];
            }];
            datepicker.dateLabelColor = RGBA(51, 150, 251, 1);//年-月-日-时-分 颜色
            datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
            datepicker.doneButtonColor = RGBA(51, 150, 251, 1);//确定按钮的颜色
            [datepicker show];
            
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)viewButtonBottomClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (UIButton *btn0 in _bottomBtnArray) {
        if (btn0.tag ==btn.tag) {
            [btn0 setTitle:@"√" forState:UIControlStateNormal];
            [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [btn0 setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    _selectColor = btn.tag;
}
- (void)selectBottomBtn:(NSInteger )btnTag
{
    for (UIButton *btn0 in _bottomBtnArray) {
        if (btn0.tag ==btnTag) {
            [btn0 setTitle:@"√" forState:UIControlStateNormal];
            [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [btn0 setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    _selectColor = btnTag;
}
//插入图片
- (IBAction)viewButtonCamereClick:(id)sender {
    //    AvatarObject *avatarobj = [AvatarObject shareImagePicker];
    //    avatarobj.pickDelegate = self;
    //    [avatarobj steupWithView:self.view];
    [self handleSelectPics];
    
    
}
- (IBAction)viewButtonMicroPhoneClick:(id)sender {
//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.voiceView.hidden = NO;
}
-(CWVoiceView *)voiceView
{
    if (!_voiceView) {
        CWVoiceView *view = [[CWVoiceView alloc] initWithFrame:CGRectMake(0, self.view.cw_height - 252,self.view.cw_width, 252)];
        view.delegate = self;
        [self.view addSubview:view];
        _voiceView = view;
    }
    return _voiceView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//---------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 设置UIScrollViewContentInsetAdjustmentAutomatic解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题,在选中图片或退出相册时：再重新设置为UIScrollViewContentInsetAdjustmentNever
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"编辑事件";
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(onUpload)];
    
    [self setTableViewUI];
    
    // Datas 标题
    _titleModel = [MMRichTitleModel new];//标题model
    _titleModel.textContent = self.mode.title;
    //内容
    NSMutableArray *muarray = [MMRichContentUtil modeArrayFromBase64String:self.mode.content];
    _datas = [NSMutableArray arrayWithArray:muarray];
        
    _extraDatas = [NSMutableArray array];
    _selectColor = [self.mode.color integerValue];

    // AccessoryView
    //废弃1
    [self contentInputAccessoryView];//给iamgeview添加点击事件，支持“删除”，“重新上传”
    
    [self setButtonCornerUI];//所有按钮 圆角化处理
    
    // Notification
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self addRightBarButtons];//右上角...按钮
    
    //创建本地 表 如果表已经存在，不会新建
//    [[MMManage sharedLH] creatDatabaseTableWithTableName:DIARY_TABLE forClass:[SFBMDiaryModel class]];
}

- (void)addRightBarButtons
{
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn1 setImage:[UIImage imageNamed:@"invalidName32"] forState:UIControlStateNormal];
    [rightBtn1 setTitle:@"保存" forState:UIControlStateNormal];
    //    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightBtn1.frame=CGRectMake(0, 0, 44, 30);
    rightBtn1.tag = 12;
    [rightBtn1 addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItem = rightItem1;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    rect.size.height = 40.f;
    self.contentInputAccessoryView.frame = rect;
}

- (void)setTableViewUI{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // register cell
    [self.tableView registerClass:MMRichTitleCell.class forCellReuseIdentifier:NSStringFromClass(MMRichTitleCell.class)];
    [self.tableView registerClass:MMRichTextCell.class forCellReuseIdentifier:NSStringFromClass(MMRichTextCell.class)];
    [self.tableView registerClass:MMRichImageCell.class forCellReuseIdentifier:NSStringFromClass(MMRichImageCell.class)];
    [self.tableView registerClass:MMRichImageVoiceCell.class forCellReuseIdentifier:NSStringFromClass(MMRichImageVoiceCell.class)];

}

- (MMRichEditAccessoryView *)contentInputAccessoryView {
    if (!_contentInputAccessoryView) {
        _contentInputAccessoryView = [[MMRichEditAccessoryView alloc] init];
        _contentInputAccessoryView.delegate = self;
    }
    return _contentInputAccessoryView;
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    NSLog(@"===dealloc===");
//}


#pragma mark - 打开相机 private :::::::......

- (void)handleSelectPics {
    if (![self cameraPemission]) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:PICKER_PowerBrowserPhotoLibirayText preferredStyle:UIAlertControllerStyleAlert];
        [aler addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [aler addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                
                [[UIApplication sharedApplication]openURL:url];
            }
        }]];
        
        [self.navigationController presentViewController:aler animated:true completion:nil];
        
    }else{
        //跳转到
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        
        UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self takePhoto];
        }];
        
        UIAlertAction * choosePhotoAction = [UIAlertAction actionWithTitle:@"我的相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self selectPhoto];
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:takePhotoAction];
        [alertController addAction:choosePhotoAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)takePhoto {
    
    // 拍照
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请打开摄像头权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = NO;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)selectPhoto {
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic; //iOS11 设置UIScrollViewContentInsetAdjustmentAutomatic解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题,在选中图片或退出相册时：再重新设置为UIScrollViewContentInsetAdjustmentNever
    }
    // 手机相册选择
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark-****-展示照片
- (void)handleInsertImage:(UIImage*)image {
    
    if (!_activeIndexPath) {
        _activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_activeIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 处理文本节点
        // 根据光标拆分文本节点
        BOOL isPre = NO;
        BOOL isPost = NO;
        NSArray* splitedTexts = [((MMRichTextCell*)cell) splitedTextArrWithPreFlag:&isPre postFlag:&isPost];
        
        // 前面优先级更高，需要调整优先级，调整if语句的位置即可
        if (isPre) {
            // 前面添加图片，光标停留在当前位置
            [self addImageNodeAtIndexPath:_activeIndexPath image:image];
            
        } else if (isPost) {
            // 后面添加图片，光标移动到下一行
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeAtIndexPath:nextIndexPath image:image];
            [self positionToNextItemAtIndexPath:_activeIndexPath];
            
        } else {
            // 替换当前节点，添加Text/image/Text，光标移动到图片节点上
            NSInteger tmpActiveIndexRow = _activeIndexPath.row;
            NSInteger tmpActiveIndexSection = _activeIndexPath.section;
            [self deleteItemAtIndexPath:_activeIndexPath shouldPositionPrevious:NO];
            if (splitedTexts.count == 2) {
                // 第一段文字
                [self addTextNodeAtIndexPath:_activeIndexPath textContent:splitedTexts.firstObject];
                // 图片
                [self addImageNodeAtIndexPath:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 1 inSection:tmpActiveIndexSection] image:image];
                // 第二段文字
                [self addTextNodeAtIndexPath:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 2 inSection:_activeIndexPath.section] textContent:splitedTexts.lastObject];
                // 光标移动到图片位置
                [self positionAtIndex:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 1 inSection:tmpActiveIndexSection]];
            }
        }
        
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        
        BOOL isPre = NO;
        BOOL isPost = NO;
        [((MMRichImageCell*)cell) getPreFlag:&isPre postFlag:&isPost];
        if (isPre) {
            [self addImageNodeAtIndexPath:_activeIndexPath image:image];
        } else if (isPost) {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeAtIndexPath:nextIndexPath image:image];
        } else {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeAtIndexPath:nextIndexPath image:image];
        }
        
    } else {
        MMRichImageModel* imageModel = [MMRichImageModel new];
        imageModel.image = image;
        [_datas addObject:imageModel];
        [self.tableView reloadData];
    }
}

#pragma mark-voice-展示录音
- (void)handleInsertImageFromVoice:(UIImage*)image voicePath:(NSString *)path {
    
    if (!_activeIndexPath) {
        _activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:_activeIndexPath];
    
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 处理文本节点
        // 根据光标拆分文本节点
        BOOL isPre = NO;//前面添加图片
        BOOL isPost = NO;//后面添加图片
        NSArray* splitedTexts = [((MMRichTextCell*)cell) splitedTextArrWithPreFlag:&isPre postFlag:&isPost];
        
        // 前面优先级更高，需要调整优先级，调整if语句的位置即可
        if (isPre) {
            //前面添加图片，光标停留在当前位置
            [self addImageNodeFromVoiceAtIndexPath:_activeIndexPath image:image voicePath:path];
            
        } else if (isPost) {
            // 后面添加图片，光标移动到下一行
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeFromVoiceAtIndexPath:nextIndexPath image:image voicePath:path];
            
            [self positionToNextItemAtIndexPath:_activeIndexPath];
            
        } else {
            // 替换当前节点，添加Text/image/Text，光标移动到图片节点上
            NSInteger tmpActiveIndexRow = _activeIndexPath.row;
            NSInteger tmpActiveIndexSection = _activeIndexPath.section;
            [self deleteItemAtIndexPath:_activeIndexPath shouldPositionPrevious:NO];
            if (splitedTexts.count == 2) {
                // 第一段文字
                [self addTextNodeAtIndexPath:_activeIndexPath textContent:splitedTexts.firstObject];
                // 图片
                [self addImageNodeFromVoiceAtIndexPath:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 1 inSection:tmpActiveIndexSection] image:image voicePath:path];
                
                // 第二段文字
                [self addTextNodeAtIndexPath:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 2 inSection:_activeIndexPath.section] textContent:splitedTexts.lastObject];
                // 光标移动到图片位置
                [self positionAtIndex:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 1 inSection:tmpActiveIndexSection]];
            }
        }
        
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        
        BOOL isPre = NO;
        BOOL isPost = NO;
        [((MMRichImageCell*)cell) getPreFlag:&isPre postFlag:&isPost];
        if (isPre) {
            //            [self addImageNodeAtIndexPath:_activeIndexPath image:image];
            [self addImageNodeFromVoiceAtIndexPath:_activeIndexPath image:image voicePath:path];
            
        } else if (isPost) {
            
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            //            [self addImageNodeAtIndexPath:nextIndexPath image:image];
            
            [self addImageNodeFromVoiceAtIndexPath:nextIndexPath image:image voicePath:path];
            
        } else {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            //            [self addImageNodeAtIndexPath:nextIndexPath image:image];
            
            [self addImageNodeFromVoiceAtIndexPath:nextIndexPath image:image voicePath:path];
            
        }
        
    }else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
        
        BOOL isPre = NO;
        BOOL isPost = NO;
        [((MMRichImageVoiceCell*)cell) getPreFlag:&isPre postFlag:&isPost];
        if (isPre) {
            [self addImageNodeFromVoiceAtIndexPath:_activeIndexPath image:image voicePath:path];
            
        } else if (isPost) {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeFromVoiceAtIndexPath:nextIndexPath image:image voicePath:path];
            
        } else {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeFromVoiceAtIndexPath:nextIndexPath image:image voicePath:path];
            
        }
        
    }
    
}

// 处理重新加载
- (void)handleReloadItemAdIndexPath:(NSIndexPath*)indexPath {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *deleteAction;
    
    NSObject *mode = [_datas objectAtIndex:indexPath.row];
    if ([mode isKindOfClass:[MMRichImageVoiceModel class]]) {
        
        deleteAction = [UIAlertAction actionWithTitle:@"播放" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            [self clickItemToPlayVoiceAtIndexPath:indexPath];

        }];
    }else if ([mode isKindOfClass:[MMRichImageModel class]])
    {

        deleteAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            if (indexPath.row == 0 && _datas.count == 1) {
                // 第一行，并且只有一个元素：添加Text
                [self deleteItemAtIndexPath:indexPath shouldPositionPrevious:NO];
                [self addTextNodeAtIndexPath:indexPath textContent:nil];
            } else {
                [self deleteItemAtIndexPath:indexPath shouldPositionPrevious:YES];
            }
        }];
    }
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:deleteAction];
//    [alertController addAction:uploadAgainAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark-****-上传整个事件 :::::::......
- (void)rightBarBtnSelect:(UIButton *)button
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //不判断图片状态直接保存本地
    //注意图片格式化和文字格式化然后拼接规则的统一
    NSString *titleStr = _titleModel.textContent;
    NSString *htmlStr = [MMRichContentUtil htmlContentFromRichContents:self.datas];
    NSString *colorStr = [NSString stringWithFormat:@"%ld",_selectColor];

    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];//
    
    [muDic setValue:colorStr forKey:@"color"];//
    [muDic setValue:titleStr forKey:@"title"];//
    [muDic setValue:htmlStr forKey:@"content"];
    [muDic setValue:@"0" forKey:@"upload"];//是否已上传服务
    [muDic setValue:_selectTime forKey:@"time"];//时间

    [muArr addObject:muDic];
    //    MYNSLog(@"muDic==%@",muDic);
    BOOL success = NO;
    NSString *thingId = [NSString stringWithFormat:@"%@",self.mode.ID];
    if ([thingId isEqualToString:@"0"]) {
        success = [[MMManage sharedLH] insertContentList:[NSMutableArray arrayWithObjects:muDic, nil] WithTableName:DIARY_TABLE forClass:[SFBMDiaryModel class]];
        
    }else{
   success = [[MMManage sharedLH] updateContentMessageWithID:self.mode.ID withContentDic:muDic withTableName:DIARY_TABLE forClass:[SFBMDiaryModel class]];
        
    }
 
//    success = [[MMManage sharedLH] insertContentList:muArr WithTableName:DIARY_TABLE forClass:[SFBMDiaryModel class]];
    
    //先保存数据，保存成功以后再返回上一层  [self pop2Previous:YES];
    if(success==YES){
        [self showTheMostCommonAlertmessage:@"保存成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self showTheMostCommonAlertmessage:@"失败了，请重试"];
    }
}

#pragma mark - image添加图片
- (void)addImageNodeAtIndexPath:(NSIndexPath*)indexPath image:(UIImage*)image {
    //等比例绘制图片（1242尺寸多数图片没做处理直接使用了）
    UIImage* scaledImage = [MMRichContentUtil scaleImage:image];
    //单张图片的具体本地路径
    NSString* scaledImageStorePath = [MMRichContentUtil saveImageToLocal:scaledImage];
    MMRichImageModel* imageModel = [MMRichImageModel new];
    imageModel.image = scaledImage;
    imageModel.localImagePath = scaledImageStorePath;
    
    // 添加到上传队列中
    [[MMFileUploadUtil sharedInstance] addUploadItem:imageModel];
    
    [self.tableView beginUpdates];
    [_datas insertObject:imageModel atIndex:indexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
#pragma mark-voice 添加录音
- (void)addImageNodeFromVoiceAtIndexPath:(NSIndexPath*)indexPath image:(UIImage*)image voicePath:(NSString *)path {
    //等比例绘制图片（以宽度 1242尺寸为标准压缩 图片）
    UIImage* scaledImage = [MMRichContentUtil scaleImage:image];
    //单张图片的具体本地路径
    NSString* scaledImageStorePath = [MMRichContentUtil saveImageToLocal:scaledImage];
    //更换model 在更换cell 就搞定了
    MMRichImageVoiceModel* imageModel = [MMRichImageVoiceModel new];
    imageModel.image = scaledImage;
    imageModel.localImagePath = scaledImageStorePath;
    imageModel.localImageVoicePath = path;
    // 添加到上传队列中 暂时不上传
    //    [[MMFileUploadUtil sharedInstance] addUploadItem:imageModel];
    //tableview更新单个cell的办法
    [self.tableView beginUpdates];
    [_datas insertObject:imageModel atIndex:indexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)addTextNodeAtIndexPath:(NSIndexPath*)indexPath textContent:(NSString*)textContent {
    MMRichTextModel* textModel = [MMRichTextModel new];
    textModel.textContent = textContent;
    
    [self.tableView beginUpdates];
    [_datas insertObject:textModel atIndex:indexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    // 定位到新增的元素
    [self positionAtIndex:indexPath];
}

- (void)deleteItemAtIndexPathes:(NSArray<NSIndexPath*>*)actionIndexPathes shouldPositionPrevious:(BOOL)shouldPositionPrevious {
    if (actionIndexPathes.count > 0) {
        //  定位动到上一行
        if (shouldPositionPrevious) {
            [self positionToPreItemAtIndexPath:actionIndexPathes.firstObject];
        }
        
        // 处理删除
        for (NSInteger i = actionIndexPathes.count - 1; i >= 0; i--) {
            NSIndexPath* actionIndexPath = actionIndexPathes[i];
            [_datas removeObjectAtIndex:actionIndexPath.row];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:actionIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

//删除一行
- (void)deleteItemAtIndexPath:(NSIndexPath*)actionIndexPath shouldPositionPrevious:(BOOL)shouldPositionPrevious {
    // 是否 定位移动到上一行
    
    if (shouldPositionPrevious) {
        [self positionToPreItemAtIndexPath:actionIndexPath];
    }
    // 处理删除
    [_datas removeObjectAtIndex:actionIndexPath.row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionIndexPath.row inSection:actionIndexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
}

//播放功能
- (void)clickItemToPlayVoiceAtIndexPath:(NSIndexPath*)actionIndexPath
{
    //播放功能
    NSObject *mode = [_datas objectAtIndex:actionIndexPath.row];
    if ([mode isKindOfClass:[MMRichImageVoiceModel class]]) {
        MMRichImageVoiceModel *voiceModel = (MMRichImageVoiceModel*)mode;
        NSString *voicePath = voiceModel.localImageVoicePath;
        [[CWAudioPlayer shareInstance] playAudioWith:voicePath];
    }
}
/**
 定位到指定的元素
 */
- (void)positionAtIndex:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        [((MMRichTextCell*)cell) beginEditing];
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        [((MMRichImageCell*)cell) beginEditing];
    }
}

// 定位移动到上一行
- (void)positionToPreItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
    [self positionAtIndex:preIndexPath];
}

// 定位动到上一行
- (void)positionToNextItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
    [self positionAtIndex:preIndexPath];
}



#pragma mark - ......::::::: UIImagePickerController :::::::......

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^ {
        [self handleInsertImage:image];
    }];
}


#pragma mark - ......::::::: RichTextEditDelegate :::::::......
//开始
- (void)mm_preInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent {
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        NSIndexPath* preIndexPath = nil;
        if (actionIndexPath.row > 0) {
            preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
            
            id preData = _datas[preIndexPath.row];
            if ([preData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-前面：上面是text，光标移动到上面一行，并且在最后添加一个换行，定位光标在最后将
                [self.tableView scrollToRowAtIndexPath:preIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:preIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) beginEditing];
                }
            } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-前面：上面是图片或者空，在上面添加一个Text节点，光标移动到上面一行，
                [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
            }
            
        } else {
            // 上面为空，添加一个新的单元格
            [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
        }
    } else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
        NSIndexPath* preIndexPath = nil;
        if (actionIndexPath.row > 0) {
            preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
            
            id preData = _datas[preIndexPath.row];
            if ([preData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-前面：上面是text，光标移动到上面一行，并且在最后添加一个换行，定位光标在最后将
                [self.tableView scrollToRowAtIndexPath:preIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:preIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) beginEditing];
                }else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
                    [((MMRichImageVoiceCell*)cell) beginEditing];
                }
            } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-前面：上面是图片或者空，在上面添加一个Text节点，光标移动到上面一行，
                [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
            } else if ([preData isKindOfClass:[MMRichImageVoiceModel class]]) {
                // Image节点-前面：上面是图片或者空，在上面添加一个Text节点，光标移动到上面一行，
                [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
            }
            
        } else {
            // 上面为空，添加一个新的单元格
            [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
        }
    }
}

- (void)mm_postInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString *)textContent {
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        NSIndexPath* nextIndexPath = nil;
        nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
        if (actionIndexPath.row < _datas.count-1) {
            
            id nextData = _datas[nextIndexPath.row];
            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-后面：下面是text，光标移动到下面一行，并且在最前面添加一个换行，定位光标在最前面
                [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 添加文字到下一行
                MMRichTextModel* textModel = ((MMRichTextModel*)nextData);
                textModel.textContent = [NSString stringWithFormat:@"%@%@", textContent, textModel.textContent];
                textModel.selectedRange = NSMakeRange(textContent.length, 0);
                textModel.shouldUpdateSelectedRange = YES;
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) beginEditing];
                }else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
                    [((MMRichImageVoiceCell*)cell) beginEditing];
                }
            } else if ([nextData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
                [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
            } else if ([nextData isKindOfClass:[MMRichImageVoiceModel class]]) {
                // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
                [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
            }
            
        } else {
            // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
            [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
        }
    } else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
        NSIndexPath* nextIndexPath = nil;
        nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
        if (actionIndexPath.row < _datas.count-1) {
            
            id nextData = _datas[nextIndexPath.row];
            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-后面：下面是text，光标移动到下面一行，并且在最前面添加一个换行，定位光标在最前面
                [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 添加文字到下一行
                MMRichTextModel* textModel = ((MMRichTextModel*)nextData);
                textModel.textContent = [NSString stringWithFormat:@"%@%@", textContent, textModel.textContent];
                textModel.selectedRange = NSMakeRange(textContent.length, 0);
                textModel.shouldUpdateSelectedRange = YES;
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) beginEditing];
                }else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
                    [((MMRichImageVoiceCell*)cell) beginEditing];
                }
            } else if ([nextData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
                [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
            }else if ([nextData isKindOfClass:[MMRichImageVoiceModel class]]) {
                // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
                [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
            }
            
        } else {
            // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
            [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
        }
    }
    
}

- (void)mm_preDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 处理Text节点
        if (actionIndexPath.row < _datas.count) {
            
            if (actionIndexPath.row <= 0) {
                MMRichTextModel* textModel = (MMRichTextModel*)_datas[actionIndexPath.row];
                if (_datas.count == 1) {
                    // Text节点-当前的Text为空-前面-没有其他元素-：不处理
                    // Text节点-当前的Text不为空-前面-没有其他元素-：不处理
                } else {
                    if (textModel.textContent.length == 0) {
                        // Text节点-当前的Text为空-前面-有其他元素-：删除这一行，定位光标到下面图片的最后
                        [self positionToNextItemAtIndexPath:actionIndexPath];
                        [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                    } else {
                        // Text节点-当前的Text不为空-前面-有其他元素-：不处理
                    }
                }
            } else {
                MMRichTextModel* textModel = (MMRichTextModel*)_datas[actionIndexPath.row];
                if (textModel.textContent.length == 0) {
                    // Text节点-当前的Text为空-前面-有其他元素-：删除这一行，定位光标到上面图片的最后
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                    
                } else {
                    // 当前节点不为空
                    // Text节点-当前的Text不为空-前面-：上面是图片，定位光标到上面图片的最后
                    // Text节点不存在相邻的情况，所以直接定位上上一个元素即可
                    [self positionToPreItemAtIndexPath:actionIndexPath];
                }
            }
        }
        
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            if (actionIndexPath.row <= 0) {
                // Image节点-前面-上面为空：不处理
                // 第一行不处理
            } else {
                NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                if (preIndexPath.row < _datas.count) {
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]])
                    {
                        if(((MMRichTextModel*)preData).textContent.length == 0)
                        {
                            // mage节点-前面-上面为Text（为空）：删除上面Text节点
                            [self deleteItemAtIndexPath:preIndexPath shouldPositionPrevious:NO];
                        } else {
                            [self positionToPreItemAtIndexPath:actionIndexPath];
                        }
                    } else if ([preData isKindOfClass:[MMRichImageModel class]])
                    {
                        [self positionToPreItemAtIndexPath:actionIndexPath];
                    }else if ([preData isKindOfClass:[MMRichImageVoiceModel class]])
                    {
                        [self positionToPreItemAtIndexPath:actionIndexPath];
                    }
                    
                }
            }
        }
    }else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            if (actionIndexPath.row <= 0) {
                // Image节点-前面-上面为空：不处理
                // 第一行不处理
            } else {
                NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                if (preIndexPath.row < _datas.count) {
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]])
                    {
                        if(((MMRichTextModel*)preData).textContent.length == 0)
                        {
                            // mage节点-前面-上面为Text（为空）：删除上面Text节点
                            [self deleteItemAtIndexPath:preIndexPath shouldPositionPrevious:NO];
                        } else {
                            [self positionToPreItemAtIndexPath:actionIndexPath];
                        }
                    } else if ([preData isKindOfClass:[MMRichImageModel class]])
                    {
                        [self positionToPreItemAtIndexPath:actionIndexPath];
                    }else if ([preData isKindOfClass:[MMRichImageVoiceModel class]])
                    {
                        [self positionToPreItemAtIndexPath:actionIndexPath];
                    }
                    
                }
            }
        }
    }
    
}

- (void)mm_PostDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
        // Text节点-当前的Text不为空-后面-：正常删除
        // Text节点-当前的Text为空-后面-：正常删除，和第三种情况：为空的情况处理一样
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            // 处理第一个节点
            if (actionIndexPath.row <= 0) {
                if (_datas.count > 1) {
                    // Image节点-后面-上面为空-列表多于一个元素：删除当前节点，光标放在后面元素之前
                    [self positionToNextItemAtIndexPath:actionIndexPath];
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                } else {
                    // Image节点-后面-上面为空-列表只有一个元素：添加一个Text节点，删除当前Image节点，光标放在添加的Text节点上
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                    [self addTextNodeAtIndexPath:actionIndexPath textContent:nil];
                }
            } else {
                // 处理非第一个节点
                NSIndexPath* preIndexPath = nil;
                if (actionIndexPath.row > 0) {
                    preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]]) {
                        NSIndexPath* nextIndexPath = nil;
                        if (actionIndexPath.row < _datas.count - 1) {
                            nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
                        }
                        if (nextIndexPath) {
                            id nextData = _datas[nextIndexPath.row];
                            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                                // Image节点-后面-上面为Text-下面为Text：删除Image节点，合并下面的Text到上面，删除下面Text节点，定位到上面元素的后面
                                ((MMRichTextModel*)preData).textContent = [NSString stringWithFormat:@"%@\n%@", ((MMRichTextModel*)preData).textContent, ((MMRichTextModel*)nextData).textContent];
                                [self deleteItemAtIndexPathes:@[actionIndexPath, nextIndexPath] shouldPositionPrevious:YES];
                            } else {
                                // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                                [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                            }
                        } else {
                            // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                            [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                        }
                        
                    } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                        // Image节点-后面-上面为图片：删除Image节点，定位到上面元素的后面
                        [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                    }
                }
            }
        }
    } else if ([cell isKindOfClass:[MMRichImageVoiceCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            // 处理第一个节点
            if (actionIndexPath.row <= 0) {
                if (_datas.count > 1) {
                    // Image节点-后面-上面为空-列表多于一个元素：删除当前节点，光标放在后面元素之前
                    [self positionToNextItemAtIndexPath:actionIndexPath];
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                } else {
                    // Image节点-后面-上面为空-列表只有一个元素：添加一个Text节点，删除当前Image节点，光标放在添加的Text节点上
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                    [self addTextNodeAtIndexPath:actionIndexPath textContent:nil];
                }
            } else {
                // 处理非第一个节点
                NSIndexPath* preIndexPath = nil;
                if (actionIndexPath.row > 0) {
                    preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]]) {
                        NSIndexPath* nextIndexPath = nil;
                        if (actionIndexPath.row < _datas.count - 1) {
                            nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
                        }
                        if (nextIndexPath) {
                            id nextData = _datas[nextIndexPath.row];
                            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                                // Image节点-后面-上面为Text-下面为Text：删除Image节点，合并下面的Text到上面，删除下面Text节点，定位到上面元素的后面
                                ((MMRichTextModel*)preData).textContent = [NSString stringWithFormat:@"%@\n%@", ((MMRichTextModel*)preData).textContent, ((MMRichTextModel*)nextData).textContent];
                                [self deleteItemAtIndexPathes:@[actionIndexPath, nextIndexPath] shouldPositionPrevious:YES];
                            } else {
                                // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                                [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                            }
                        } else {
                            // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                            [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                        }
                        
                    } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                        // Image节点-后面-上面为图片：删除Image节点，定位到上面元素的后面
                        [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                    }
                }
            }
        }
    }
    
}

// 更新ActionIndexpath
- (void)mm_updateActiveIndexPath:(NSIndexPath*)activeIndexPath {
    _activeIndexPath = activeIndexPath;
}

// 重新加载
- (void)mm_reloadItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    [self handleReloadItemAdIndexPath:actionIndexPath];
}

- (MMRichEditAccessoryView *)mm_inputAccessoryView {
    //    return [self contentInputAccessoryView];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomAllViewBottomConstraint.constant = 260+30;
        
    }];
    self.voiceView.hidden = YES;
    return nil;
}
- (MMRichEditAccessoryView *)mm_removeAccessoryView{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomAllViewBottomConstraint.constant = 0;
        
    }];
    return nil;
}

- (NSIndexPath*)appendExtraData {
    NSIndexPath* appendIndexPath = [NSIndexPath indexPathForRow:_extraDatas.count inSection:2];
    [_extraDatas addObject:@""];
    return appendIndexPath;
}
//结束


#pragma mark - ......::::::: MMRichEditAccessoryViewDelegate :::::::......
//废弃1
- (void)mm_didKeyboardTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView {
    [self.view endEditing:YES];
}
//废弃1
- (void)mm_didImageTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView {
    [self handleSelectPics];
}


#pragma mark - ......::::::: Notification :::::::......
//根据编辑状态改变控件坐标
- (void)keyboardWillChangeFrame:(NSNotification*)noti {
    
    CGRect keyboardFrame =  [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval keyboardAnimTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat keyboardH = kScreenHeight - keyboardFrame.origin.y;
    if (keyboardH==0) {
        [self mm_removeAccessoryView];
    }
    //    [UIView animateWithDuration:keyboardAnimTime animations:^{
    //        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
    ////            make.left.top.right.equalTo(self.view);
    //            make.bottom.equalTo(self.view).offset(-keyboardH);
    //        }];
    //        [self.view layoutIfNeeded];
    //    }];
}


#pragma mark - ......::::::: UITableView Handler :::::::......

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Title
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        // Content
        return _datas.count;
    } else if(section == 2) {
        // Extra  _extraDatas为空，所以此数组不影响布局 可删除
        return _extraDatas.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else if(indexPath.section == 1) {
        id obj = _datas[indexPath.row];
        if ([obj isKindOfClass:[MMRichTextModel class]]) {
            MMRichTextModel* textModel = (MMRichTextModel*)obj;
            return textModel.textFrame.size.height;
        }
        if ([obj isKindOfClass:[MMRichImageModel class]]) {
            MMRichImageModel* imageModel = (MMRichImageModel*)obj;
        }
    } else if(indexPath.section == 2) {
        return 100;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Title
    if (indexPath.section == 0) {
        MMRichTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichTitleCell.class)];
        cell.delegate = self;
        [cell updateWithData:_titleModel indexPath:indexPath];
        return cell;
    }
    // Content
    if (indexPath.section == 1) {
        id obj = _datas[indexPath.row];
        if ([obj isKindOfClass:[MMRichTextModel class]]) {
            MMRichTextCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichTextCell.class)];
            cell.delegate = self;
            [cell updateWithData:obj indexPath:indexPath];
            return cell;
        }
        if ([obj isKindOfClass:[MMRichImageModel class]]) {
            MMRichImageCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichImageCell.class)];
            cell.delegate = self;
            [cell updateWithData:obj];
            return cell;
        }
        if ([obj isKindOfClass:[MMRichImageVoiceModel class]]) {
            MMRichImageVoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichImageVoiceCell.class)];
            cell.delegate = self;
            [cell updateWithData:obj];
            return cell;
        }
    }
    
    static NSString* cellID = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark--  判断是否有相机权限

- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    return isHavePemission;
}

@end

