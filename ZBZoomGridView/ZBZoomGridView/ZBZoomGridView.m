//
//  ZBZoomGridView.m
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import "ZBZoomGridView.h"
#import "ZBGridsView.h"
#import "ZBHIndexView.h"
#import "ZBVIndexView.h"
#import "UIView+ZBFrame.h"

#define kIndexViewWidth 20
#define kScrollViewInset 50
#define kSmallMargin 4 // indexView 超出的部分

@interface ZBZoomGridView()<UIScrollViewDelegate, ZBGridsViewDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) ZBGridsView *gridsView;
@property (nonatomic, strong) ZBHIndexView *hIndexView;
@property (nonatomic, strong) ZBVIndexView *vIndexView;

@end

@implementation ZBZoomGridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    [self initialScrollView];
    [self initialGridsView];
    [self initialHIndexView];
    [self initialVIndexView];
}

- (void)initialScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.containerScrollView = scrollView;
    self.containerScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.containerScrollView.delegate = self;
    self.containerScrollView.showsHorizontalScrollIndicator = NO;
    self.containerScrollView.showsVerticalScrollIndicator = NO;
    self.containerScrollView.minimumZoomScale = 0.01;
    self.containerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerScrollView.contentInset = UIEdgeInsetsMake(kScrollViewInset, kScrollViewInset, 0, 0);
    [self addSubview:self.containerScrollView];
}

- (void)initialGridsView {
    ZBGridsView *gridsView = [[ZBGridsView alloc] initWithFrame:self.bounds];
    gridsView.delegate = self;
    self.gridsView = gridsView;
    gridsView.width = gridsView.gridViewSize.width;
    gridsView.height = gridsView.gridViewSize.height;
    gridsView.opaque = YES;
    [self.containerScrollView addSubview:self.gridsView];
    [self.containerScrollView setContentSize:gridsView.gridViewSize];
}

- (void)initialHIndexView {
    ZBHIndexView *columnIndexView = [[ZBHIndexView alloc]init];
    columnIndexView.indexsArray = [@[@"1",@"2",@"3",@"4",@"5"] mutableCopy];
    columnIndexView.height = kIndexViewWidth;
    columnIndexView.width = self.gridsView.width + 2 * kSmallMargin;
    columnIndexView.y =  self.containerScrollView.contentOffset.x + (kScrollViewInset-kIndexViewWidth)/2;
    columnIndexView.x = self.gridsView.x - kSmallMargin;
    self.hIndexView = columnIndexView;
    [self.containerScrollView addSubview:columnIndexView];
}

- (void)initialVIndexView {
    ZBVIndexView *rowIndexView = [[ZBVIndexView alloc] initWithFrame:CGRectZero];
    rowIndexView.indexsArray = [@[@"1",@"2",@"3",@"4",@"5"] mutableCopy];
    rowIndexView.width = kIndexViewWidth;
    rowIndexView.height = self.gridsView.height + 2 * kSmallMargin;
    rowIndexView.y =  self.gridsView.y - kSmallMargin;
    rowIndexView.x = self.containerScrollView.contentOffset.x + (kScrollViewInset-kIndexViewWidth)/2;
    self.vIndexView = rowIndexView;
    [self.containerScrollView addSubview:rowIndexView];
}

