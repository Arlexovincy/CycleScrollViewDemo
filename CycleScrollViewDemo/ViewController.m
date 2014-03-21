//
//  ViewController.m
//  CycleScrollViewDemo
//
//  Created by Foocaa on 14-3-20.
//  Copyright (c) 2014年 Foocaa. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *picArrary = [[NSMutableArray alloc] init];
    [picArrary addObject:@"http://h.hiphotos.baidu.com/image/w%3D2048/sign=51c749e1ff1f4134e037027e112794ca/dcc451da81cb39db4124b354d2160924aa1830c8.jpg"];
    [picArrary addObject:@"http://a.hiphotos.baidu.com/image/w%3D2048/sign=f61c9056d2160924dc25a51be03f34fa/1f178a82b9014a90b6e2b1bdab773912b21beed6.jpg"];
    [picArrary addObject:@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=551eab04249759ee4a5067cb86c34216/5ab5c9ea15ce36d388dd4c3938f33a87e850b1da.jpg"];
    
    /* 本地图片的数据
    for (int i = 0; i < 3; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg",i]];
        
        [picArrary addObject:image];
    }
     */
    
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 170) cycleDirection:CycleDirectionLandscape pictures:picArrary imageStyle:CycleAsyncImageStyle]; //本地图片imagStyle请用CycleLocalImageStyle
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    SAFE_ARC_RELEASE(picArrary);
    SAFE_ARC_RELEASE(scrollView);
    
}

#pragma mark- CycleScrollView Delegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index
{
    NSLog(@"点击第%d张图片",index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
