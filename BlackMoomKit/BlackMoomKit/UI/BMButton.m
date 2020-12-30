//
//  BMButton.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import "BMButton.h"
#import <objc/runtime.h>

#define ScreenScale ([[UIScreen mainScreen] scale])

#pragma mark - UIEdgeInsets

// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

#pragma mark - CGRect
/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE CGFloat flatSpecificScale(CGFloat floatValue,CGFloat scale){
    scale = scale == 0 ? ScreenScale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

CG_INLINE CGFloat flat(CGFloat floatValue){
    return flatSpecificScale(floatValue, 0);
}

CG_INLINE CGRect CGRectSetX(CGRect rect,CGFloat x){
    rect.origin.x = flat(x);
    return rect;
}

CG_INLINE CGRect CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = flat(y);
    return rect;
}

CG_INLINE CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = flat(width);
    return rect;
}

CG_INLINE CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = flat(height);
    return rect;
}

// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
CG_INLINE CGRect
CGRectFlatted(CGRect rect) {
    return CGRectMake(flat(rect.origin.x), flat(rect.origin.y), flat(rect.size.width), flat(rect.size.height));
}
#pragma mark - CGFloat
CG_INLINE CGFloat CGFloatGetCenter(CGFloat parent,CGFloat child){
    return flat((parent - child) / 2.0);
}

#pragma mark - implementation
typedef void(^ButtonTargetBlock)(UIButton * button);
static void * buttonEventsBlockKey = &buttonEventsBlockKey;
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
@interface BMButton ()

/** 事件回调的block */
@property (nonatomic, copy) ButtonTargetBlock buttonTargetBlock;

@end

@implementation BMButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    self.contentEdgeInsets = UIEdgeInsetsMake(1, 0, 1, 0);
    
    self.imagePosition = BMButtonRoutine;//默认布局
}