- (void)refreshContent {
    self.gridsView.numberOfRows = self.numberOfRows;
    self.gridsView.numberOfColumns = self.numberOfColumns;
    self.gridsView.itemWidth = self.itemWidth;
    self.gridsView.itemHeight = self.itemHeight;
    [self.gridsView resetConfig];
    [self.gridsView refreshContent];
    [self.containerScrollView setContentSize:self.gridsView.gridViewSize];
    
    NSMutableArray<NSString*> *columns = [NSMutableArray arrayWithCapacity:_numberOfColumns];
    for (NSInteger index = 0; index < _numberOfColumns; index++) {
        [columns addObject:[@(index+1) stringValue]];
    }
    NSMutableArray<NSString*> *rows = [NSMutableArray arrayWithCapacity:_numberOfRows];
    for (NSInteger index = 0; index < _numberOfRows; index++) {
        [rows addObject:[@(index+1) stringValue]];
    }
    
    self.vIndexView.width = kIndexViewWidth;
    self.vIndexView.height = self.gridsView.height + 2 * kSmallMargin;
    self.vIndexView.y =  self.gridsView.y - kSmallMargin;
    self.vIndexView.x = self.containerScrollView.contentOffset.x + (kScrollViewInset-kIndexViewWidth)/2;
    self.vIndexView.indexsArray = rows;
    
    self.hIndexView.height = kIndexViewWidth;
    self.hIndexView.width = self.gridsView.width + 2 * kSmallMargin;
    self.hIndexView.y =  self.containerScrollView.contentOffset.y + (kScrollViewInset-kIndexViewWidth)/2;
    self.hIndexView.x = self.gridsView.x - kSmallMargin;
    self.hIndexView.indexsArray = columns;
    
    CGFloat goalScale = ({
        CGFloat hScale = self.containerScrollView.frame.size.width/self.gridsView.gridViewSize.width;
        CGFloat vScale = self.containerScrollView.frame.size.height/self.gridsView.gridViewSize.height;
        MIN(hScale, vScale);
    });
    self.minScale = goalScale;
    self.maxScale = 1.0f;
}

-(void)startAnimation{
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect zoomRect = [self _zoomRectInView:self.containerScrollView
                                                        forScale:self.minScale
                                                      withCenter:CGPointMake(self.gridsView.gridViewSize.width/2,
                                                                             self.gridsView.gridViewSize.height/2)];
                         
                         [self.containerScrollView zoomToRect:zoomRect
                                                animated:NO];
                     } completion:nil];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 更新索引条
    self.vIndexView.x = scrollView.contentOffset.x + (kScrollViewInset-kIndexViewWidth)/2;
    self.hIndexView.y = scrollView.contentOffset.y + (kScrollViewInset-kIndexViewWidth)/2;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.gridsView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    self.vIndexView.height = self.gridsView.height + 2 * kSmallMargin;
    self.hIndexView.width = self.gridsView.width + 2 * kSmallMargin;
    [self scrollViewDidEndDecelerating:scrollView];
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}

- (CGRect)_zoomRectInView:(UIView *)view forScale:(CGFloat)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    zoomRect.size.height = view.bounds.size.height / scale;
    zoomRect.size.width = view.bounds.size.width / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
    
}

#pragma mark - ZBGridsViewDelegate
- (void)gridView:(ZBGridsView *)gridView didTapAtColumn:(NSInteger)column row:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoomGridView:didTapAtColumn:row:)]) {
        [self.delegate zoomGridView:self didTapAtColumn:column row:row];
    }
    if (self.containerScrollView.zoomScale < 1.0) {
        CGRect zoomRect = [self _zoomRectInView:self.containerScrollView forScale:1.0 withCenter:CGPointMake(column*_itemWidth, row*_itemHeight)];
        [self.containerScrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)gridView:(ZBGridsView *)gridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zoomGridView:drawInContext:forColumn:row:frame:)]) {
        [self.delegate zoomGridView:self drawInContext:context forColumn:column row:row frame:frame];
    }
}

#pragma mark - getter & setter
- (void)setMinScale:(CGFloat)minScale {
    [self.containerScrollView setMinimumZoomScale:minScale];
}

- (void)setMaxScale:(CGFloat)maxScale {
    [self.containerScrollView setMaximumZoomScale:maxScale];
}

- (CGFloat)minScale {
    return self.containerScrollView.minimumZoomScale;
}

- (CGFloat)maxScale {
    return self.containerScrollView.maximumZoomScale;
}

@end
