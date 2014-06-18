//
//  AchievementViewController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/9/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class AchievementViewController: UIViewController {
    
    var me:FBProfilePictureView=FBProfilePictureView()
    @IBOutlet var personal:UIView
    @IBOutlet var personal_img:UIView
    @IBOutlet var personal_name:UILabel
    override func viewDidLoad() {
        super.viewDidLoad()
        me.profileID=UserData.fb_id
        personal_name.text=UserData.name
        me.frame=CGRectMake(0, 0, 100, 100)
        personal_img.layer.masksToBounds=true
        personal_img.layer.cornerRadius=50
        personal_img.addSubview(me)
        var fullScreenBounds:CGRect=UIScreen.mainScreen().bounds
        var scrollView:UIScrollView=UIScrollView()
        scrollView.frame=CGRectMake(0, 0, fullScreenBounds.size.width, fullScreenBounds.size.height)
        scrollView.bounces=false
        scrollView.contentSize = CGSizeMake(fullScreenBounds.size.width, 1000)
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        personal.layer.cornerRadius = 6
        personal.layer.masksToBounds=true
        var distanceView:DistanceView=DistanceView(frame: self.view.bounds)
        //distanceView.frame=self.view.bounds
        var newFrame:CGRect = distanceView.frame;
        newFrame.size.width = fullScreenBounds.size.width;
        newFrame.size.height = 2000;
        distanceView.frame=newFrame
        scrollView.addSubview(distanceView)
        distanceView.addSubview(personal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
