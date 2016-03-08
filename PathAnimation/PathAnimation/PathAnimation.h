//
//  PathAnimation.h
//  MicroCatering
//
//  Created by zhaothree on 16/3/7.
//
//

#import <Foundation/Foundation.h>

@interface PathAnimation : NSObject

+(instancetype)pathAnimationOperation;

-(void)joinViewFromViewRect:(CGRect)rect andEndView:(UIView *)endView fromSuperView:(UIView *)view;

@end
