//
//  FLRuntime.m
//  FLPictureBrowser
//
//  Created by __阿彤木_ on 16/8/22.
//  Copyright © 2016年 http://www.jianshu.com/users/6216a4946b5a/latest_articles. All rights reserved.
//

#import "FLRuntime.h"

@implementation FLRuntime



+ (void)getAttributeWithClassName:(id)className {
    
    unsigned int count =0;
    Ivar *ivars =  class_copyIvarList((Class)className, &count);
    for (int i=0; i<count; i++) {
        for (int i=0; i<count; i++) {
            Ivar ivar = *(ivars +i);
            NSLog(@"%s",ivar_getName(ivar));
        }
    }
}

@end
