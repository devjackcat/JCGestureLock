//
//  ViewController.m
//  JCGestureLock
//
//  Created by abc on 2017/5/2.
//  Copyright © 2017年 JackCat. All rights reserved.
//

#import "ViewController.h"
#import "JCGestureLock.h"

static UIImage* imageFromColor(UIColor *color,CGSize imageSize){
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

@interface ViewController ()<JCGestureLockDelegate>

/**
 *  <#注释#>
 **/
@property (nonatomic,strong) JCGestureLock *gestureLock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gestureLock = [JCGestureLock gestureLock:^(JCGestureLockConfig *config) {
        config.padding = 50;
        config.itemWidth = 44;
        config.itemHeight = 44;
        config.normalImage = imageFromColor([UIColor redColor],CGSizeMake(44, 44));
        config.selectedImage = imageFromColor([UIColor greenColor],CGSizeMake(44, 44));
    }];
    self.gestureLock.delegate = self;
    self.gestureLock.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.gestureLock];
    self.gestureLock.bounds = CGRectMake(0, 0, 320, 320);
    self.gestureLock.center = self.view.center;
    
}


#pragma mark - JCGestureLockDelegate

- (void)jcGestureLock:(JCGestureLock *)gestureLock code:(NSString *)code{
    NSLog(@"--code = %@",code);
}


@end
