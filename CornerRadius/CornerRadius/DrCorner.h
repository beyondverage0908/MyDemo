//
//  DrCorner.h
//  CornerRadius
//
//  Created by linsir on 16/4/28.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrCorner : NSObject

@end

#pragma mark - UIView (dr)

@interface UIView (dr)

/**
 *  给label, button, textfield等添加圆角，默认borderWidth = 1.0f, backgroundColor = whiteColor, borderColor = blackColor
 *
 *  @param radius 弧度
 */
- (void)dr_addCornerRadius:(CGFloat)radius;


/**
 *  给label, button, textfield等添加圆角, 可以自定义其它的属性
 *
 *  @param radius          弧度
 *  @param borderWidth     borderWidth
 *  @param backgroundColor backgroundColor
 *  @param borderColor     borderColor
 */
- (void)dr_addCornerRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
           backgroundColor:(UIColor *)backgroundColor
              borderCorlor:(UIColor *)borderColor;

@end

#pragma mark - UIImageView (CornerRounder)

@interface UIImageView (CornerRounder)

/**
 *  给imageView做圆角, 无边框
 *
 *  @param radius 圆角弧度
 */

- (void)dr_addCornerRadius:(CGFloat)radius;

@end


@interface UIImage (ImageCornerRounder)

/**
 *  绘画一个Image，并对Image进行裁边处理
 *
 *  @param radius 弧度
 *  @param size   size
 *
 *  @return image
 */

- (UIImage*)dr_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

@end
