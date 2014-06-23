//
//  UserData.swift
//  CheerRun
//
//  Created by Andy Chen on 6/8/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import Foundation

var _fb_id:String?=nil
var _uid:String?=nil
var _name:String?=nil
var _token:String?=nil
var _photourl:String?=nil
var _friendName:NSMutableArray?=NSMutableArray()
var _friendID:NSMutableArray?=NSMutableArray()
var _friendImg:NSMutableArray?=NSMutableArray()
var _friendImg_data:NSMutableArray?=NSMutableArray()
var _friendLoc:CLLocationCoordinate2D[] = []
var _fbFriendName:NSMutableArray?=NSMutableArray()
var _fbFriendID:NSMutableArray?=NSMutableArray()
var _fbFriendImg:NSMutableArray?=NSMutableArray()
var _server="http://localhost:1134/"
//var _server="http://lospot.tw:1134/"
//var _server="http://140.138.5.197:1134/" //社辦電腦

class UserData: NSObject {
    
    
    class var fb_id:String?
    {
        set (newValue){
            _fb_id = newValue
        }
        get {
            return _fb_id
        }
    }
    
    class var uid:String?
    {
        set (newValue){
            _uid = newValue
        }
        get {
            return _uid
        }
    }
    
    class var name:String?
    {
        set (newValue){
            _name = newValue
        }
        get {
            return _name
        }
    }
    
    class var token:String?
    {
        set (newValue){
        _token = newValue
        }
        get {
            return _token
        }
    }
    class var photourl:String?
    {
        set (newValue){
        _photourl = newValue
        }
        get {
            return _photourl
        }
    }
    
    class func addFriendName(name:String)
    {
        _friendName?.addObject(name)
    }
    
    class func addFriendID(id:String)
    {
        _friendID?.addObject(id)
    }
    
    class func addFriendImg(img:UIImage)
    {
        _friendImg?.addObject(img)
    }
    
    class func addFriendLoc(loc:CLLocationCoordinate2D)
    {
        _friendLoc+=loc
    }
    
    class func addFBFriendName(name:String)
    {
        _fbFriendName?.addObject(name)
    }
    
    class func addFBFriendID(id:String)
    {
        _fbFriendID?.addObject(id)
    }
    
    class func addFBFriendImg(img:UIImage)
    {
        _fbFriendImg?.addObject(img)
    }

    class func getFriendName() -> NSMutableArray!
    {
        return _friendName
    }
    
    class func getFriendID() -> NSMutableArray!
    {
        return _friendID
    }
    
    class func getFriendImg() -> NSMutableArray!
    {
        return _friendImg
    }
    
    class func getFriendLoc() -> CLLocationCoordinate2D[]!
    {
        return _friendLoc
    }
    
    class func getFBFriendName() -> NSMutableArray!
    {
        return _fbFriendName
    }
    
    class func getFBFriendID() -> NSMutableArray!
    {
        return _fbFriendID
    }
    
    class func getFBFriendImg() -> NSMutableArray!
    {
        return _fbFriendImg
    }
    
    class func getFriendCount() -> Int!
    {
        return _friendID?.count
    }
    
    class func getJSON(api:String,post:String) -> NSString!{
        var url:NSURL=NSURL(string:_server+api)
        var request:NSMutableURLRequest=NSMutableURLRequest(URL: url)
        request.HTTPMethod="POST"
        var data:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody=data
        var recieve:NSData?=NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        var json:NSString?=NSString(data:recieve, encoding: NSUTF8StringEncoding)
        return json
    }
    
//    class func getAudioFile(fileName:String) -> NSData!{
//        var file_post = "id="+UserData.uid!+"&token="+UserData.token!+"&file="+fileName
//        var url:NSURL=NSURL(string:_server+"audio/down")
//        var request:NSMutableURLRequest=NSMutableURLRequest(URL:url)
//        request.HTTPMethod="POST"
//        
//        var data:NSData = file_post.dataUsingEncoding(NSUTF8StringEncoding)
//        request.HTTPBody=data
//        var file_data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//        return file_data
//    }
    
    class func uploadBinary(binary:NSData, withURL urlAddress:NSString, _to to:NSString, andFilename filename:NSString){
        
        var theURL:NSURL = NSURL.URLWithString(_server + urlAddress)
        var theRequest:NSMutableURLRequest?=NSMutableURLRequest(URL:theURL)
        
        theRequest!.HTTPMethod = "POST"
        var boundary:NSString = "---------------------------14737809831466499882746641449";
        var contentType:NSString = "multipart/form-data; boundary=" + boundary
        theRequest!.addValue(contentType, forHTTPHeaderField:"Content-Type")
        var theBodyData:NSMutableData = NSMutableData.data()
        theBodyData.appendData(("\r\n--"+boundary+"\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("Content-Disposition: form-data; name=\"id\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("\(UserData.uid)").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("\r\n--"+boundary+"\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("Content-Disposition: form-data; name=\"token\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("\(UserData.token)").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("\r\n--"+boundary+"\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("Content-Disposition: form-data; name=\"to\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(to.dataUsingEncoding(NSUTF8StringEncoding))
        
        theBodyData.appendData(("\r\n--"+boundary+"\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("Content-Disposition: form-data; name=\"file\"; filename=\"RecordedFile\"\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(("Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theBodyData.appendData(NSData.dataWithData(binary))
        theBodyData.appendData(("\r\n--"+boundary+"--\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        theRequest!.HTTPBody=theBodyData
        let request = theRequest!
        var update_received:NSData = NSURLConnection.sendSynchronousRequest(theRequest, returningResponse: nil, error: nil)
        
        var update_json:NSString = NSString(data:update_received,encoding:NSUTF8StringEncoding)
        
        // NSLog(@"upload_file_json=%@",body);
        NSLog("get_json=%@",update_json);
        //[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    }
    
    class func saveSettings()
    {
        println("save")
        var userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        for var j = 0;j<_friendID?.count;j++
        {
            _friendImg_data?.addObject(UIImageJPEGRepresentation(_friendImg?.objectAtIndex(j) as UIImage, 1.0))
        }
        userDefaults.setObject(_friendImg_data, forKey:"friendImg_data")
        userDefaults.setObject(_friendID, forKey:"friendID")
        userDefaults.setObject(_friendName, forKey:"friendName")
        //userDefaults.setInteger(_userDistance, forKey:"userDistance")
        userDefaults.synchronize()
    }
    
    class func getSettings()
    {
        var userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        
        _friendName=NSMutableArray()
        _friendID=NSMutableArray()
        _friendImg=NSMutableArray()
        _friendImg_data=NSMutableArray()
        _friendImg_data = userDefaults.objectForKey("friendImg_data") as? NSMutableArray
        _friendName = userDefaults.objectForKey("friendName") as? NSMutableArray
        _friendID = userDefaults.objectForKey("friendID") as? NSMutableArray
        //userDistance = [userDefaults integerForKey:@"userDistance"];
        println("cc=\(_friendID?.count)")
        for var j = 0;j<_friendID?.count;j++
        {
            var img:UIImage=UIImage(data:_friendImg_data?.objectAtIndex(j) as NSData)
            _friendImg?.addObject(img)
        }
    }
    
    class func clearSettings()
    {
        _friendImg?.removeAllObjects()
        _friendImg_data?.removeAllObjects()
        _friendID?.removeAllObjects()
        _friendName?.removeAllObjects()
        _fb_id=nil
        _uid=nil
        _name=nil
        _token=nil
        _photourl=nil
    }
}
