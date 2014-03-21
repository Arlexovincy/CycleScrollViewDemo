//
//  CycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by Foocaa on 14-3-20.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//


#define TOTAL_SHOW_COUNT 3
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"

@interface CycleScrollView (PrivateMewthods)

/**
 *  刷新滚动视图
 */
- (void)refreshScrollView;

/**
 *  获得要展示的图片
 *
 *  @param page 要展示的页号
 *
 *  @return 展示到图片
 */
- (NSArray*)displayImagesWithCurpage:(int)page;

/**
 *  得到有效到页数
 *
 *  @param value 需要到页数
 *
 *  @return 有效到页数
 */
- (int)validPageValue:(NSInteger)value;

/**
 *  点击图片
 *
 *  @param tap 点击的手势
 */
- (void)tapImageView:(UITapGestureRecognizer*)tap;

@end

@implementation CycleScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray imageStyle:(CycleImageStyle)imageStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        m_scrollFrame = frame;
        m_scrollDirection = direction;
        m_totalPage = pictureArray.count;
        m_curPage = 1;
        m_imageStyle = imageStyle;
        m_curImagesArrary = [[NSMutableArray alloc] init];
        m_imagesArrary = [[NSArray alloc] initWithArray:pictureArray];
        
        
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        m_scrollView.delegate = self;
        m_scrollView.backgroundColor = [UIColor blackColor];
        m_scrollView.showsHorizontalScrollIndicator = NO;
        m_scrollView.showsVerticalScrollIndicator = NO;
        m_scrollView.pagingEnabled = YES;
        [self addSubview:m_scrollView];
        
        //水平方向滚动
        if (m_scrollDirection == CycleDirectionLandscape) {
            
            m_scrollView.contentSize = CGSizeMake(CGRectGetWidth(m_scrollView.frame) * TOTAL_SHOW_COUNT, CGRectGetHeight(m_scrollView.frame));  //一直都是三张
        }
        
        //垂直方向滚动
        if (m_scrollDirection == CycleDirectionPortait) {
            
            m_scrollView.contentSize = CGSizeMake(CGRectGetWidth(m_scrollView.frame), CGRectGetHeight(m_scrollView.frame) * TOTAL_SHOW_COUNT);  //一直都是三张
        }
        
        [self refreshScrollView];
    }
    return self;
}

- (void)dealloc
{
    SAFE_ARC_RELEASE(m_imagesArrary);
    SAFE_ARC_RELEASE(m_curImagesArrary);
    SAFE_ARC_RELEASE(m_scrollView);
    SAFE_ARC_SUPER_DEALLOC();
}


#pragma mark- 刷新滚动视图
- (void)refreshScrollView
{
    NSArray *subViews = [m_scrollView subviews];
    if ([subViews count]!= 0) {
        
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];  //让数组中到每个元素都执行“removeFromSuperview”
    }
    
    [self displayImagesWithCurpage:m_curPage];
    
    for (int imageCount = 0; imageCount < TOTAL_SHOW_COUNT; imageCount++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_scrollFrame), CGRectGetHeight(m_scrollFrame))];
        imageView.userInteractionEnabled = YES;
        
        if (m_imageStyle == CycleLocalImageStyle) {
            
            //本地图片
            [imageView setImage:[m_curImagesArrary objectAtIndex:imageCount]];
            
        }else if (m_imageStyle == CycleAsyncImageStyle){
            
            //异步图片
            [imageView setImageWithURL:[m_curImagesArrary objectAtIndex:imageCount]];
        }
        
        //添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        
        [imageView addGestureRecognizer:singleTap];
        SAFE_ARC_RELEASE(singleTap);
        
        //水平滚动
        if (m_scrollDirection == CycleDirectionLandscape) {
            
            imageView.frame = CGRectOffset(imageView.frame, CGRectGetWidth(m_scrollView.frame) * imageCount, 0);
        }
        
        //垂直滚动
        if (m_scrollDirection == CycleDirectionPortait) {
            
            imageView.frame = CGRectOffset(imageView.frame, 0, CGRectGetHeight(m_scrollView.frame) * imageCount);
        }
        
        [m_scrollView addSubview:imageView];
        SAFE_ARC_RELEASE(imageView);
            
    }
    
    if (m_scrollDirection == CycleDirectionLandscape) {
        
        [m_scrollView setContentOffset:CGPointMake(CGRectGetWidth(m_scrollView.frame), 0)];
    }
    
    if (m_scrollDirection == CycleDirectionPortait) {
        
        [m_scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(m_scrollView.frame))];
    }
}


#pragma mark- 获得要展示的图片
- (NSArray*)displayImagesWithCurpage:(int)page
{
    
    int pre = [self validPageValue:m_curPage - 1];
    int last = [self validPageValue:m_curPage + 1];
    
    if (m_curImagesArrary.count != 0) {
        
        [m_curImagesArrary removeAllObjects];
    }
    
    [m_curImagesArrary addObject:[m_imagesArrary objectAtIndex:pre - 1]];
    [m_curImagesArrary addObject:[m_imagesArrary objectAtIndex:m_curPage - 1]];
    [m_curImagesArrary addObject:[m_imagesArrary objectAtIndex:last - 1]];
    
    return m_curImagesArrary;
}

#pragma mark- 得到有效到页数
- (int)validPageValue:(NSInteger)value
{
    if (value == 0) {
        
        value = m_totalPage;
    }
                                            // value＝1为第一张，value = 0为前面一张
    if (value == m_totalPage + 1) {
        
        value = 1;
    }
    
    return value;
}


#pragma mark- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    int y = scrollView.contentOffset.y;
    
    //水平滚动
    if (m_scrollDirection == CycleDirectionLandscape) {
        
        //往下翻一张
        if (x >= (2 * CGRectGetWidth(m_scrollView.frame))) {
            
            m_curPage = [self validPageValue:m_curPage + 1];
            [self refreshScrollView];
        }
        
        if (x <= 0) {
            
            m_curPage = [self validPageValue:m_curPage - 1];
            [self refreshScrollView];
        }
    }
    
    //垂直滚动
    if (m_scrollDirection == CycleDirectionPortait) {
        
        //往下翻一张
        if (y >= (2 * CGRectGetHeight(m_scrollView.frame))) {
            
            m_curPage = [self validPageValue:m_curPage + 1];
            [self refreshScrollView];
        }
        
        if (y <= 0) {
            
            m_curPage = [self validPageValue:m_curPage - 1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        
        [delegate cycleScrollViewDelegate:self didScrollImageView:m_curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (m_scrollDirection == CycleDirectionLandscape) {
        
        [m_scrollView setContentOffset:CGPointMake(CGRectGetWidth(m_scrollFrame) , 0 ) animated:YES];
    }
    
    if (m_scrollDirection == CycleDirectionPortait) {
        
        [m_scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(m_scrollFrame)) animated:YES];
    }
}

#pragma mark- 点击图片
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        
        [delegate cycleScrollViewDelegate:self didSelectImageView:m_curPage];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
