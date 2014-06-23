//
//  MainRunViewController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/5/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation

protocol MapViewControllerDelegate {
    
    func returnedRegion( region:CLCircularRegion )
    
}

class MainRunViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,FBLoginViewDelegate {
    
    @IBOutlet var locate:UIButton
    @IBOutlet var btn_run:UIButton
    @IBOutlet var txt_distance:UILabel
    @IBOutlet var txt_runTime:UILabel
    @IBOutlet var info_view:UIView
    @IBOutlet var mapView : MKMapView
    @IBOutlet var speed_info:UILabel
    @IBOutlet var average_info:UILabel
    @IBOutlet var speed_view:UIView
    @IBOutlet var controll:UIView
    @IBOutlet var pause:UIButton
    @IBOutlet var stop:UIButton
    @IBOutlet var go:UILabel
    @IBOutlet var kal_view:UIView
    @IBOutlet var kal_info:UILabel
    let locationManager:CLLocationManager=CLLocationManager();
    var delegate : MapViewControllerDelegate? = nil
    var loc:CLLocation=CLLocation()
    var old:CLLocation=CLLocation()
    var routeLineView:MKPolylineView=MKPolylineView()
    var routeLine:MKPolyline=MKPolyline()
    var flag = false
    var count = 0
    var distance:CDouble?=0
    var run_timer: NSTimer!
    var upload_timer: NSTimer!
    var high_speed = 0
    var kal = 0.0
    var bool_pause = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial UI
        info_view.hidden=true
        controll.hidden=true
        speed_view.hidden=true
        info_view.hidden=true
        kal_view.hidden=true
        distance = 0
        count = 0
        high_speed = 0
        kal=0.0
        bool_pause=false
        
        //setup location
        self.mapView.delegate=self
        mapView.showsUserLocation=false
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.startUpdatingLocation();
    
