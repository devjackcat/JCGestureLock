//
//  JCGestureLock.h
//  JCGestureLock
//
//  Created by abc on 2017/5/2.
//  Copyright © 2017年 JackCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCGestureLock;

@protocol JCGestureLockDelegate <NSObject>

- (void)jcGestureLock:(JCGestureLock*)gestureLock code:(NSString*)code;

@end

@interface JCGestureLockConfig : NSObject

/**
 *  每个按钮的宽度
 **/
@property (nonatomic,assign) CGFloat itemWidth;
/**
 *  每个按钮的高度
 **/
@property (nonatomic,assign) CGFloat itemHeight;
/**
 *  按钮之间的间距
 **/
@property (nonatomic,assign) CGFloat padding;
/**
 *  手势轨迹线条宽度
 **/
@property (nonatomic,assign) CGFloat lineWidth;
/**
 *  手势轨迹线条颜色
 **/
@property (nonatomic,strong) UIColor *lineColor;
/**
 *  默认按钮图片
 **/
@property (nonatomic,strong) UIImage *normalImage;
/**
 *  选中的按钮图片
 **/
@property (nonatomic,strong) UIImage *selectedImage;
/**
 *  每个按钮的key，默认0,1,2,3....
 **/
@property (nonatomic,strong) NSArray<NSString*> *keys;

@end

@interface JCGestureLock : UIView

@property (nonatomic,weak) id<JCGestureLockDelegate> delegate;

+ (instancetype)gestureLock:(void(^)(JCGestureLockConfig*config))make;

@end
