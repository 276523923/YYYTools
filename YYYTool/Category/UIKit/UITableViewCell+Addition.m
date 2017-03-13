//
//  UITableViewCell+Addition.m
//  BaoZhangWang
//
//  Created by haiyabtx on 15/7/22.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import "UITableViewCell+Addition.h"
#import <objc/runtime.h>
#import "UIView+SetFrameAddition.h"
#import "UIView+Addition.h"
#import "NSObject+Addition.h"

static CGFloat defaultCellHeight = 50.0f;

@interface UITableViewCell ()

@property (nonatomic, assign) BOOL needUpdate;

@end

@implementation UITableViewCell (Addition)

+ (CGFloat)cellHeight
{
    return defaultCellHeight;
}

+ (CGFloat)cellHeightWithValue:(id)value
{
    return [self cellHeight];
}

+ (void)load
{
    [self swizzleSelector:@selector(layoutSubviews) swapSelector:@selector(yyy_layoutSubviews)];
}

- (void)yyy_layoutSubviews
{
    [self yyy_layoutSubviews];
    if (self.needUpdate)
    {
        NSArray *targetViews = [self viewsOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")];
        for (UIView *view in targetViews)
        {
            if (self.hiddenSeparator)
            {
                view.fWidth = 0;
                view.hidden = YES;
                continue;
            }
            else
            {
                if (self.hiddenTopSeparator && view.minY == 0)
                {
                    view.fWidth = 0;
                    view.hidden = YES;
                    continue;
                }
                
                if (self.hiddenBottomSeparatorWhenInLast && view.minX == 0 && view.minY > 0)
                {
                    view.fWidth = 0;
                    view.hidden = YES;
                    continue;
                }
                
                if (view.minY == 0)
                {
                    CGRect frame = CGRectZero;
                    frame.origin.x = self.topSeparatorInsert.left;
                    frame.origin.y = self.topSeparatorInsert.top;
                    frame.size.width = self.frame.size.width - self.topSeparatorInsert.left - self.topSeparatorInsert.right;
                    frame.size.height = view.frame.size.height;
                    view.frame = frame;
                }
                else
                {
                    CGRect frame = CGRectZero;
                    frame.origin.x = self.bottomSeparatorInsert.left;
                    frame.origin.y = view.frame.origin.y - self.bottomSeparatorInsert.bottom;
                    frame.size.width = self.frame.size.width - self.bottomSeparatorInsert.left - self.bottomSeparatorInsert.right;
                    frame.size.height = view.frame.size.height;
                    view.frame = frame;
                }
            }
        }
    }
}

#pragma mark - 重写set/get方法 -

- (void)setHiddenSeparator:(BOOL)hiddenSeparator
{
    self.needUpdate = YES;
    objc_setAssociatedObject(self, @selector(hiddenSeparator), @(hiddenSeparator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hiddenSeparator
{
    return [objc_getAssociatedObject(self, @selector(hiddenSeparator)) intValue];
}

- (void)setHiddenTopSeparator:(BOOL)hiddenTopSeparator
{
    self.needUpdate = YES;
    objc_setAssociatedObject(self, @selector(hiddenTopSeparator), @(hiddenTopSeparator), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hiddenTopSeparator
{
    return [objc_getAssociatedObject(self, @selector(hiddenTopSeparator)) intValue];
}

- (void)setZeroSeparatorInset:(BOOL)zeroSeparatorInset
{
    self.topSeparatorInsert = UIEdgeInsetsZero;
    self.bottomSeparatorInsert = UIEdgeInsetsZero;
    objc_setAssociatedObject(self, @selector(zeroSeparatorInset), @(zeroSeparatorInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zeroSeparatorInset
{
    return [objc_getAssociatedObject(self, @selector(zeroSeparatorInset)) intValue];
}

- (UIEdgeInsets)topSeparatorInsert
{
    return [objc_getAssociatedObject(self, @selector(topSeparatorInsert)) UIEdgeInsetsValue];
}

- (void)setTopSeparatorInsert:(UIEdgeInsets)topSeparatorInsert
{
    self.needUpdate = YES;
    objc_setAssociatedObject(self, @selector(topSeparatorInsert), [NSValue valueWithUIEdgeInsets:topSeparatorInsert], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)bottomSeparatorInsert
{
    return [objc_getAssociatedObject(self, @selector(bottomSeparatorInsert)) UIEdgeInsetsValue];
}

- (void)setBottomSeparatorInsert:(UIEdgeInsets)bottomSeparatorInsert
{
    self.needUpdate = YES;
    objc_setAssociatedObject(self, @selector(bottomSeparatorInsert), [NSValue valueWithUIEdgeInsets:bottomSeparatorInsert], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)needUpdate
{
    return [objc_getAssociatedObject(self, @selector(needUpdate)) boolValue];
}

- (void)setNeedUpdate:(BOOL)needUpdate
{
    objc_setAssociatedObject(self, @selector(needUpdate), @(needUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHiddenBottomSeparatorWhenInLast:(BOOL)hiddenBottomSeparatorWhenInLast
{
    self.needUpdate = YES;
    objc_setAssociatedObject(self, @selector(hiddenBottomSeparatorWhenInLast), @(hiddenBottomSeparatorWhenInLast), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hiddenBottomSeparatorWhenInLast
{
    return [objc_getAssociatedObject(self, @selector(hiddenBottomSeparatorWhenInLast)) boolValue];
}

#pragma mark - end -

@end