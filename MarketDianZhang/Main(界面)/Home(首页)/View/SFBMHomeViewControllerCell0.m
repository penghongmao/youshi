//
//  SFBMHomeViewControllerCell0.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/21.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMHomeViewControllerCell0.h"

@implementation SFBMHomeViewControllerCell0

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellImageV.layer.cornerRadius = 4;
    self.cellImageV.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
