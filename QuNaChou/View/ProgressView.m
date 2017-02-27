//
//  ProgressView.m
//  MyProject
//
//  Created by WYD on 16/4/19.
//  Copyright © 2016年 QuNaChou. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _percent = 0;
        _width = 0;
        _number = 0;
    }
    
    return self;
}


- (void)setPercent:(float)percent{
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [self addArcBackColor];
    [self drawArc];
    [self addCenterBack];
    [self addCenterLabel];
}

- (void)addArcBackColor{
    CGColorRef color = (_arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : _arcBackColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)drawArc{
    if (_percent == 0 || _percent > 1) {
        return;
    }
    
    if (_percent == 1) {
        CGColorRef color = (_arcFinishColor == nil) ? [UIColor greenColor].CGColor : _arcFinishColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }else{
        
        float endAngle = 2*M_PI*_percent;
        
        CGColorRef color = (_arcUnfinishColor == nil) ? [UIColor blueColor].CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,endAngle, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
    
}

-(void)addCenterBack{
    float width = (_width == 0) ? 5 : _width;
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2 - width;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)addCenterLabel{
//    NSString *number = [NSString stringWithFormat:@"%.2f",_number];
//    NSArray *array = [number componentsSeparatedByString:@"."];
//    NSString *percent = [NSString stringWithFormat:@"%@",array[0]];
//    NSString *percent2 = [NSString stringWithFormat:@".%@%%",array[1]];
    NSString *percent = @"加入";
    float fontSize1 = 15;
//    float fontSize2 = 18;
//    float fontSize3 = 12;
//
    UIColor *arcColor = _arcFinishColor;
//
////    if (_percent == 1) {
////        percent = @"100%";
////        fontSize = 14;
////        arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : _arcFinishColor;
////
////    }else if(_percent < 1 && _percent >= 0){
//    
////        arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : _arcUnfinishColor;
////        percent = [NSString stringWithFormat:@"%0.2f%%",_percent*100];
////    percent = @"8.";
////        percent = [N]
////    }
//

    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize1],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
//
    [percent drawInRect:CGRectMake(0, (viewSize.height-fontSize1)/2, viewSize.width, fontSize1)withAttributes:attributes];
//
//    paragraph.alignment = NSTextAlignmentLeft;
//    NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize2],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
//    
//    [percent2 drawInRect:CGRectMake(viewSize.width/2-5, (viewSize.height-fontSize2)/2, viewSize.width-10, fontSize2)withAttributes:attributes2];
//    
//    
//    NSString *percent3 = @"年化收益率";
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize3],NSFontAttributeName,TEXT_COLOR_GRAY,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
//    
//    [percent3 drawInRect:CGRectMake(5, (viewSize.height-fontSize3)/2+17, viewSize.width-10, fontSize3)withAttributes:attributes3];
}


@end
