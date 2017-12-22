//
// Created by Sandeep Rana on 13/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import DatePickerDialog
import Alamofire
import RealmSwift
import AlamofireObjectMapper

class VCSyncSettings: UIViewController, OnSynchronizerStateChanged {

    @IBOutlet weak var segmentedControl: UISegmentedControl!;
    @IBOutlet weak var bDate: UIButton!;
    @IBOutlet weak var bStartSync: UIButton!;
    @IBOutlet weak var lTimeSync: UILabel!;
    @IBOutlet weak var lTimeMonthAppointments: UILabel!;
    @IBOutlet weak var switchPatientCommunication: UISwitch!;
    @IBOutlet weak var iMonthDown: UIButton!;
    @IBOutlet weak var iMinuteDown: UIButton!;

    var monthsInt: Int = 1;

    private let dateFormatter = Utility.getDateFormatter(dateFormat: "dd MMM yyyy");

    @IBAction func onSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
//            patients Since
            self.bDate.isHidden = false;
            break;
        case 1:
            self.bDate.isHidden = true;
            break;
        default:
            self.bDate.isHidden = true;
            break;
        }
    }

    @IBAction func onClickStartSync(_ sender: UIButton) {
//            network/mobile/patients/gynec/search
//        let realm = try? Realm();
//        Synchronizer.syncData(self);

        if segmentedControl.selectedSegmentIndex == 0 {
            if let tex = self.bDate.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if tex == "Date" {
                    Toast(text: "Please select date first!").show();
                    return;
                } else {
                    let dat = self.dateFormatter.date(from: tex)?.millisecondsSince1970;
                    let url = DAMUrls.urlAllPatientsList(from: (dat?.description)!);
                    let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
                    Utility.buttonVisibilityAndShow(sender, title: "syncing..", isEnabled: false);
                    AlamofireManager.Manager.request(request).responseArray {
                        (response: DataResponse<[Patient]>) in
                        Utility.buttonVisibilityAndShow(sender, title: "Start Sync", isEnabled: true);
                        if response.response?.statusCode == 200 {
                            Toast(text: "Synced").show();
                            self.writeToDatabase(response.result.value);
                        } else {
                            Toast(text: "Some error occured!").show();
                        }
                    }
                }
            }
        } else {
//            sync from the beginning of time
//            let dat = self.dateFormatter.date(from: tex)?.millisecondsSince1970;
            Utility.buttonVisibilityAndShow(sender, title: "syncing..", isEnabled: false);
            let url = DAMUrls.urlAllPatientsList();
            let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
            AlamofireManager.Manager.request(request).responseArray {
                (response: DataResponse<[Patient]>) in
                Utility.buttonVisibilityAndShow(sender, title: "Start Sync", isEnabled: true);
                Toast(text: "Synced").show();
                if response.response?.statusCode == 200 {
                    self.writeToDatabase(response.result.value);
                } else {
                    Toast(text: "Some error occured!").show();
                }
            }
        }
    }

    private func writeToDatabase(_ value: [Patient]?) {
        let realm = try? Realm();

        if let objects = value {
            try! realm?.write {
                for item in objects {
                    let res = realm?.objects(Patient.self).filter("personId = '\(item.personId)' AND isUpdated = false").first;
                    if res == nil {
                        realm?.add(item);
                        let resPreg = realm?.objects(PregnancyInfo.self).filter("id = '\(item.personId)' AND isUpdated = false").first;
                        if resPreg == nil {
                            realm?.add(item.personPregnancyInfo!);
                        }
                        let resPerson = realm?.objects(PersonInfoModel.self).filter("id = '\((item.personId))' AND isUpdated = false").first;
                        let pregInfo = realm?.objects(PregnancyInfo.self).filter("id = '\(item.personId)'").first;
                        if resPerson == nil && pregInfo != nil {
                            let perInfo = PersonInfoModel();
                            perInfo.copyFromPregnancy(pregInfo!);
                            realm?.add(perInfo);
                        }

                    }
                };
//                self.populateDate(value);
//                self.loadDataFromDatabase();
            }
        }

    }


    @IBAction func onClickDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    private var intervalMinutes: Int = 2;

    @IBAction func onClickUPMonth(_ sender: UIButton) {
        self.monthsInt = self.monthsInt + 1;
        self.updateUI();
    }

    private func updateUI() {
        if monthsInt == 1 {
            self.lTimeMonthAppointments.text = "1 month";
        } else {
            self.lTimeMonthAppointments.text = "\(monthsInt) months";
        }

        self.lTimeSync.text = "\(intervalMinutes) minutes";


    }

    @IBAction func onClickDownMonth(_ sender: UIButton) {
        if self.monthsInt != 1 {
            self.monthsInt = self.monthsInt - 1;
        } else {
            Toast(text: "Can't be less than 1 month").show();
        }
        self.updateUI();
    }

    @IBAction func onClickUpSyncTimeInterval(_ sender: UIButton) {
        self.intervalMinutes = self.intervalMinutes + 1;
        self.updateUI();
    }

    @IBAction func onClickDownSyncTimeInterval(_ sender: UIButton) {
        if self.intervalMinutes != 2 {
            self.intervalMinutes = self.intervalMinutes - 1;
        } else {
            Toast(text: "Can't be less than 2 minute").show();
        }
        self.updateUI()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.iMonthDown.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        self.iMinuteDown.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
    }

}
