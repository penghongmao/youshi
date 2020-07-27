//
//  GLaunchManager.h
//  MarketDianZhang
//
//  Created by HP M on 2019/5/29.
//  Copyright © 2019 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GLaunchManager : NSObject

+ (GLaunchManager *)sharedInstance;
- (void)launchInWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
