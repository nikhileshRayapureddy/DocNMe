//
//  HomeNavigationViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 01/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import SwiftHEXColors

class HomeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.tintColor = UIColor(hexString:"#01579B");
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];

//        self.startSyncDispatch();
        // Do any additional setup after loading the view.


    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
//    private func startSyncDispatch() {
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        #Mark Force User to fill the information about the clinic
//        self.checkForInformationAndAsk();
    }

    private func checkForInformationAndAsk() {

        let clin: ClinicDetailResponse? = UserPrefUtil.getClinicResponse();
        if (clin != nil && Utility.needToOpenFill(clin)) {
            let vc: VCSignUP = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_SIGNUP) as! VCSignUP;
            self.present(vc, animated: true, completion: nil);

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Date {

    func getElapsedInterval() -> String {

        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
            "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
            "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
            "\(day)" + " " + "days"
        } else {
            return "Today"

        }

    }
}
