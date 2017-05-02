//
//  JCGestureLock.m
//  JCGestureLock
//
//  Created by abc on 2017/5/2.
//  Copyright © 2017年 JackCat. All rights reserved.
//

#import "JCGestureLock.h"

#define selfWidht self.bounds.size.width
#define selfHeight self.bounds.size.height

@interface JCGestureButton : UIButton
/**
 *  每个按钮对应的Key
 **/
@property (nonatomic,copy) NSString *key;
@end
@implementation JCGestureButton
@end



@implementation JCGestureLockConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemWidth = 44;
        _itemHeight = 44;
        _padding = 44;
        _lineWidth = 10;
        _lineColor = [UIColor grayColor];
        
        //生成默认的key，0，2，3，4...
        NSMutableArray<NSString*> *keys = [NSMutableArray array];
        for (NSInteger idx = 0; idx < 9; idx++) {
            [keys addObject:[NSString stringWithFormat:@"%zd",idx]];
        }
        _keys = [keys copy];
    }
    return self;
}

@end




@interface JCGestureLock ()

/**
 *  所有的按钮
 **/
@property (nonatomic,strong) NSMutableArray<JCGestureButton*> *buttons;
/**
 *  所有选中的按钮
 **/
@property (nonatomic,strong) NSMutableArray<JCGestureButton*> *selectedButtons;
/**
 *  用于绘制的bezierPath
 **/
@property (nonatomic,strong) UIBezierPath *bezierPath;
/**
 *  配置信息
 **/
@property (nonatomic,strong) JCGestureLockConfig *config;
/**
 *  当前手指划过的点
 **/
@property (nonatomic,assign) CGPoint currentPoint;
/**
 *  绘制起点
 **/
@property (nonatomic,assign) CGPoint startPoint;
@end

@implementation JCGestureLock

+ (instancetype)gestureLock:(void(^)(JCGestureLockConfig*config))make{
    JCGestureLockConfig *config = [[JCGestureLockConfig alloc]init];
    make(config);
    return [[JCGestureLock alloc]initWithConfig:config];
}

- (instancetype)initWithConfig:(JCGestureLockConfig*)config{
    self = [super init];
    if (self) {
        
        _config = config;
        
        _buttons = [NSMutableArray array];
        _selectedButtons = [NSMutableArray array];
        
        for (NSInteger idx = 0; idx < 9; idx++) {
            
            JCGestureButton *button = [[JCGestureButton alloc]init];
            button.key = self.config.keys[idx];
            button.userInteractionEnabled = NO;
            [button setImage:self.config.normalImage forState:(UIControlStateNormal)];
            [button setImage:self.config.selectedImage forState:(UIControlStateSelected)];
            button.bounds = CGRectMake(0, 0, config.itemWidth, config.itemHeight);
            [self addSubview:button];
            
            [_buttons addObject:button];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat itemW = self.config.itemHeight;
    CGFloat itemH = self.config.itemHeight;
    CGFloat padding = self.config.padding;
    
    //第一个排
    {
        UIButton *button1 = self.buttons[0];
        button1.center = CGPointMake(selfWidht/2 - (itemW + padding), selfHeight/2 - (itemH + padding));
        
        UIButton *button2 = self.buttons[1];
        button2.center = CGPointMake(selfWidht/2, selfHeight/2 - (itemH + padding));
        
        UIButton *button3 = self.buttons[2];
        button3.center = CGPointMake(selfWidht/2 + (itemW + padding), selfHeight/2 - (itemH + padding));
    }
    
    //第二个排
    {
        UIButton *button1 = self.buttons[3];
        button1.center = CGPointMake(selfWidht/2 - (itemW + padding), selfHeight/2);
        
        UIButton *button2 = self.buttons[4];
        button2.center = CGPointMake(selfWidht/2, selfHeight/2);
        
        UIButton *button3 = self.buttons[5];
        button3.center = CGPointMake(selfWidht/2 + (itemW + padding), selfHeight/2);
    }
    
    //第三个排
    {
        UIButton *button1 = self.buttons[6];
        button1.center = CGPointMake(selfWidht/2 - (itemW + padding), selfHeight/2 + (itemH + padding));
        
        UIButton *button2 = self.buttons[7];
        button2.center = CGPointMake(selfWidht/2, selfHeight/2 + (itemH + padding));
        
        UIButton *button3 = self.buttons[8];
        button3.center = CGPointMake(selfWidht/2 + (itemW + padding), selfHeight/2 + (itemH + padding));
    }
    
    
}

#pragma mark - UITouch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    //如果按钮加入成功，则设置起点
    UIButton *addedButton = [self addButtonIfNeed:touchPoint];
    if(addedButton){
        _startPoint = addedButton.center;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //如果已经存在起点，则陆续加入点
    if (!CGPointEqualToPoint(_startPoint, CGPointZero)) {
        
        //每次Moved时需要将上一次的点全部移除，只保留起点
        [self.bezierPath removeAllPoints];
        [self.bezierPath moveToPoint:_startPoint];
        
        _currentPoint = [touches.anyObject locationInView:self];
        [self addButtonIfNeed:_currentPoint];
        
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self caluateGestureValue];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self caluateGestureValue];
}

#pragma mark - private Methods


/**
 滑动时添加按钮
 */
- (UIButton*)addButtonIfNeed:(CGPoint)point{
    for (JCGestureButton *button in self.buttons) {
        if (!button.selected && CGRectContainsPoint(button.frame, point)) {
            button.selected = YES;
            [self.selectedButtons addObject:button];
            return button;
        }
    }
    return nil;
}


/**
 计算手势的值
 */
- (void)caluateGestureValue{
    if (self.selectedButtons.count > 0) {
        NSMutableString *keys = [NSMutableString string];
        for (JCGestureButton *button in self.selectedButtons) {
            button.selected = NO;
            [keys appendString:button.key];
        }
        [self.selectedButtons removeAllObjects];
        if (self.delegate && [self.delegate respondsToSelector:@selector(jcGestureLock:code:)]) {
            [self.delegate jcGestureLock:self code:keys];
        }
    }
    
    //清空所有的点
    _startPoint = CGPointZero;
    [self.bezierPath removeAllPoints];
    
    [self setNeedsDisplay];
}

- (UIBezierPath *)bezierPath{
    if (!_bezierPath) {
        _bezierPath = [UIBezierPath bezierPath];
        _bezierPath.lineWidth = self.config.lineWidth;
        _bezierPath.lineCapStyle = kCGLineCapRound;
        _bezierPath.lineJoinStyle = kCGLineJoinRound;
    }
    return _bezierPath;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.selectedButtons.count > 0) {
        for (UIButton *button in self.selectedButtons) {
            [self.bezierPath addLineToPoint:button.center];
        }
        [self.bezierPath addLineToPoint:_currentPoint];
        [self.config.lineColor set];
        [self.bezierPath stroke];
    }
}

@end
