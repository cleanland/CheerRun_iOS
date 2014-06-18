//
//  DistanceView.swift
//  CheerRun
//
//  Created by Andy Chen on 6/9/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class DistanceView: UIView {
    
    init(frame aRect: CGRect) {
        super.init(frame: aRect)
        self.backgroundColor=UIColor.whiteColor()
    }
    
    
    var height=520
    override func drawRect(rect:CGRect){
        
        begin()
        
    }
    
    func begin()
    {
    var ctx:CGContextRef = UIGraphicsGetCurrentContext();
    // 定义其rect
    var bottom:CGRect = CGRectMake(25, ( 365) , 90, 90);
    
    // 在当前路径下添加一个椭圆路径
    CGContextAddEllipseInRect(ctx, bottom);
    
    // 设置当前视图填充色
    CGContextSetFillColorWithColor(ctx, UIColor(red:(80/255.0), green:229/255.0, blue:29/255.0, alpha:1).CGColor);
    
    // 绘制当前路径区域
    CGContextFillPath(ctx);
    
    var above_bottom:CGRect = CGRectMake(35, 375, 70, 70);
    // 在当前路径下添加一个椭圆路径
    CGContextAddEllipseInRect(ctx, above_bottom);
    
    // 设置当前视图填充色
    CGContextSetFillColorWithColor(ctx, UIColor(red:255, green:255, blue:255, alpha:1).CGColor);
    CGContextFillPath(ctx);
    
    CGContextSetTextDrawingMode (ctx,kCGTextFillStroke);//设置绘制方式
    CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor);//填充色设置成蓝色，即文字颜色
    
    CGContextSetLineWidth(ctx,0);//我们采用的是FillStroke的方式，所以要把边线去掉，否则文字会很粗
    
//    NSString *fontName = @"";
//    
//    NSUInteger count1 = arc4random() % ([UIFont familyNames].count);
//    NSString *familyName = [UIFont familyNames][count1];
//    NSUInteger count2 = [UIFont fontNamesForFamilyName:familyName].count;
//    fontName = [UIFont fontNamesForFamilyName:familyName][arc4random() % count2];
//
        var font:UIFont = UIFont(name:"Arial", size:20.0);
        var string:NSString = "開始";
       // string.drawAtPoint(CGPointMake(49.0, 400.0,f+height),font)
    //[string drawAtPoint:CGPointMake(49.0f, 400.0f+height) withFont:font];
    
    }


}
