//
//  SettingsViewController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/13/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate,FBLoginViewDelegate{
    
    @IBOutlet var tableview : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var me:FBProfilePictureView=FBProfilePictureView()
        me.profileID=UserData.fb_id
        var view:UIView=UIView(frame:CGRectMake(0, 0, 0, 100.0))
        var name:UILabel=UILabel(frame:CGRectMake(100, 25, 0, 30))
        var weight:UILabel=UILabel(frame:CGRectMake(100, 50, 0, 15))
        me.frame=CGRectMake(20, 20, 60, 60)
        me.layer.masksToBounds = true
        me.layer.cornerRadius = 5
        name.text = "陳鍇嘉";
        name.font = UIFont(name:"Arial-BoldMT",size:20);
        name.backgroundColor = UIColor.clearColor();
        name.textColor = UIColor(red:62/255.0, green:68/255.0 ,blue:75/255.0, alpha:1.0);
        name.sizeToFit();
        weight.text = "男性 ,170 公分, 60 公斤";
        weight.font = UIFont(name:"Arial-BoldMT",size:17);
        weight.backgroundColor =  UIColor.clearColor();
        weight.textColor =  UIColor(red:62/255.0, green:68/255.0, blue:75/255.0, alpha:1.0);
        weight.sizeToFit();
        
        
        view.addSubview(me);
        view.addSubview(name);
        view.addSubview(weight);
        
        
        tableview.reloadData()
        tableview.delegate=self
        tableview.backgroundColor = UIColor.clearColor()
        tableview.tableHeaderView = view
        var singleFingerTap:UITapGestureRecognizer =
            UITapGestureRecognizer(target:self,
                action:Selector("enter_personal_info:"))
        tableview.tableHeaderView.addGestureRecognizer(singleFingerTap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enter_personal_info(recognizer:UITapGestureRecognizer){
        var controller:PersonalSettingController = storyboard.instantiateViewControllerWithIdentifier("personal_info") as PersonalSettingController
        
        self.navigationController.pushViewController(controller,
        animated: true)
        
    }
    
    func tableView(tableView: UITableView!,
        didSelectRowAtIndexPath indexPath: NSIndexPath!) {
            var cellView:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath);
            
            if indexPath.section == 0
            {
                if (cellView.accessoryType == UITableViewCellAccessoryType.None) {
                    cellView.accessoryType=UITableViewCellAccessoryType.Checkmark;
                }
                else {
                    cellView.accessoryType = UITableViewCellAccessoryType.None;
                    tableView.deselectRowAtIndexPath(indexPath, animated:true);
                }
            } else if indexPath.section == 1 {
                if (cellView.accessoryType == UITableViewCellAccessoryType.None) {
                    cellView.accessoryType=UITableViewCellAccessoryType.Checkmark;
                }
                else {
                    cellView.accessoryType = UITableViewCellAccessoryType.None;
                    tableView.deselectRowAtIndexPath(indexPath, animated:true);
                }
            } else if indexPath.section == 2 && indexPath.row == 3
            {
                FBSession.activeSession().closeAndClearTokenInformation()
                var storyboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                UserData.clearSettings()
                var controller:LoginViewController = storyboard.instantiateViewControllerWithIdentifier("login") as LoginViewController
                self.presentModalViewController(controller, animated: true)
            }
    }
    
    func tableView(tableView: UITableView!,
        heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
            return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView!,
        viewForHeaderInSection sectionIndex: Int) -> UIView! {
            if sectionIndex == 0 {
                var view:UIView = UIView(frame:CGRectMake(0, 0, tableView.frame.size.width, 40))
                
                view.backgroundColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:0.8);
                
                var label:UILabel = UILabel(frame:CGRectMake(10, 3, 0, 0));
                label.text = "隱私設定";
                label.font = UIFont(name:"Arial-BoldMT",size:15);
                label.textColor = UIColor.whiteColor();
                label.backgroundColor = UIColor.clearColor();
                label.sizeToFit()
                view.addSubview(label);
                return view;
            }
                
            else if sectionIndex == 1{
                var view:UIView = UIView(frame:CGRectMake(0, 0, tableView.frame.size.width, 40))
                
                view.backgroundColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:0.8);
                
                var label:UILabel = UILabel(frame:CGRectMake(10, 3, 0, 0));
                label.text = "推播通知";
                label.font = UIFont.systemFontOfSize(15);
                label.textColor = UIColor.whiteColor();
                label.backgroundColor = UIColor.clearColor();
                label.sizeToFit()
                view.addSubview(label);
                return view;
            }
            else if sectionIndex == 2 {
                var view:UIView = UIView(frame:CGRectMake(0, 0, tableView.frame.size.width, 40))
                
                view.backgroundColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:0.8);
                
                var label:UILabel = UILabel(frame:CGRectMake(10, 3, 0, 0));
                label.text = "關於我們";
                label.font = UIFont.systemFontOfSize(15);
                label.textColor = UIColor.whiteColor();
                label.backgroundColor = UIColor.clearColor();
                label.sizeToFit()
                view.addSubview(label);
                return view;
            }
            else {
                return nil
            }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection sectionIndex: Int) -> Int {
        if sectionIndex == 0 {
            return 3
        }
        else if sectionIndex == 1 {
            return 3
        }
        else {
            return 4
        }
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier : String?="cell"
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if (indexPath.section == 0) {
            var titles = ["所有CheerRÜN會員", "只有朋友", "不公開"];
            cell.textLabel.text = titles[indexPath.row];
            cell.textLabel.font = UIFont(name:"Arial-BoldMT",size:17);
        }
        else if(indexPath.section == 1) {
            var titles = ["朋友邀請","挑戰", "加油聲"];
            cell.textLabel.text = titles[indexPath.row];
        } else if(indexPath.section == 2) {
            var titles = ["關於CheerRÜN", "支援", "版權", "登出"];
            cell.textLabel.text = titles[indexPath.row];
        }
        return cell
        
    }

}
