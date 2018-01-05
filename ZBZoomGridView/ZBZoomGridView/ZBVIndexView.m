//
//  ZBVIndexView.m
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import "ZBVIndexView.h"
#import "UIView+ZBFrame.h"

@implementation ZBVIndexView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setHeight:(CGFloat)height{
    [super setHeight:height];
    [self setNeedsDisplay];
}

-(void)setIndexsArray:(NSMutableArray *)indexsArray{
    
    _indexsArray = indexsArray;
    
    [self setNeedsDisplay];
}

//画索引条
- (void)drawRect:(CGRect)rect {
    
    [[UIColor whiteColor] setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2.0];
    [bezierPath fill];
    
    NSDictionary *attributeName = @{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor blackColor]};
    
    CGFloat NumberTitleH = (self.height - 2 * 4) / self.indexsArray.count;
    
    CGSize maxSize = CGSizeZero;
    
    for (NSString *str in self.indexsArray) {
        CGSize strSize =  [str sizeWithAttributes:attributeName];
        maxSize = CGSizeMake(MAX(strSize.width, maxSize.width), MAX(strSize.height, maxSize.height));
    }
    
    if (NumberTitleH-maxSize.height<=2) {
        NSString *text = [@(self.indexsArray.count) stringValue];
        CGSize strSize =  [text sizeWithAttributes:attributeName];
        [text drawAtPoint:CGPointMake(self.width * 0.5 - strSize.width  * 0.5,
                                      self.height * 0.5 - strSize.height * 0.5) withAttributes:attributeName];
    } else {
        [self.indexsArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            
            CGSize strSize =  [title sizeWithAttributes:attributeName];
            
            [title drawAtPoint:CGPointMake(self.width * 0.5 - strSize.width  * 0.5,
                                           4 + idx * NumberTitleH + NumberTitleH  * 0.5 - strSize.height  * 0.5
                                           )
                withAttributes:attributeName];
        }];
    }
}

@end
