//
//  SCLAlertView.swift
//  SCLAlertView Example
//
//  Created by Viktor Radchenko on 6/5/14.
//  Copyright (c) 2014 Viktor Radchenko. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// Pop Up Styles
enum SCLAlertViewStyle: Int {
    case Success
    case Error
    case Notice
    case Warning
    case Info
}

// Allow alerts to be closed/renamed in a chainable manner
// Example: SCLAlertView().showSuccess(self, title: "Test", subTitle: "Value").Close()
class SCLAlertViewClose {
    let alertview: SCLAlertView
    
    // Initialisation and Title/Subtitle/Close functions
    init(alertview: SCLAlertView) { self.alertview = alertview }
    func setTitle(title: String) { self.alertview.labelView.text = title; }
    func setSubTitle(subTitle: String) { self.alertview.labelViewDescription.text = subTitle; }
    func Close() { self.alertview.doneButtonAction() }
}

// The Main Class
class SCLAlertView : UIView {
    let kDefaultShadowOpacity: CGFloat = 0.7;
    let kCircleHeight: CGFloat = 56.0;
    let kCircleTopPosition: CGFloat = -12; // Should not be defined here. Make it dynamic
    let kCircleBackgroundTopPosition: CGFloat = -15; // Should not be defined here. Make it dynamic
    let kCircleHeightBackground: CGFloat = 62.0;
    let kCircleIconHeight: CGFloat = 20.0;
    let kWindowWidth: CGFloat = 240.0;
    let kWindowHeight: CGFloat = 228.0;
    
    // Font
    let kDefaultFont: NSString = "HelveticaNeue"
    
    // Members declaration
    var labelView: UILabel
    var labelViewDescription: UILabel
    var shadowView: UIView
    var contentView: UIView
    var circleView: UIView
    var circleViewBackground: UIView
    var circleIconImageView: UIImageView
    var doneButton: UIButton
    var recordButton: UIButton
    var rootViewController: UIViewController
    var durationTimer: NSTimer!
    var per_img:UIImageView
    var uid:String
    var progress:UIProgressView
    var count = 15
    var record_timer: NSTimer!
    var record:Bool = false
    var recorder:AVAudioRecorder
    var recordedFile:NSURL
    var bundle = NSBundle.mainBundle().resourcePath
    var time_txt: UILabel
    
