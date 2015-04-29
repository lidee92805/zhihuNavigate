//
//  SecondViewController.m
//  ZhiHuNavigate
//
//  Created by lidehua on 15/4/29.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
@interface SecondViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,assign) CGPoint hitPoint;
@property (nonatomic,assign) CGPoint tableViewPoint;
@end
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    _bgImage.backgroundColor = [UIColor whiteColor];
    [delegate.window insertSubview:_bgImage atIndex:0];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"table" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (void)panView:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        _hitPoint = [pan translationInView:self.view];
        _tableViewPoint = self.tableView.contentOffset;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint changePoint = [pan translationInView:self.view];
        if (changePoint.x - _hitPoint.x > 30) {
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(changePoint.x - _hitPoint.x, 0);
            //[self.tableView setContentOffset:CGPointMake(_tableViewPoint.x,_tableViewPoint.y - (changePoint.y - _hitPoint.y) )];
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGAffineTransform transform = self.navigationController.view.transform;
        if (transform.tx >= kScreenWidth/2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.view.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
            } completion:^(BOOL finished) {
                self.navigationController.view.transform = CGAffineTransformIdentity;
                [self.navigationController popViewControllerAnimated:NO];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.navigationController.view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}
@end
