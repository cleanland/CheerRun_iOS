//
//  MainTabController.swift
//  CheerRun
//
//  Created by Andy Chen on 6/11/14.
//  Copyright (c) 2014 Andy chen. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tabBarController(tabBarController: UITabBarController!,
        didSelectViewController viewController: UIViewController!)
    {
        println(tabBarController.selectedIndex)
        if tabBarController.selectedIndex == 0
        {
            viewController.tabBarItem.setFinishedSelectedImage(UIImage(named:"icon_map_lime"), withFinishedUnselectedImage: UIImage(named:"icon_map_grey"))
        }
    }

}
