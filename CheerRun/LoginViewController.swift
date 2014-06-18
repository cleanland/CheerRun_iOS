//
//  LoginViewController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/5/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

//import FacebookSDK

class LoginViewController: UIViewController,FBLoginViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet var scrollView:UIScrollView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var fullScreenBounds:CGRect = UIScreen.mainScreen().bounds
        var loginView=FBLoginView(readPermissions: ["public_profile","email"])
        loginView.frame=CGRectMake(fullScreenBounds.width/2-loginView.frame.width/2, 400, loginView.frame.width, loginView.frame.height)
        loginView.delegate=self
        
        // Do any additional setup after loading the view.
        var model1:IntroModel = IntroModel(title:"哈囉" ,description:"歡迎使用這款App", image:"image1.jpg")
        
        var model2:IntroModel = IntroModel(title:"紀錄" ,description:"這款App可以幫您紀錄您的跑步過程的點點滴滴", image:"image2.jpg")
        
        var model3:IntroModel = IntroModel(title:"加油打氣", description:"看到朋友辛苦跑步想為他加油打氣嗎?\n 輕鬆為您傳遞加油訊息!" ,image:"image3.jpg")
        
        self.view = IntroControll(frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), pages:[model1, model2, model3])
        self.view.addSubview(loginView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginView(loginView:FBLoginView,
        handleError error:NSError){
            
    }
    
    
    func loginViewFetchedUserInfo(loginView:FBLoginView,
        user fb_user:FBGraphUser){
           
            UserData.fb_id=fb_user.objectID
            UserData.name=fb_user.name
            var post :String="type=facebook&accessToken="+FBSession.activeSession().accessTokenData.accessToken
            var json:NSString=UserData.getJSON("user/login", post: post)
            if json != "" {
                //UserData.getSettings()
                var data:NSData?=json.dataUsingEncoding(NSUTF8StringEncoding)
                var login_dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
                let token_info:String? = login_dic.objectForKey("token") as? String
                let uid_info:Int? = login_dic.objectForKey("id") as? Int
                let photo_info:String? = login_dic.objectForKey("photourl") as? String
                UserData.token=token_info
                UserData.uid="\(uid_info)"
                UserData.photourl=photo_info
                NSLog("token=%@",UserData.token!)
                post="id="+UserData.uid!+"&token="+UserData.token!
                json=UserData.getJSON("friend/list", post: post)
                NSLog("json=%@",json)
                data=json.dataUsingEncoding(NSUTF8StringEncoding)
                let friend_dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                let friend_json:NSArray = friend_dic["friend"] as NSArray
                
                println("count=\(UserData.getFriendID().count),new=\(friend_json.count)")
                if UserData.getFriendID().count != friend_json.count
                {
                    UserData.clearSettings()
                    UserData.fb_id=fb_user.objectID
                    UserData.name=fb_user.name
                    UserData.token=token_info
                    UserData.uid="\(uid_info)"
                    UserData.photourl=photo_info
                    for obj : AnyObject in friend_json {
                        var n :Int=Int(obj as NSNumber)
                        if n > 0 {
                            post="id=\(UserData.uid!)&token=\(UserData.token!)&queryid=\(n)"
                            var friend_json=UserData.getJSON("user/info", post: post)
                            println(friend_json)
                            var friend_data=friend_json.dataUsingEncoding(NSUTF8StringEncoding)
                            var friend_dic=NSJSONSerialization.JSONObjectWithData(friend_data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
                            let valid:Bool? = friend_dic.objectForKey("valid").boolValue as? Bool
                            if valid == true {
                                let f_id:String? = friend_dic.objectForKey("id").stringValue as? String
                                let f_name:String? = friend_dic.objectForKey("name") as? String
                                let f_photourl:String? = friend_dic.objectForKey("photourl") as? String
                                let f_lat:Double? = friend_dic.objectForKey("lat") as? Double
                                let f_lon:Double? = friend_dic.objectForKey("lon") as? Double
                                
                                UserData.addFriendName(f_name!)
                                UserData.addFriendID(f_id!)
                                var url:NSURL=NSURL(string:f_photourl)
                                UserData.addFriendImg(UIImage(data: NSData(contentsOfURL: url)))
                                if f_lat != nil && f_lon != nil {
                                    UserData.addFriendLoc(CLLocationCoordinate2D(latitude: f_lat!,longitude: f_lon!))
                                }
                                else {
                                    UserData.addFriendLoc(CLLocationCoordinate2D(latitude: 0,longitude: 0))
                                }
                            }
                        }
                    }
                }
                else {
                    for obj : AnyObject in friend_json {
                        var n :Int=Int(obj as NSNumber)
                        if n > 0 {
                            post="id=\(UserData.uid!)&token=\(UserData.token!)&queryid=\(n)"
                            var friend_json=UserData.getJSON("user/info", post: post)
                            println(friend_json)
                            var friend_data=friend_json.dataUsingEncoding(NSUTF8StringEncoding)
                            var friend_dic=NSJSONSerialization.JSONObjectWithData(friend_data, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
                            let valid:Bool? = friend_dic.objectForKey("valid").boolValue as? Bool
                            if valid == true {
                                let f_lat:Double? = friend_dic.objectForKey("lat") as? Double
                                let f_lon:Double? = friend_dic.objectForKey("lon") as? Double
                                if f_lat != nil && f_lon != nil {
                                    UserData.addFriendLoc(CLLocationCoordinate2D(latitude: f_lat!,longitude: f_lon!))
                                }
                                else {
                                    UserData.addFriendLoc(CLLocationCoordinate2D(latitude: 0,longitude: 0))
                                }
                            }
                        }
                    }
                    
                }
                UserData.saveSettings()
                post = "id=\(UserData.uid)&accessToken=\(FBSession.activeSession().accessTokenData.accessToken)"
                json = UserData.getJSON("friend/fb", post: post)
                data=json.dataUsingEncoding(NSUTF8StringEncoding)
                let fb_dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                let fb_json:NSArray = fb_dic["fb_friends"] as NSArray
                println("helo")
                for obj : AnyObject in fb_json {
                    let f_id:String? = obj.objectForKey("user_id").stringValue as? String
                    let f_name:String? = obj.objectForKey("fb_name") as? String
                    let f_photourl:String? = obj.objectForKey("fb_url") as? String
                    UserData.addFBFriendName(f_name!)
                    UserData.addFBFriendID(f_id!)
                    var url:NSURL=NSURL(string:f_photourl)
                    UserData.addFBFriendImg(UIImage(data: NSData(contentsOfURL: url)))
                }
            }
            
            var storyboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            //UIStoryboard storyboardWithName:@"Main" bundle:nil];
            var controller:MainTabController = storyboard.instantiateViewControllerWithIdentifier("maintab") as MainTabController
            self.presentModalViewController(controller, animated: true)
        }
    
    
}
