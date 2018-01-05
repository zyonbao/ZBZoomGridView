//
//  ZBGridView.m
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import "ZBGridsView.h"
#import "UIView+Extension.h"

@interface ZBGridsView()<CALayerDelegate>

@end

@implementation ZBGridsView {
    __weak CATiledLayer *_tiledLayer;
    UITapGestureRecognizer *_tapRecognizer;
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tiledLayer = (CATiledLayer*)self.layer;
        [self initialConfig];
    }
    return self;
}

- (void)initialConfig {
    _itemWidth = 100;
    _itemHeight = 90;
    _numberOfRows = 30;
    _numberOfColumns = 40;
    self.backgroundColor = [UIColor cyanColor];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecogAction:)];
    [self addGestureRecognizer:_tapRecognizer];
}

- (void)resetConfig {
    [_tiledLayer setTileSize:CGSizeMake(_itemWidth, _itemHeight)];
    [_tiledLayer setLevelsOfDetail:8];
    [_tiledLayer setLevelsOfDetailBias:2];
    CGPoint pointBefore = self.frame.origin;
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.gridViewSize.width, self.gridViewSize.height);
    [self setFrame:(CGRect){pointBefore,self.frame.size}];
}

- (void)refreshContent {
    [self setNeedsDisplay];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    UIGraphicsPushContext(ctx);
    CGContextSaveGState(ctx);
    [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00] setFill];
    CGContextFillRect(ctx, bounds);
    CGContextRestoreGState(ctx);
    UIGraphicsPopContext();
    for (int i = 0; i < _numberOfRows; i++) {
        for (int j = 0; j< _numberOfColumns; j++) {
            CGRect currentRect = [self frame4IteminRow:i column:j];
            if (CGRectIntersectsRect(currentRect, bounds)) {
                // 转换为当前用户坐标下的坐标
                UIGraphicsPushContext(ctx);
                CGContextSaveGState(ctx);
                if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:drawInContext:forColumn:row:frame:)]) {
                    [self.delegate gridView:self drawInContext:ctx forColumn:j row:i frame:currentRect];
                }
                CGContextRestoreGState(ctx);
                UIGraphicsPopContext();
            } else {
                continue;
            }
        }
    }
}

- (CGRect)frame4IteminRow:(NSInteger)row column:(NSInteger)column {
    return CGRectMake(column*_itemWidth, row*_itemHeight, _itemWidth, _itemHeight);
}

- (CGSize)gridViewSize {
    return CGSizeMake(_itemWidth*_numberOfColumns,
                      _itemHeight*_numberOfRows);
}

- (void)tapRecogAction:(UITapGestureRecognizer *)tap {
    //拿到点击的 view 的坐标
    CGPoint location = [tap locationInView:self];
    NSInteger column = location.x / _itemWidth;
    NSInteger row = location.y / _itemHeight;

    if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didTapAtColumn:row:)]) {
        [self.delegate gridView:self didTapAtColumn:column row:row];
    }
}

@end
