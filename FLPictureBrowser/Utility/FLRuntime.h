//
//  FLRuntime.h
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/22.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface FLRuntime : NSObject

+ (void)getAttributeWithClassName:(id)className;

@end
