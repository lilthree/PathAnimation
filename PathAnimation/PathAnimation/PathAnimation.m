//
//  PathAnimation.m
//  MicroCatering
//
//  Created by zhaothree on 16/3/7.
//
//

#import "PathAnimation.h"

@interface PathAnimation ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) CALayer *dotLayer;

@property (nonatomic, strong) UIView *endView;

@end

@implementation PathAnimation


+(instancetype)pathAnimationOperation
{
    static PathAnimation *pathAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pathAnimation = [[self alloc] init];
    });
    return pathAnimation;
}

-(void)joinViewFromViewRect:(CGRect)rect andEndView:(UIView *)endView fromSuperView:(UIView *)view
{
    CGFloat startX = rect.origin.x;
    CGFloat startY = rect.origin.y;
    
    _endView = endView;
    
    CGRect endRect = [view convertRect:endView.frame fromView:endView.superview];
    
    CGFloat endX = endRect.origin.x;
    CGFloat endY = endRect.origin.y;
    
    _path= [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endX, endY)
             controlPoint1:CGPointMake(startX, startY)
             controlPoint2:CGPointMake(startX - 180, startY - 200)];
    
    _dotLayer = [CALayer layer];
    _dotLayer.backgroundColor = [UIColor redColor].CGColor;
    _dotLayer.frame = CGRectMake(0, 0, 15, 15);
    _dotLayer.cornerRadius = (15 + 15) /4;

    
    [view.layer addSublayer:_dotLayer];
    [self groupAnimation];
}


#pragma mark - 组合动画
-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
    alphaAnimation.duration = 0.5f;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,alphaAnimation];
    groups.duration = 0.8f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [_dotLayer addAnimation:groups forKey:nil];
    
    [self performSelector:@selector(removeFromLayer:) withObject:_dotLayer afterDelay:0.8f];
    
}
- (void)removeFromLayer:(CALayer *)layerAnimation
{
    
    [layerAnimation removeFromSuperlayer];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.9];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1];
        shakeAnimation.autoreverses = YES;
        [_endView.layer addAnimation:shakeAnimation forKey:nil];
    }
    
}

@end