#pragma mark - 添加类型标记图文位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //size存在空的情况
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    //默认布局不做处理
    if (self.imagePosition == BMButtonRoutine){
        return;
    }
    //content的实际size
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets));
    //垂直布局
    if (self.imagePosition == BMButtonImageTop || self.imagePosition == BMButtonImageBelow){
        
        
        CGFloat imageLimitWidth = contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) - imageSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        CGRect titleFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        
        switch (self.contentHorizontalAlignment) {//重置X坐标
            case UIControlContentHorizontalAlignmentLeft:
            {
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left);
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                break;
            }
            case UIControlContentHorizontalAlignmentCenter:
            {
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left + CGFloatGetCenter(imageLimitWidth, imageSize.width));
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left + CGFloatGetCenter(titleLimitSize.width, titleSize.width));
                break;
            }
            case UIControlContentHorizontalAlignmentRight:
            {
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - imageSize.width);
                titleFrame = CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.titleEdgeInsets.right - titleSize.width);
                break;
            }
            case UIControlContentHorizontalAlignmentFill:
            {
                imageFrame = CGRectSetX(imageFrame, self.contentEdgeInsets.left + self.imageEdgeInsets.left);
                imageFrame = CGRectSetWidth(imageFrame, imageLimitWidth);
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                titleFrame = CGRectSetWidth(titleFrame, titleLimitSize.width);
                break;
            }
            default:
                break;
        }
        
        if (self.imagePosition == BMButtonImageTop){//重置Y坐标
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                {
                    imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                    break;
                }
                case UIControlContentVerticalAlignmentCenter:
                {
                    CGFloat contentHeight = CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets);
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + self.contentEdgeInsets.top;
                    imageFrame = CGRectSetY(imageFrame, minY + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                    break;
                }
                case UIControlContentVerticalAlignmentBottom:
                {
                    titleFrame = CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMinY(titleFrame) - self.titleEdgeInsets.top - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    break;
                }
                case UIControlContentHorizontalAlignmentFill:
                {   //图片按自身大小显示，剩余空间由标题占满
                    imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                    break;
                }
                default:
                    break;
            }
        }else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                {
                    titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
                    break;
                }
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + self.contentEdgeInsets.top;
                    titleFrame = CGRectSetY(titleFrame, minY + self.titleEdgeInsets.top);
                    imageFrame = CGRectSetY(imageFrame, CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top);
                    break;
                }
                case UIControlContentVerticalAlignmentBottom:
                {
                    imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    titleFrame = CGRectSetY(titleFrame, CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                    
                    break;
                }
                case UIControlContentVerticalAlignmentFill:
                {
                    // 图片按自身大小显示，剩余空间由标题占满
                    imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                    titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                    break;
                }
                default:
                    break;
            }
        }
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
        
    }else if (self.imagePosition == BMButtonImageRight){//水平布局
        
        CGFloat imageLimitHeight = contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - CGRectGetWidth(imageFrame) - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        CGRect titleFrame = CGRectMake(0, 0, titleSize.width, titleSize.height);
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
            {
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                imageFrame = CGRectSetX(imageFrame, CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left);
                break;
            }
            case UIControlContentHorizontalAlignmentCenter:
            {
                CGFloat contentWidth = CGRectGetWidth(titleFrame) + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + CGRectGetWidth(imageFrame) + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
                CGFloat minX = self.contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                titleFrame = CGRectSetX(titleFrame, minX + self.titleEdgeInsets.left);
                imageFrame = CGRectSetX(imageFrame, CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left);
                break;
            }
            case UIControlContentHorizontalAlignmentRight:
            {
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                titleFrame = CGRectSetX(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame));
                break;
            }
            case UIControlContentHorizontalAlignmentFill:
            {
                // 图片按自身大小显示，剩余空间由标题占满
                imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                titleFrame = CGRectSetX(titleFrame, self.contentEdgeInsets.left + self.titleEdgeInsets.left);
                titleFrame = CGRectSetWidth(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                break;
            }
                
            case UIControlContentHorizontalAlignmentLeading:
            {
                break;
            }
               
            case UIControlContentHorizontalAlignmentTrailing:
            {
                break;
            }
            default:
                break;
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
            {
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                break;
            }
            case UIControlContentVerticalAlignmentCenter:
            {
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets)));
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets)));
                break;
            }
            case UIControlContentVerticalAlignmentBottom:
            {
                titleFrame = CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame));
                imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                break;
            }
            case UIControlContentVerticalAlignmentFill:
            {
                titleFrame = CGRectSetY(titleFrame, self.contentEdgeInsets.top + self.titleEdgeInsets.top);
                titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                imageFrame = CGRectSetY(imageFrame, self.contentEdgeInsets.top + self.imageEdgeInsets.top);
                imageFrame = CGRectSetHeight(imageFrame, CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetMinY(imageFrame));
                break;
            }
            default:
                break;
        }
        
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
    }
    
    switch (self.imagePosition) {
        case BMButtonImageTop:
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(_space, 0, -_space, 0)];
            break;
        }
        case BMButtonImageBelow:
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(-_space, 0, _space, 0)];
            break;
        }
        case BMButtonImageRight:
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, _space, 0, _space)];
            break;
        }
            
        default:
            break;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    if (CGSizeEqualToSize(self.bounds.size, size)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    
    if (self.imagePosition == BMButtonImageTop || self.imagePosition == BMButtonImageBelow){
        // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
        CGFloat imageLimitWidth = contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];// 假设图片高度必定完整显示
        
        CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) - imageSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        
        resultSize.width = UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
        resultSize.width += fmaxf(UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets) + imageSize.width, UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + titleSize.width);
        resultSize.height = UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + imageSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + titleSize.height;
        
    }else if (self.imagePosition == BMButtonRoutine || self.imagePosition == BMButtonImageRight){
        if (self.imagePosition == BMButtonRoutine && self.titleLabel.numberOfLines == 1) {
            
            resultSize = [super sizeThatFits:size];
            
        } else {
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            
            CGFloat imageLimitHeight = contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
            CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
            
            CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.height = fminf(titleSize.height, titleLimitSize.height);
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets) + imageSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + titleSize.width;
            resultSize.height = UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets);
            resultSize.height += fmaxf(UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + imageSize.height, UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + titleSize.height);
        }

    }
    return resultSize;
}

- (void)setImagePosition:(BMButtonType)buttonType{
    _imagePosition = buttonType;
    [self setNeedsLayout];
}

- (void)setSpace:(NSInteger)space{
    _space = space;
    [self setNeedsLayout];
}

#pragma mark - 设置点击区域的大小
// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);

}

-(CGRect)enlargedRect
{
    NSNumber *topEdge=objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge=objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge=objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge=objc_getAssociatedObject(self, &leftNameKey);
    if(topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x-leftEdge.floatValue,
                          self.bounds.origin.y-topEdge.floatValue,
                          self.bounds.size.width+leftEdge.floatValue+rightEdge.floatValue,
                          self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect=[self enlargedRect];
    if(CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point)?YES:NO;

}

#pragma mark - 设置点击block事件
- (ButtonTargetBlock)buttonTargetBlock{
    return objc_getAssociatedObject(self, &buttonEventsBlockKey);
}

- (void)setButtonTargetBlock:(ButtonTargetBlock)buttonTargetBlock{
    objc_setAssociatedObject(self, &buttonEventsBlockKey, buttonTargetBlock, OBJC_ASSOCIATION_COPY);
}

- (void)addTargetEventforControlEvents:(UIControlEvents)controlEvents block:(void (^)(UIButton * _Nonnull))block{
    self.buttonTargetBlock = block;
    [self addTarget:self action:@selector(blockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blockButtonClick:(UIButton *)sender{
    if (self.buttonTargetBlock){
        self.buttonTargetBlock(sender);
    }
}

@end
