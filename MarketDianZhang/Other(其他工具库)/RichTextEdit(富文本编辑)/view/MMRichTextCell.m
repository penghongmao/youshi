//
//  MMRichTextCell.m
//  RichTextEditDemo
//
//  Created by aron on 2017/7/19.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "MMRichTextCell.h"
//#import <Masonry.h>
#import "Masonry.h"
#import "MMRichTextModel.h"
#import "MMTextView.h"
#import "MMRichTextConfig.h"
#import "UtilMacro.h"


@interface MMRichTextCell () <MMTextViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) MMTextView* textView;
@property (nonatomic, strong) MMRichTextModel* textModel;
@property (nonatomic, assign) BOOL isEditing;
@end


@implementation MMRichTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedExt:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    _textView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).priority(900);
    }];
}

- (void)updateWithData:(id)data indexPath:(NSIndexPath*)indexPath {
    if ([data isKindOfClass:[MMRichTextModel class]]) {
        MMRichTextModel* textModel = (MMRichTextModel*)data;
        _textModel = textModel;
        
        // 重新设置TextView的约束
//        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.bottom.equalTo(self).priority(900);
//            make.height.equalTo(@(textModel.textFrame.size.height));
//        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        // Content
        self.textView.text = nil;
        self.textView.text = textModel.textContent;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self handleTextViewChanged];
        });
        // Placeholder
        if (indexPath.row == 0) {
            self.textView.showPlaceHolder = YES;
        } else {
            self.textView.showPlaceHolder = NO;
        }
    }
}

- (void)beginEditing {
    [_textView becomeFirstResponder];
    
    if (![_textView.text isEqualToString:_textModel.textContent]) {
        _textView.text = _textModel.textContent;
        
        // 手动调用回调方法修改
        [self textViewDidChange:_textView];
    }
    
    if ([self curIndexPath].row == 0) {
        self.textView.showPlaceHolder = YES;
    } else {
        self.textView.showPlaceHolder = NO;
    }
}

- (NSRange)selectRange {
    return _textView.selectedRange;
}

- (NSArray<NSString*>*)splitedTextArrWithPreFlag:(BOOL*)isPre postFlag:(BOOL*)isPost {
    NSMutableArray* splitedTextArr = [NSMutableArray new];
    
    NSRange selRange = self.selectRange;
    
    // 设置标记值
    if (isPre) {
//        NSLog(@"isPre==%@",isPre);
        if (selRange.location == 0) {
            *isPre = YES;
//            isPre = YES;

        } else {
            *isPre = NO;
//            isPre = NO;

        }
    }
    
    if (isPost) {
//        NSLog(@"isPre==%@",isPre);

        if (selRange.location+selRange.length == _textView.text.length) {
            *isPost = YES;
//            isPost = YES;

        } else {
            *isPost = NO;
//            isPost = NO;

        }
    }
    
    // 0 - 光标停留在一行字的中间任何位置时候 先把光标前面的文字加入数组
    if (selRange.location > 0) {
        [splitedTextArr addObject:[_textView.text substringToIndex:selRange.location]];
    }
    // 1 - 再把光标后面的文字加入数组

    if (selRange.location+selRange.length < _textView.text.length) {
        [splitedTextArr addObject:[_textView.text substringWithRange:NSMakeRange(selRange.location+selRange.length, _textView.text.length - (selRange.location+selRange.length))]];
    }
    
    return splitedTextArr;
}


#pragma mark - ......::::::: lazy load :::::::......

- (MMTextView *)textView {
    if (!_textView) {
        _textView = [MMTextView new];
        _textView.font = MMEditConfig.defaultEditContentFont;
        _textView.textContainerInset = UIEdgeInsetsMake(MMEditConfig.editAreaTopPadding, MMEditConfig.editAreaLeftPadding, MMEditConfig.editAreaBottomPadding, MMEditConfig.editAreaRightPadding);
        _textView.scrollEnabled = NO;
        _textView.placeHolder = _(@"请输入正文");
        _textView.delegate = self;
        _textView.mm_delegate = self;
    }
    return _textView;
}


#pragma mark - ......::::::: private :::::::......

- (void)handleTextViewChanged {
    CGRect frame = self.textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [self.textView sizeThatFits:constraintSize];
    
    // 更新模型数据
    _textModel.textFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    _textModel.textContent = self.textView.text;
    if (_textModel.shouldUpdateSelectedRange) {
        self.textView.selectedRange = _textModel.selectedRange;//？？？
        _textModel.shouldUpdateSelectedRange = NO;
    }
    _textModel.isEditing = YES;
    
    if (ABS(_textView.frame.size.height - size.height) > 5) {
        //???
        MYNSLog(@"会进入这个判断吗？不知道")
        UITableView* tableView = [self containerTableView];
        [tableView beginUpdates];
        
        // 重新设置TextView的约束
//        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.right.equalTo(self);
//            make.bottom.equalTo(self).priority(900);
//            make.height.equalTo(@(_textModel.textFrame.size.height));
//        }];
        
        //        NSIndexPath* appendIndexPath = [self.delegate appendExtraData];
        //        [tableView insertRowsAtIndexPaths:@[appendIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [tableView endUpdates];
    }
}

#pragma mark - ......::::::: UITextViewDelegate :::::::......
//ios系统键盘输入错误显示数字，替换
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if (textView.text.length == 1)
    {
        NSString *headNum = [textView.text substringWithRange:NSMakeRange(0, 1)];
        NSArray *nine = @[@"➋",@"➌",@"➍",@"➎",@"➏",@"➐",@"➑",@"➒"];
        if ([nine containsObject:headNum]) {
            textView.text = @"";
                        return NO;
        }
                return YES;
    }
        return YES;

}
- (void)textViewDidChange:(UITextView *)textView {
    //

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.inputAccessoryView = [self.delegate mm_inputAccessoryView];
    if ([self.delegate respondsToSelector:@selector(mm_updateActiveIndexPath:)]) {
        [self.delegate mm_updateActiveIndexPath:[self curIndexPath]];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    textView.inputAccessoryView = nil;
//    textView.inputAccessoryView = [self.delegate mm_removeAccessoryView];

    return YES;
}
//点击delete键
- (void)textViewDeleteBackward:(MMTextView *)textView {
    // 处理删除
    NSRange selRange = textView.selectedRange;
    if (selRange.location == 0) {
        if ([self.delegate respondsToSelector:@selector(mm_preDeleteItemAtIndexPath:)]) {
            [self.delegate mm_preDeleteItemAtIndexPath:[self curIndexPath]];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(mm_PostDeleteItemAtIndexPath:)]) {
            [self.delegate mm_PostDeleteItemAtIndexPath:[self curIndexPath]];
        }
    }
}


#pragma mark - ......::::::: Notification :::::::......

- (void)textChangedExt:(NSNotification *)notification {
    UITextView* textView = notification.object;
    [self handleTextViewChanged];
}

@end
