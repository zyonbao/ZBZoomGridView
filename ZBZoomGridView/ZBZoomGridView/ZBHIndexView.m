//
//  ZBHIndexView.m
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import "ZBHIndexView.h"
#import "UIView+ZBFrame.h"

#define kSmallMargin 2 // indexView 超出的部分

@implementation ZBHIndexView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setWidth:(CGFloat)width {
    [super setWidth:width];
    [self setNeedsDisplay];
}

-(void)setIndexsArray:(NSMutableArray *)indexsArray{
    _indexsArray = indexsArray;
    [self setNeedsDisplay];
}

//画索引条
- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetHeight(rect)/2.0];
    [bezierPath fill];
    
    NSDictionary *attributeName = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor blackColor]};
    
    CGFloat NumberTitleW = (self.width - 2 * kSmallMargin) / self.indexsArray.count;
    
    CGSize maxSize = CGSizeZero;
    
    for (NSString *str in self.indexsArray) {
        CGSize strSize =  [str sizeWithAttributes:attributeName];
        maxSize = CGSizeMake(MAX(strSize.width, maxSize.width), MAX(strSize.height, maxSize.height));
    }
    
    if (NumberTitleW - maxSize.width <= 2) {
        NSString *text = [@(self.indexsArray.count) stringValue];
        CGSize strSize =  [text sizeWithAttributes:attributeName];
        [text drawAtPoint:CGPointMake(self.width * 0.5 - strSize.width  * 0.5,
                                      self.height * 0.5 - strSize.height * 0.5) withAttributes:attributeName];
    } else {
        [self.indexsArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            
            CGSize strSize =  [title sizeWithAttributes:attributeName];

            [title drawAtPoint:CGPointMake(
                                           kSmallMargin+idx*NumberTitleW+NumberTitleW*0.5-strSize.width*0.5,
                                           self.height*0.5-strSize.height*0.5) withAttributes:attributeName];
        }];
    }
}

@end
