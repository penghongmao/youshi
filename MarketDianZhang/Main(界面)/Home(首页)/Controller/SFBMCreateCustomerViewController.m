//
//  SFBMCreateCustomerViewController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/21.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMCreateCustomerViewController.h"
#import "SFBMCreateCustomerCell.h"
#import "NSString+PFzhengZeBiaoDa.h"
//上传头像
#import "AvatarObject.h"
//本地数据库管理
#import "MMManage.h"
#import "MyContactListModel.h"

@interface SFBMCreateCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ImagePickerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_dataArray;
    NSArray *_titleArray;
    NSData *_headerImageData;
    NSString *_headerImageStr;
    NSMutableArray *_myFieldTextArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *headerImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF0;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF1;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF2;

@property (nonatomic,strong) UIButton *leftBarBtn;
@end

@implementation SFBMCreateCustomerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    self.title = @"新建客户信息";
    [self baseCornerRaduisView:self.headerImageBtn radius:22.5 color:nil wide:0];
    _tableView.backgroundColor = RGBA(248, 248, 248, 1);
    //初始化
    _dataArray = [NSMutableArray array];
    _dataArray =(NSMutableArray *) @[@"固定电话",@"手机",@"传真",@"电子邮箱",@"微信",@"微博",@"QQ",@"地址",@"备注"];

    [self addRightBarButtons];
    [self limitTheLengthOftextField];
    

    //创建本地 表 如果表已经存在，不会新建
    [[MMManage sharedLH] creatDatabaseTableWithTableName:CONTACT_TABLE forClass:[MyContactListModel class]];
    //查询整张表
    NSMutableArray *muArr = [[MMManage sharedLH] selectFromTableWithTableName:CONTACT_TABLE];
    NSLog(@"muArr==%@",muArr);
    [self configMyUI];
    
}
- (void)configMyUI
{
    if(self.model)
    {
        
        [self.headerImageBtn setImage:[NSString Base64StrToUIImage:_model.headpath] forState:UIControlStateNormal];

        _headerImageStr = _model.headpath;
        self.nameTextF0.text = _model.name;
        self.nameTextF1.text = _model.company;
        self.nameTextF2.text = _model.position;
        _myFieldTextArr = [@[_model.telephone,_model.phone,_model.fax,_model.email,_model.wechat,_model.microblog,_model.qq,_model.address,_model.remark] mutableCopy];
        //保存按钮可用
        _leftBarBtn.userInteractionEnabled = YES;
        [_leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
}
- (void)addRightBarButtons
{
    _leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _leftBarBtn.userInteractionEnabled = NO;
    [_leftBarBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_leftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _leftBarBtn.frame=CGRectMake(0, 0, 64, 30);
    
    _leftBarBtn.tag = 11;
    [_leftBarBtn addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    _leftBarBtn.layer.cornerRadius = 4;
    _leftBarBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _leftBarBtn.layer.borderWidth = 0.5;
    UIBarButtonItem *rightItem0 = [[UIBarButtonItem alloc] initWithCustomView:_leftBarBtn];
    self.navigationItem.rightBarButtonItem = rightItem0;
}

#pragma mark - tableViewDataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textTitle = _dataArray[indexPath.row];
    SFBMCreateCustomerCell *cell;
    cell = (SFBMCreateCustomerCell *)[tableView dequeueReusableCellWithIdentifier:@"SFBMCreateCustomerCell"];
    cell.cellTextField.delegate = self;
    cell.cellTitleL.text = textTitle;
    cell.cellTextField.tag = indexPath.row;
    [cell.cellTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    if(self.model)
    {
        cell.cellTextField.text = _myFieldTextArr[indexPath.row];
        
    }
    switch (indexPath.row) {
        case 0:
            cell.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case 1:
            cell.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case 4:
            cell.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case 6:
            cell.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    //    headerView.backgroundColor = [UIColor redColor];
//
//    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [footerButton setTitle:@"全部客户" forState:UIControlStateNormal];
//    [footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    footerButton.frame = CGRectMake(10, 0, SCREEN_WIDTH-10, 40);
//    footerButton.tag = section+100;
//    [footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:footerButton];
//
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(footerView.frame)-0.5, SCREEN_WIDTH, 0.5)];
//    imageV.backgroundColor = [UIColor lightGrayColor];
//    [footerView addSubview:imageV];
//    if (section==0||section==3) {
//        return footerView;
//    }else{
//        return nil;
//    }
    return nil;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    //    headerView.backgroundColor = [UIColor redColor];
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 40)];
//    NSString *title = _titleArray[section];
//    headerLabel.text = title;
//    [headerView addSubview:headerLabel];
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
#pragma mark--UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //调用接口 搜索功能
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    MYNSLog(@"currentTextF.tag==%ld",textField.tag);
//    [_myFieldTextArr ]
    [_myFieldTextArr replaceObjectAtIndex:textField.tag withObject:textField.text];
    //此处弹框处理
    if (textField.tag==1) {
        //输入字符是否合法
        BOOL isMobile = [NSString isMobileNumber:textField.text];
        if (isMobile==YES) {
            return YES;
        }else{
            MYNSLog(@"请注意，这张是假币");
            [self showTheMostCommonAlertmessage:@"请输入正确的手机号码"];
//            return NO;
        }
    }
    return YES;
}
#pragma mark-如何更好地限制一个UITextField的输入长度
- (void)limitTheLengthOftextField
{
    
    [self.nameTextF0 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextF1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextF2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.nameTextF0.text.length > 0|self.nameTextF1.text.length > 0|self.nameTextF2.text.length > 0) {
        _leftBarBtn.userInteractionEnabled = YES;
        [_leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        _leftBarBtn.userInteractionEnabled = NO;
        [_leftBarBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPat{
}

/**
 *  布局视图
 */
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark--保存按钮
- (void)rightBarBtnSelect:(UIButton *)button
{

//    NSData *imageData = !_headerImageData?
    NSString *name0 = self.nameTextF0.text.length==0?@"":self.nameTextF0.text;
    NSString *name1 = self.nameTextF1.text.length==0?@"":self.nameTextF1.text;
    NSString *name2 = self.nameTextF2.text.length==0?@"":self.nameTextF2.text;

    
    NSString *text0 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    NSString *text1 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
    NSString *text2 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]];
    NSString *text3 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]];
    NSString *text4 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]];
    NSString *text5 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]]];
    NSString *text6 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]];
    NSString *text7 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]]];
    NSString *text8 = [self getTextFieldTextWithCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]]];
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];//

    //设置默认头像防止空数据
    if (!_headerImageStr) {
        _headerImageStr = [NSString UIImageToBase64Str:[UIImage imageNamed:@"group29"]];
    }
    
    NSLog(@"_headerImageStr==%@",_headerImageStr);
    [muDic setValue:_headerImageStr forKey:@"headpath"];//

    [muDic setValue:name0 forKey:@"name"];
    [muDic setValue:name1 forKey:@"company"];
    [muDic setValue:name2 forKey:@"position"];
    [muDic setValue:text0 forKey:@"telephone"];
    [muDic setValue:text1 forKey:@"phone"];
    [muDic setValue:text2 forKey:@"fax"];
    [muDic setValue:text3 forKey:@"email"];
    [muDic setValue:text4 forKey:@"wechat"];
    [muDic setValue:text5 forKey:@"microblog"];
    [muDic setValue:text6 forKey:@"qq"];
    [muDic setValue:text7 forKey:@"address"];
    [muDic setValue:text8 forKey:@"remark"];
    [muDic setValue:@"0" forKey:@"upload"];

    [muArr addObject:muDic];
    MYNSLog(@"muDic==%@",muDic);
    BOOL success = NO;
    if (self.update==YES){
        //此方法只能更新字符串
//        [muDic re、moveObjectForKey:@"headpath"];
        success = [[MMManage sharedLH] updateContentMessageWithID:self.model.ID withContentDic:muDic withTableName:CONTACT_TABLE forClass:[MyContactListModel class]];
        //此方法只能更新 nsdata
//        success = [[MMManage sharedLH] updateContentImageWithID:self.model.ID withImageData:_headerImageData withTableName:CONTACT_TABLE forKey:@"headpath"];
        
    }else{
        success = [[MMManage sharedLH] insertContentList:muArr WithTableName:CONTACT_TABLE forClass:[MyContactListModel class]];
        
    }
   
    
