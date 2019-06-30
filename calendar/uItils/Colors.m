//
//  Colors.m
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "Colors.h"

@implementation Colors

#pragma mark - Helpers;

+ (UIColor *)getRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    return [UIColor colorWithRed:r/256.f
                           green:g/256.f
                            blue:b/256.f
                           alpha:a];
}

#pragma mark - Getters;

+ (UIColor *)blackColor {
    return [UIColor blackColor];
}

+ (UIColor *)whiteColor {
    return [UIColor whiteColor];
}

+ (UIColor *)darkGrayColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)grayColor {
    return [UIColor grayColor];
}

+ (UIColor *)lightGrayColor {
    return [UIColor lightGrayColor];
}

+ (UIColor *)darkBlueColor {
    return [self getRed:3.f green:117.f blue:148.f alpha:1];
}

+ (UIColor *)redColor {
    return [UIColor redColor];
}

@end
