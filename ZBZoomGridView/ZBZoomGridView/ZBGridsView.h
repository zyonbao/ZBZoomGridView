//
//  ZBGridsView.h
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBGridsView;
@protocol ZBGridsViewDelegate<NSObject>

- (void)gridView:(ZBGridsView *)gridView didTapAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)gridView:(ZBGridsView *)gridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame;

@end


@interface ZBGridsView : UIView

@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@property(nonatomic, weak) id<ZBGridsViewDelegate> delegate;

@property(nonatomic, assign, readonly) CGSize gridViewSize;

- (void)resetConfig;
- (void)refreshContent;

@end
