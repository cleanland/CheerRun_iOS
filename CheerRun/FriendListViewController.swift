//
//  FriendListViewController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/8/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview : UITableView
    var _fbFriendName:NSMutableArray?=NSMutableArray()
    var _fbFriendID:NSMutableArray?=NSMutableArray()
    var _fbFriendImg:NSMutableArray?=NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.reloadData()
        tableview.dataSource = self
        tableview.delegate=self
        tableview.backgroundColor = UIColor.clearColor()
        
        //recomand friend && not your friend
        for var i = 0;i<UserData.getFriendID().count;i++ {
            for var j = 0;j<UserData.getFBFriendID().count;j++ {
                if (UserData.getFBFriendID().objectAtIndex(j) as NSString) == (UserData.getFriendID().objectAtIndex(i) as NSString) {
                    UserData.getFBFriendID().removeObjectAtIndex(j)
                    UserData.getFBFriendName().removeObjectAtIndex(j)
                    UserData.getFBFriendImg().removeObjectAtIndex(j)
                    j=j-1
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!,
        heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
            return 50
    }
    
    func tableView(tableView: UITableView!,
        viewForHeaderInSection sectionIndex: Int) -> UIView! {
            if sectionIndex == 0 {
                var view:UIView = UIView(frame:CGRectMake(0, 0, tableView.frame.size.width, 40))
               
                view.backgroundColor = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha:0.8);
                
                var label:UILabel = UILabel(frame:CGRectMake(10, 3, 0, 0));
                label.text = "RÜN好友";
                label.font = UIFont.systemFontOfSize(15);
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
                label.text = "建議好友";
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
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection sectionIndex: Int) -> Int {
        if sectionIndex == 0 {
            return UserData.getFriendID().count
        }
        else {
            return UserData.getFBFriendID().count
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier : String?="cell"
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            cell.textLabel.text=UserData.getFriendName().objectAtIndex(indexPath.row) as String
            var size:CGSize=CGSize(width: 40,height: 40);
            cell.imageView.image=reSizeImage(UserData.getFriendImg()?.objectAtIndex(indexPath.row)? as UIImage , toSize: size)
            cell.imageView.layer.cornerRadius=20;
            cell.imageView.layer.masksToBounds=true;
            
            //add message btn
            var msg:UIButton = UIButton()
            msg.frame = CGRectMake(250.0, 7.0, 30.0, 30.0)
            msg.tag = indexPath.row
            msg.setBackgroundImage(UIImage(named:"btn_message"), forState: UIControlState.Normal)
            cell.addSubview(msg)
             msg.addTarget(self,action:"sendMessage:",forControlEvents:.TouchUpInside);
            
            //add run icon
            var run:UIButton = UIButton()
            run.frame = CGRectMake(290.0, 7.0, 20.0, 30.0)
            run.setBackgroundImage(UIImage(named:"icon_runningstatus"), forState: UIControlState.Normal)
            cell.addSubview(run)
            //add online icon
//            var online:UIButton = UIButton()
//            online.frame = CGRectMake(200.0, 7.0, 30.0, 30.0)
//            online.setBackgroundImage(UIImage(named:"icon_runningstatus"), forState: UIControlState.Normal)
//            cell.addSubview(online)
            
            
        }
        
        else if indexPath.section == 1 {
            cell.textLabel.text=UserData.getFBFriendName().objectAtIndex(indexPath.row) as String
            var size:CGSize=CGSize(width: 40,height: 40);
            cell.imageView.image=reSizeImage(UserData.getFBFriendImg()?.objectAtIndex(indexPath.row)? as UIImage , toSize: size)
            cell.imageView.layer.cornerRadius=20;
            cell.imageView.layer.masksToBounds=true;
            
            //add mail icon
            var mail:UIButton = UIButton()
            mail.frame = CGRectMake(270.0, 7.0, 30.0, 30.0)
            mail.tag = indexPath.row
            mail.setBackgroundImage(UIImage(named:"btm_invite"), forState: UIControlState.Normal)
            cell.addSubview(mail)
            mail.addTarget(self,action:"AddRequest:"
                ,forControlEvents:.TouchUpInside)
        }
        
        return cell
        
    }
    
    func reSizeImage(image:UIImage ,toSize reSize:CGSize) -> UIImage
    
    {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    image.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
    var reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
    }
    
    @IBAction func sendMessage(sender : AnyObject){
        var btn_id:UIButton = sender as UIButton
        
        SCLAlertView().showSuccess(self, title: UserData.getFriendName().objectAtIndex(btn_id.tag) as String, img: UserData.getFriendImg().objectAtIndex(btn_id.tag) as UIImage, id:UserData.getFriendID().objectAtIndex(btn_id.tag) as String)
    }
    
    @IBAction func AddRequest(sender : AnyObject){
        var btn_id:UIButton = sender as UIButton
        var post :String="id=\(UserData.uid)&token=\(UserData.token)&to=\(UserData.getFBFriendID().objectAtIndex(btn_id.tag) as String)"
        var json:NSString=UserData.getJSON("friend/add", post: post)
        
        UserData.addFriendName(UserData.getFBFriendName().objectAtIndex(btn_id.tag) as String)
        UserData.addFriendID(UserData.getFBFriendID().objectAtIndex(btn_id.tag) as String)
        UserData.addFriendImg(UserData.getFBFriendImg().objectAtIndex(btn_id.tag) as UIImage)
        UserData.getFBFriendID().removeObjectAtIndex(btn_id.tag)
        UserData.getFBFriendName().removeObjectAtIndex(btn_id.tag)
        UserData.getFBFriendImg().removeObjectAtIndex(btn_id.tag)
        tableview.reloadData()

    }
    
    
}
