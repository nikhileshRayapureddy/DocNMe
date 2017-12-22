//
//  ViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 31/07/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import SideMenuController

class ViewController: SideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "add")
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 300
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
//        self.loginresponse=LoginResponse();
        super.init(coder: aDecoder)
    }
}