    init () {
        // Content View
        record = false
        recordedFile = NSURL(fileURLWithPath:bundle+"/lll.aac")
        var recordersetting:NSMutableDictionary = NSMutableDictionary()
        recordersetting.setValue(kAudioFormatMPEG4AAC, forKey: AVFormatIDKey)
        recorder = AVAudioRecorder(URL:recordedFile, settings: recordersetting, error :nil)
        self.contentView = UIView(frame: CGRectMake(0, kCircleHeight / 4, kWindowWidth, kWindowHeight))
        self.contentView.backgroundColor = UIColor(white: 1, alpha: 1);
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = true;
        self.contentView.layer.borderWidth = 0.5;
        
        // Circle View
        self.circleView = UIView(frame: CGRectMake(kWindowWidth / 2 - kCircleHeight / 2, kCircleTopPosition, kCircleHeight, kCircleHeight))
        self.circleView.layer.cornerRadius =  self.circleView.frame.size.height / 2;
        
        // Circle View Background
        
        self.circleViewBackground = UIView(frame: CGRectMake(kWindowWidth / 2 - kCircleHeightBackground / 2, kCircleBackgroundTopPosition, kCircleHeightBackground, kCircleHeightBackground))
        self.circleViewBackground.layer.cornerRadius =  self.circleViewBackground.frame.size.height / 2;
        self.circleViewBackground.backgroundColor = UIColor.whiteColor()
        
        // Circle View Image
        self.circleIconImageView = UIImageView(frame: CGRectMake(kCircleHeight / 2 - kCircleIconHeight / 2, kCircleHeight / 2 - kCircleIconHeight / 2, kCircleIconHeight, kCircleIconHeight))
        self.circleView.addSubview(self.circleIconImageView)
        
        //uid
        self.uid = String()
        
        // Title
        self.labelView = UILabel(frame: CGRectMake(0, 140, kWindowWidth , 20))
        self.labelView.numberOfLines = 1
        self.labelView.textAlignment = NSTextAlignment.Center
        self.labelView.font = UIFont(name: kDefaultFont, size: 20)
        self.contentView.addSubview(self.labelView)
        
        // Subtitle
        self.labelViewDescription = UILabel(frame: CGRectMake(12, 84, kWindowWidth - 24, 80))
        self.labelViewDescription.numberOfLines = 3
        self.labelViewDescription.textAlignment = NSTextAlignment.Center
        self.labelViewDescription.font = UIFont(name: kDefaultFont, size: 14)
        self.contentView.addSubview(self.labelViewDescription)
        
        //time_txt
        self.time_txt = UILabel(frame:CGRectMake(kWindowWidth-30, 20, 30, 20))
        self.time_txt.numberOfLines = 1
        self.time_txt.font = UIFont(name:kDefaultFont, size: 18)
        self.contentView.addSubview(self.time_txt)
        
        // progress
        self.progress = UIProgressView(frame:CGRectMake(0,40,kWindowWidth,20))
        self.progress.progressViewStyle=UIProgressViewStyle.Default
        self.contentView.addSubview(self.progress)
        
        //personal Image
        self.per_img = UIImageView(frame: CGRectMake(kWindowWidth/2-50, 20, 100, 100))
        self.per_img.layer.masksToBounds = true
        self.per_img.layer.cornerRadius=50
        self.contentView.addSubview(self.per_img)
        
        // Shadow View
        self.shadowView = UIView(frame: UIScreen.mainScreen().bounds)
        self.shadowView.backgroundColor = UIColor.blackColor()
        
        // Done Button
        self.doneButton = UIButton(frame: CGRectMake(7, kWindowHeight - 52, (kWindowWidth - 24)/2, 40))
        self.doneButton.layer.cornerRadius = 3
        self.doneButton.layer.masksToBounds = true
        self.doneButton.setTitle("Done", forState: UIControlState.Normal)
        self.doneButton.titleLabel.font = UIFont(name: kDefaultFont, size: 14)
        self.contentView.addSubview(self.doneButton)
        
        //recondButton
        self.recordButton = UIButton(frame: CGRectMake((kWindowWidth - 24)/2+17, kWindowHeight - 52, (kWindowWidth - 24)/2, 40))
        self.recordButton.layer.cornerRadius = 3
        self.recordButton.layer.masksToBounds = true
        self.recordButton.setTitle("Record", forState: UIControlState.Normal)
        self.recordButton.titleLabel.font = UIFont(name: kDefaultFont, size: 14)
        self.contentView.addSubview(self.recordButton)
        
        // Root view controller
        self.rootViewController = UIViewController()
        
        // Superclass initiation
        super.init(frame: CGRectMake(((320 - kWindowWidth) / 2), 0 - kWindowHeight, kWindowWidth, kWindowHeight))
        
        // Show notice on screen
        self.addSubview(self.contentView)
        self.addSubview(self.circleViewBackground)
        self.addSubview(self.circleView)
        
        // Colours
        self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF)
        self.labelView.textColor = UIColorFromRGB(0x4D4D4D)
        self.labelViewDescription.textColor = UIColorFromRGB(0x4D4D4D)
        self.contentView.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor
        
