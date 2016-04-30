//
//  DrCorner.m
//  CornerRadius
//
//  Created by linsir on 16/4/28.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "DrCorner.h"

@interface DrCorner ()

@end

@implementation DrCorner

+ (CGFloat)ceilbyunit:(CGFloat)num unit:(double)unit {
    return num - modf(num, &unit) + unit;
}

+ (CGFloat)floorbyunit:(CGFloat)num unit:(double)unit {
    return num - modf(num, &unit);
}

+ (CGFloat)roundbyunit:(CGFloat)num unit:(double)unit {
    CGFloat remain = modf(num, &unit);
    if (remain > unit / 2.0) {
        return [self ceilbyunit:num unit:unit];
    } else {
        return [self floorbyunit:num unit:unit];
    }
}

+ (CGFloat)pixel:(CGFloat)num {
    CGFloat unit;
    CGFloat scale = [[UIScreen mainScreen] scale];
    switch ((NSInteger)scale) {
        case 1:
            unit = 1.0 / 1.0;
            break;
        case 2:
            unit = 1.0 / 2.0;
            break;
        case 3:
            unit = 1.0 / 3.0;
            break;
        default:
            unit = 0.0;
            break;
    }
    return [self roundbyunit:num unit:unit];
}


@end


#pragma mark - 针对UIView绘画出Image

@implementation UIView (dr)


- (void)dr_addCornerRadius:(CGFloat)radius {
    [self dr_addCornerRadius:radius
                 borderWidth:1.0f
             backgroundColor:[UIColor whiteColor]
                borderCorlor:[UIColor blackColor]];
}

- (void)dr_addCornerRadius:(CGFloat)radius
               borderWidth:(CGFloat)borderWidth
           backgroundColor:(UIColor *)backgroundColor
              borderCorlor:(UIColor *)borderColor {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self dr_drawRectWithRoundedCornerRadius:radius
                                                                                             borderWidth:borderWidth
                                                                                         backgroundColor:backgroundColor
                                                                                            borderCorlor:borderColor]];
    
    [self insertSubview:imageView atIndex:0];
}

- (UIImage *)dr_drawRectWithRoundedCornerRadius:(CGFloat)radius
                                    borderWidth:(CGFloat)borderWidth
                                backgroundColor:(UIColor *)backgroundColor
                                   borderCorlor:(UIColor *)borderColor {
    CGSize sizeToFit = CGSizeMake([DrCorner pixel:self.bounds.size.width], self.bounds.size.height);
    CGFloat halfBorderWidth = borderWidth / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGFloat width = sizeToFit.width, height = sizeToFit.height;
    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth); // 准备开始移动坐标
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius);
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end


#pragma mark - UIImageView (CornerRounder)

@implementation UIImageView (CornerRounder)

- (void)dr_addCornerRadius:(CGFloat)radius {
    self.image = [self.image dr_imageAddCornerWithRadius:radius andSize:self.bounds.size];
}

@end


#pragma mark - UIImage (ImageCornerRounder)


@implementation UIImage (ImageCornerRounder)

- (UIImage*)dr_imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end



