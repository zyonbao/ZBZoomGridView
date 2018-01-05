//
//  ViewController.m
//  ZBZoomGridView
//
//  Created by sungrow on 2018/1/4.
//  Copyright © 2018年 picoluster. All rights reserved.
//

#import "ViewController.h"
#import "ZBZoomGridView.h"

@interface ViewController ()<ZBZoomGridViewDelegate>

@property (nonatomic, strong) ZBZoomGridView *zoomView;

@end

@implementation ViewController{
    NSMutableDictionary *_positions;
}

- (void)loadView {
    [super loadView];
    _positions = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.zoomView = [[ZBZoomGridView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.zoomView.delegate = self;
    self.zoomView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    self.zoomView.itemWidth = 80;
    self.zoomView.itemHeight = 60;
    self.zoomView.numberOfColumns = 24;
    self.zoomView.numberOfRows = 22;
    [self.view addSubview:self.zoomView];
    
    self.zoomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[zoomView]-0-|" options:0 metrics:nil views:@{@"zoomView":self.zoomView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[zoomView]-0-|" options:0 metrics:nil views:@{@"zoomView":self.zoomView}]];
    
    [self.zoomView refreshContent];
    //0.3s 后布局刷新应该完成了吧
    [self.zoomView performSelector:@selector(scale2MinAnimation)  withObject:nil afterDelay:0.3];
}

- (void)zoomGridView:(ZBZoomGridView *)zoomGridView didTapAtColumn:(NSInteger)column row:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:row];
    if (_positions[indexPath]) {
        [_positions removeObjectForKey:indexPath];
    } else {
        [_positions setObject:@(1) forKey:indexPath];
    }
    [zoomGridView refreshContent];
}

- (void)zoomGridView:(ZBZoomGridView *)zoomGridView drawInContext:(CGContextRef)context forColumn:(NSInteger)column row:(NSInteger)row frame:(CGRect)frame {
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect drawFrame  = CGRectInset(frame, width*0.05, height*0.05);
    
    CGContextFillRect(context, drawFrame);
    [[UIColor colorWithRed:0.44 green:0.44 blue:0.44 alpha:1.00] setStroke];
    [[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00] setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:drawFrame];
    [path fill];
    [path stroke];
    
    UIBezierPath *addPath = [UIBezierPath bezierPath];
    addPath.lineWidth = 2.5;
    CGFloat lineLength =  MIN(CGRectGetHeight(drawFrame),CGRectGetWidth(drawFrame))*.4;
    
    CGFloat lineV = (CGRectGetHeight(drawFrame)-lineLength)*.5;
    CGFloat lineH = (CGRectGetWidth(drawFrame)-lineLength)*.5;
    [addPath moveToPoint:CGPointMake(CGRectGetMidX(drawFrame), CGRectGetMinY(drawFrame)+lineV)];
    [addPath addLineToPoint:CGPointMake(CGRectGetMidX(drawFrame), CGRectGetMaxY(drawFrame)-lineV)];
    [addPath moveToPoint:CGPointMake(CGRectGetMinX(drawFrame)+lineH, CGRectGetMidY(drawFrame))];
    [addPath addLineToPoint:CGPointMake(CGRectGetMaxX(drawFrame)-lineH, CGRectGetMidY(drawFrame))];
    [addPath stroke];
}


@end