//先保存数据，保存成功以后再返回上一层  [self pop2Previous:YES];
    if(success==YES){
        [self showTheMostCommonAlertmessage:@"保存成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self showTheMostCommonAlertmessage:@"失败了，请重试"];
    }
}
//获取cell中对应的textfield的text
- (NSString *)getTextFieldTextWithCell:(SFBMCreateCustomerCell *)cell
{
    NSString *text = cell.cellTextField.text.length==0?@"":cell.cellTextField.text;
    return text;
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
//更换头像
- (IBAction)headerImageBtn:(id)sender {
    AvatarObject *avatarobj = [AvatarObject shareImagePicker];
    avatarobj.pickDelegate = self;
    [avatarobj steupWithView:self.view];
}

#pragma mark ImagePickerDelegate
-(void)presentImagePickerView:(UIImagePickerController *)pickerView
{
    [self presentViewController:pickerView animated:YES completion:nil];
}

-(void)endPickerImageWithImage:(UIImage *)image
{
    [self showCurrentImageInImgeview:image];
//    _headerImageData = UIImageJPEGRepresentation(image, 1);
//    NSData *imagedata = UIImageJPEGRepresentation(image, 1);
//    _headerImageStr = [[NSString alloc] initWithData:imagedata encoding:NSUTF8StringEncoding];
//    NSString *imageStr = [[NSString alloc] initWithData:imagedata encoding:NSUTF8StringEncoding];
//
//    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
//    _headerImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _headerImageStr = [NSString UIImageToBase64Str:image];
    NSLog(@"_headerImageStr--0--%@",_headerImageStr);

}

-(void)showCurrentImageInImgeview:(UIImage *)image
{
    [self.headerImageBtn setImage:image forState:UIControlStateNormal];

    //上传照片  TODO
#warning TODO
//    NSString *materialName = @"personId";//需要修改
//    [self sendPictureWithImage:image materialName:materialName];
    
}
#pragma mark - AF发送图片
- (void)sendPictureWithImage:(UIImage *)image materialName:(NSString *)mtName
{
    NSString *user_id = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
    NSString *token = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_TOKEN]];
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,UPLOAD_PERSONAL_WU];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?user_id=%@&token=%@&materialName=%@",BASE_URL,@"地址2",user_id,token,mtName];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    NSString *user_id = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
    //    NSString *token = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_TOKEN]];
    //后台不支持params
    //    params[@"userId"] = user_id;
    //    params[@"token"] = token;
    //    params[@"materialName"] = mtName;
    
    NSData *data = UIImagePNGRepresentation(image);
    //    NSString *name = @"pictrue";
    NSString *name = @"file";
    NSString *fileName = @"image.png";
    NSString *mimeType = @"image/png";
    
    __weak typeof(self) __weakSelf = self;
    [MyAfnetwork uploadWithURL:urlStr withHUD:YES message:nil params:params fileData:data name:name fileName:fileName mimeType:mimeType progress:^(NSProgress *progress) {
        //
    } success:^(NSDictionary *myDic) {
        MYNSLog(@"myDic===%@",myDic);
        int errCode = [[myDic objectForKey:@"errCode"] intValue];
        if (errCode==0) {
            [__weakSelf showTheMostCommonAlertmessage:@"上传成功"];
        }else{
            [__weakSelf showTheMostCommonAlertmessage:@"上传失败"];
            
        }
        
        //
    } fail:^(NSError *error) {
        //
        [__weakSelf showTheMostCommonAlertmessage:@"上传失败"];
        [self.headerImageBtn setImage:[UIImage imageNamed:@"group29"] forState:UIControlStateNormal];
        
    }];
}


@end

