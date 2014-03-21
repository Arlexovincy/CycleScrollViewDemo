//
//  CycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by Foocaa on 14-3-20.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcBulidingConfig.h"

typedef enum {
    
    CycleDirectionPortait,     //垂直滚动
    CycleDirectionLandscape    //水平滚动
    
}CycleDirection;

typedef enum {
    
    CycleLocalImageStyle,      //本地图片
    CycleAsyncImageStyle       //异步图片处理
    
}CycleImageStyle;

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>

@optional

/**
 *  点击图片
 *
 *  @param cycleScrollView 属于哪个scrollview
 *  @param index           第几张图片
 */
- (void)cycleScrollViewDelegate:(CycleScrollView*)cycleScrollView didSelectImageView:(int)index;

/**
 *  滑动图片
 *
 *  @param cycleScrollView 属于哪个scrollview
 *  @param index           第几张图片
 */
- (void)cycleScrollViewDelegate:(CycleScrollView*)cycleScrollView didScrollImageView:(int)index;

@end

@interface CycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *m_scrollView;
    UIImageView *m_curImageView;
    
    
    int m_totalPage;
    int m_curPage;
    CGRect m_scrollFrame;
    
    
    CycleDirection m_scrollDirection;   //scrollview滚动到方向
    CycleImageStyle m_imageStyle;       //处理图片到方式
    
    
    NSArray *m_imagesArrary;              //存放图片（UIImage）/图片地址（NSString）到数组
    NSMutableArray *m_curImagesArrary;          //存放当前滚动到三张图片
    
}

@property (assign,nonatomic) id<CycleScrollViewDelegate> delegate;

/**
 *  初始化循环滚动到信息
 *
 *  @param frame        循环视图的位置大小
 *  @param direction    滚动到方向
 *  @param pictureArray 图片或url存储数组
 *  @param imageStyle   图片数组到类型
 *
 *  @return 当前视图到对象
 */
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction
           pictures:(NSArray*)pictureArray imageStyle:(CycleImageStyle)imageStyle;

@end