        // On complete.
        self.doneButton.addTarget(self, action: Selector("doneButtonAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.recordButton.addTarget(self, action: Selector("RecordAction"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // showTitle(view, title, subTitle, style)
    func showTitle(view: UIViewController, title: String, img: UIImage, id:String,style: SCLAlertViewStyle) -> SCLAlertViewClose {
        return showTitle(view, title: title, img: img, id:id,duration: 2000.0, completeText: nil, style: style)
    }
    
    // showSuccess(view, title, subTitle)
    func showSuccess(view: UIViewController, title: String, img: UIImage, id:String) -> SCLAlertViewClose {
        return showTitle(view, title: title, img: img, id:id, duration: 2000.0, completeText: nil, style: SCLAlertViewStyle.Success);
    }
    
    
    func showRecord(view: UIViewController) {
        self.alpha = 0;
        self.time_txt.hidden = false
        self.time_txt.text="15"
        self.rootViewController = view
        self.rootViewController.view.addSubview(self.shadowView)
        self.rootViewController.view.addSubview(self)
        self.doneButton.setTitle("Cancel", forState: UIControlState.Normal)
        self.recordButton.setTitle("Done", forState: UIControlState.Normal)
        var viewColor: UIColor = UIColor()
        var iconImageName: NSString = ""
        viewColor = UIColorFromRGB(0x22B573);
        iconImageName = "notification-success"
        self.labelView.text = ""
        self.per_img.image = nil
        self.doneButton.backgroundColor = viewColor;
        self.recordButton.backgroundColor = viewColor;
        self.circleView.backgroundColor = viewColor;
        self.circleIconImageView.image = UIImage(named: iconImageName)
        UIView.animateWithDuration(0.2, animations: {
            self.shadowView.alpha = self.kDefaultShadowOpacity
            self.frame.origin.y = self.rootViewController.view.center.y - 100;
            self.alpha = 1;
            }, completion: { finished in
                UIView.animateWithDuration(0.2, animations: {
                    self.center = self.rootViewController.view.center;
                    }, completion: { finished in })
        })
        
        recorder.prepareToRecord()
        recorder.record()
    }
    
    // showTitle(view, title, subTitle, duration, style)
    func showTitle(view:UIViewController, title: String, img: UIImage,id:String, duration: NSTimeInterval?, completeText: String?, style: SCLAlertViewStyle) -> SCLAlertViewClose {
        self.alpha = 0;
        self.rootViewController = view
        self.rootViewController.view.addSubview(self.shadowView)
        self.rootViewController.view.addSubview(self)
        
        // Complete text
        if(completeText != nil) {
            self.doneButton.setTitle(completeText, forState: UIControlState.Normal)
            self.recordButton.setTitle(completeText, forState: UIControlState.Normal)
        }
        
        // Alert colour/icon
        var viewColor: UIColor = UIColor()
        var iconImageName: NSString = ""
        
        // Icon style
        switch(style) {
            case SCLAlertViewStyle.Success:
                viewColor = UIColorFromRGB(0x22B573);
                iconImageName = "notification-success"
            
            case SCLAlertViewStyle.Error:
                viewColor = UIColorFromRGB(0xC1272D);
                iconImageName = "notification-error"
            
            case SCLAlertViewStyle.Notice:
                viewColor = UIColorFromRGB(0x727375)
                iconImageName = "notification-notice"
            
            case SCLAlertViewStyle.Warning:
                viewColor = UIColorFromRGB(0xFFD110);
                iconImageName = "notification-warning"
            
            case SCLAlertViewStyle.Info:
                viewColor = UIColorFromRGB(0x2866BF);
                iconImageName = "notification-info"
            
            default:
                println("default")
        }
        
        // Title
        if ((title as NSString).length > 0 ) {
            self.labelView.text = title;
        }
        self.time_txt.text=""
        self.time_txt.hidden = true
        self.uid = id
        self.per_img.image = img
        self.progress.hidden = true
        // Alert view colour and images
        
        self.doneButton.backgroundColor = viewColor;
        self.recordButton.backgroundColor = viewColor;
        self.circleView.backgroundColor = viewColor;
        self.circleIconImageView.image = UIImage(named: iconImageName)
        
        // Adding duration
        if (duration != nil && duration > 0) {
            durationTimer?.invalidate()
            durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration!, target: self, selector: Selector("hideView"), userInfo: nil, repeats: false)
        }
        
        // Animate in the alert view
        UIView.animateWithDuration(0.2, animations: {
            self.shadowView.alpha = self.kDefaultShadowOpacity
            self.frame.origin.y = self.rootViewController.view.center.y - 100;
            self.alpha = 1;
        }, completion: { finished in
            UIView.animateWithDuration(0.2, animations: {
                self.center = self.rootViewController.view.center;
            }, completion: { finished in })
        })
        
        // Chainable objects
        return SCLAlertViewClose(alertview: self)
    }
    
    // When click 'Done' button, hide view.
    func doneButtonAction() { hideView(); }
    
    func RecordAction() {
        
        if record {
            recorder.stop()
            
            var tileDirectory:String = (NSBundle.mainBundle().resourcePath) + "/lll.aac"
            var fileContent = NSData.dataWithContentsOfFile(tileDirectory, options: .DataReadingMappedIfSafe, error: nil)
            UserData.uploadBinary(fileContent, withURL: "audio/up", _to: self.uid, andFilename: "lll.aac")
            record_timer.invalidate()
            hideView()
        }
        else {
            record=true
            count = 15
            self.progress.hidden = false
            record_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("time_count"), userInfo: nil, repeats: true)
            showRecord(self.rootViewController)
        }
    }
    
    func time_count() {
        count--
        progress.progress = 1 - (Float(count) / 15)
        time_txt.text = "\(count)"
        if count == 0 {
            record_timer.invalidate()
            println("timeout")
            recorder.stop()
            var tileDirectory:String = (NSBundle.mainBundle().resourcePath) + "/lll.aac"
            var fileContent = NSData.dataWithContentsOfFile(tileDirectory, options: .DataReadingMappedIfSafe, error: nil)
            UserData.uploadBinary(fileContent, withURL: "audio/up", _to: self.uid, andFilename: "lll.aac")
            hideView()
        }
    }
    
    
    // Close SCLAlertView
    func hideView() {
        UIView.animateWithDuration(0.2, animations: {
            self.shadowView.alpha = 0;
            self.alpha = 0;
        }, completion: { finished in
            self.shadowView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    // Helper function to convert from RGB to UIColor
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}