        //determine whether you login
        if FBSession.activeSession().isOpen {
            println("map login")
            for var i=0;i<UserData.getFriendID().count;i++ {
                var annotation:MKPointAnnotation=MKPointAnnotation()
                var coor:CLLocationCoordinate2D=UserData.getFriendLoc()[i]
                annotation.coordinate = coor;
                //println(coor.latitude)
                annotation.title=UserData.getFriendName().objectAtIndex(i) as String
                if coor.longitude != 0.0 && coor.latitude != 0.0 {
                    mapView.addAnnotation(annotation)
                }
            }
        }
        getAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_manager: CLLocationManager!,
        didUpdateToLocation newLocation: CLLocation!,
        fromLocation oldLocation: CLLocation!)
    {
        //setup showUser
        if mapView.showsUserLocation==true {
            var mapSpan=MKCoordinateSpan(latitudeDelta:0.005,longitudeDelta:0.005);
            
            var region=MKCoordinateRegion(center: newLocation.coordinate, span: mapSpan)
            mapView.setRegion(region,animated:true)
            
        }
        
        //if user is running
        if flag  {
            //add distance
            var dis:CLLocationDistance?=newLocation.distanceFromLocation(oldLocation)
            if dis<13 {
                let d:Double?=distance;
                let k = 60 * (Double(dis!) / 1000 * 1.036)
                println(k)
                kal = Double(kal) + Double(k)
                kal_info.text = String(Int(kal))
                let speed=Double(d!)/Double(count+1)
                distance = distance! + dis!
                if Double(high_speed) < Double(dis!) {
                    high_speed = Int(dis!)
                    let diss:Double?=dis;
                    speed_info.text = String(Int(diss!))
                    //kal_info.text = String()
                }
                txt_distance.text = String(Int(d!))
                average_info.text = String(Int(speed))
                
                //if location is not eqal 0, it has annotation
                if old.coordinate.longitude != 0.0 && old.coordinate.latitude != 0.0 {
                    var locations = [CLLocation(latitude:newLocation.coordinate.latitude,longitude:newLocation.coordinate.longitude),CLLocation(latitude:old.coordinate.latitude,longitude:old.coordinate.longitude)]
                    var coordinates = locations.map({ (location: CLLocation) ->
                        CLLocationCoordinate2D in
                        return location.coordinate
                        })
                    var polyline = MKPolyline(coordinates: &coordinates,
                        count: locations.count)
                    mapView.addOverlay(polyline)
                }
            }
            old=newLocation
        }
    }
    
    //what will happen when u click annotation
    func mapView(mapView: MKMapView!,
        didSelectAnnotationView view: MKAnnotationView!) {
            for var i = 0;i<UserData.getFriendID().count;i++ {
                if view.annotation.title == UserData.getFriendName()?.objectAtIndex(i) as NSString {
                    SCLAlertView().showSuccess(self, title: UserData.getFriendName().objectAtIndex(i) as String, img: UserData.getFriendImg().objectAtIndex(i) as UIImage, id:UserData.getFriendID().objectAtIndex(i) as String)
                }
            }
    }
    
    //drawline on map
    func mapView(mapView: MKMapView!,
        rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!{
            
        var circleRenderer = MKPolylineRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor(red:(0/255.0), green:70/255.0, blue:255/255.0, alpha:1)
        circleRenderer.lineWidth=3
        return circleRenderer
    }
    
    //button that location or not
    @IBAction func loc(sender : AnyObject){
        getAudio()
        if mapView.showsUserLocation==true {
            mapView.showsUserLocation=false
        }
        else {
            mapView.showsUserLocation=true
            
        }
    }
    
    //setup all the annotation attribute
    func mapView(mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            var pinView:MKPinAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"annotation")
            for var i = 0;i<UserData.getFriendID().count;i++ {
                if annotation.title == UserData.getFriendName()?.objectAtIndex(i) as NSString {
                    var image:UIImage=UserData.getFriendImg()?.objectAtIndex(i) as UIImage
                    var imageView:UIImageView=UIImageView(image:image)
                    imageView.frame = CGRectMake(0, 0, 30, 30);
                    imageView.layer.cornerRadius=15;
                    imageView.layer.masksToBounds = true;
                    pinView.image = nil;
                    pinView.frame = CGRectMake(0, 0, 30, 30);
                    pinView.rightCalloutAccessoryView = imageView;
                    var pinView1:MKPinAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"annotation")
                    pinView1.image=nil;
                    pinView.addSubview(imageView)
                    pinView.addSubview(pinView1)

                    return pinView
                }
            }
            return nil
    }
    
    //Run button function
    @IBAction func run(sender : AnyObject){
        if(!flag){
            //add annotation
            var annotation:MKPointAnnotation=MKPointAnnotation()
            var coor:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: old.coordinate.latitude,longitude: old.coordinate.longitude)
            annotation.coordinate = coor;
            annotation.title="起點"
            
            //show where u r
            mapView.addAnnotation(annotation)
            mapView.showsUserLocation=true
            
            //bool that u r running
            flag=true
            
            //UI Change
            info_view.hidden=false
            txt_runTime.text = "00:00"
            txt_distance.text = "0"
            controll.hidden=false
            btn_run.hidden=true
            run_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("time_count"), userInfo: nil, repeats: true)
            upload_timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("loc_upload"), userInfo: nil, repeats: true)
        }
    }
    
    //stop button function
    @IBAction func stop(sender : AnyObject){
        //add annotation
        var annotation:MKPointAnnotation=MKPointAnnotation()
        var coor:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: old.coordinate.latitude,longitude: old.coordinate.longitude)
        annotation.coordinate = coor;
        annotation.title="終點"
        mapView.addAnnotation(annotation)
        
        //bool that u r not running
        flag = false
        
        //UI Change
        run_timer.invalidate()
        upload_timer.invalidate()
        count = 0
        old=CLLocation()
        controll.hidden=true
        btn_run.hidden=false
    }
    
    //pause button function
    @IBAction func pause(sender : AnyObject){
        if !bool_pause {
            run_timer.invalidate()
            upload_timer.invalidate()
            bool_pause=true
            go.text="繼續"
            flag = false;
        }
        else {
            run_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("time_count"), userInfo: nil, repeats: true)
            upload_timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("loc_upload"), userInfo: nil, repeats: true)
            bool_pause=false
            go.text="暫停"
            flag = true
        }
    }
    
    //upload user location to server
    func loc_upload() {
        var post :String="id=\(UserData.uid)&token=\(UserData.token)&newlat=\(old.coordinate.latitude)&newlon=\(old.coordinate.longitude)"
        var json:NSString=UserData.getJSON("user/mod", post: post)
    }
    
    //caluate what time that user has run
    func time_count() {
        var hr = 0
        var min = 0
        var sec = 0
        var time:String?=nil
        if count/3600 > 0 {
            hr = count / 3600
            count %= 3600
        }
        if count/60 > 0 {
            min = count/60
        }
        sec = count%60
        if hr == 0 {
            if min == 0 {
                if sec == 0 {
                    time = "00:00"
                }
                else if sec/10 == 0{
                    time = "00:0\(sec)"
                }
                else {
                    
                    time = "00:\(sec)"
                }
            }
            else if min/10==0{
                if sec == 0 {
                    time = "0\(min):00"
                }
                else if sec/10 == 0{
                    time = "0\(min):0\(sec)"
                }
                else {
                    time = "0\(min):\(sec)"
                }
            }
            else {
                if sec == 0 {
                    time = "\(min):00"
                }
                else if sec/10 == 0{
                    time = "\(min):0\(sec)"
                }
                else {
                    time = "\(min):\(sec)"
                }
            }
        }
        else {
            time = "\(hr):\(min):\(sec)"
        }
        txt_runTime.text=time
        //println(time)
        count++
    }
    
    //get audio data and play
    func getAudio() {
        var error:NSError;
        var post="id="+UserData.uid!+"&token="+UserData.token!
        var json=UserData.getJSON("audio/list", post: post)
        var data=json.dataUsingEncoding(NSUTF8StringEncoding)
        let audio_dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        let audio_json:NSArray = audio_dic["audio"] as NSArray
        for obj : AnyObject in audio_json {
            var fileName:String = obj as String
            var file = false
            for char in fileName
            {
                if char == "a" {
                    file = true
                }
                break
            }
            if(file) {
                println(fileName)
//                var file_data:NSData=UserData.getAudioFile(fileName)
//                var player:AVAudioPlayer = AVAudioPlayer(data:file_data,error:nil)
//                println(file_data)
//                player.play()
            }
        }
        
    }
    
    @IBAction func change_to_speed(sender : AnyObject){
        speed_view.hidden=false
        info_view.hidden=true
        kal_view.hidden=true
    }
    
    @IBAction func change_to_kal(sender : AnyObject) {
        speed_view.hidden=true
        info_view.hidden=true
        kal_view.hidden=false
    }
    
    @IBAction func change_to_info(sender : AnyObject) {
        speed_view.hidden=true
        info_view.hidden=false
        kal_view.hidden=true
    }
    
}













