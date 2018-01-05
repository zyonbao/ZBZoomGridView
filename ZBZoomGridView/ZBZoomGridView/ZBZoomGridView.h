//
//  ZBZoomGridView.h
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  ZBScreenW [UIScreen mainScreen].bounds.size.width//屏幕宽
#define  ZBScreenH [UIScreen mainScreen].bounds.size.height//屏幕高

@class ZBZoomGridView;
@protocol ZBZoomGridViewDelegate<NSObject>

- (void)zoomGridView:(ZBZoomGridView *)zoomGridView didTapAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)zoomGridView:(ZBZoomGridView *)zoomGridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame;

@end

@interface ZBZoomGridView : UIView

@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, weak) id<ZBZoomGridViewDelegate> delegate;

- (void)refreshContent;
- (void)startAnimation;

@end
