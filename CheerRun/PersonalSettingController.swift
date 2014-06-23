//
//  PersonalSettingController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/19/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class PersonalSettingController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableview : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!,
        didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    func tableView(tableView: UITableView!,
        heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
            return 60
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cellIdentifier : String?="cell"
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if indexPath.row == 0 {
            cell.text = "測量單位"
            var item = ["英制","公制"]
            var unit:UISegmentedControl = UISegmentedControl(items:item)
            unit.selectedSegmentIndex=0
            unit.frame = CGRectMake(150.0,15, 80.0, 30.0)
            unit.tag = indexPath.row
            unit.backgroundColor = UIColor.whiteColor()
            cell.addSubview(unit)
        } else if indexPath.row == 1 {
            cell.text = "身高"
            var height:UITextField = UITextField()
            height.frame = CGRectMake(150.0, 7.0, 60.0, 30.0)
            height.backgroundColor = UIColor.blueColor()
            height.returnKeyType=UIReturnKeyType.Done
            height.keyboardType = UIKeyboardType.NumberPad
            height.tag = indexPath.row
            cell.addSubview(height)
            var t_txt:UILabel = UILabel()
            t_txt.text = "cm"
            t_txt.frame = CGRectMake(210,7,40,30)
            cell.addSubview(t_txt)
        } else if indexPath.row == 2 {
            cell.text = "體重"
            var weight:UITextField = UITextField()
            weight.frame = CGRectMake(150.0, 7.0, 60.0, 30.0)
            weight.tag = indexPath.row
            weight.backgroundColor = UIColor.blueColor()
            weight.returnKeyType=UIReturnKeyType.Done
            weight.keyboardType = UIKeyboardType.NumberPad
            cell.addSubview(weight)
            var t_txt:UILabel = UILabel()
            t_txt.text = "kg"
            t_txt.frame = CGRectMake(210,7,40,30)
            cell.addSubview(t_txt)
        } else if indexPath.row == 3 {
            cell.text = "性別"
            var item = ["男","女"]
            var gender:UISegmentedControl = UISegmentedControl(items:item)
            gender.selectedSegmentIndex=0
            gender.frame = CGRectMake(150.0, 15.0, 80.0, 30.0)
            gender.tag = indexPath.row
            gender.backgroundColor = UIColor.whiteColor()
            cell.addSubview(gender)
        }
        return cell
        
    }

}
