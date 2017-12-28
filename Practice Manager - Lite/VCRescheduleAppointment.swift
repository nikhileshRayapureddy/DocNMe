//
//  RescheduleAppointmentViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 23/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import DatePickerDialog
import RealmSwift

class VCRescheduleAppointment: UIViewController {
    let dateFormatter = Utility.getDateFormatter(dateFormat: "dd/MM/yyyy");
    let timeFormatter = Utility.getDateFormatter(dateFormat: "hh:mm aa");

    var appointmentDelegate: OnAppointmentDelegateRescheduled?;

    @IBAction func onClickSelectTimeButton(_ sender: Any) {
        self.showTimePicker();
    }

    @IBAction func onClickSelectDateButton(_ sender: Any) {
        self.showDatePicker();
    }

    var datepicker = UIDatePicker();
    var delegateRescheduledAppointment: OnRescheduleDelegate!;
    public var appointment: AppointmentModel! = nil;
    public let position: Int = (-1);

    @IBAction func b_reschedule(_ sender: Any) {
        if appointment != nil {

            let allDateFormatter = Utility.getDateFormatter(dateFormat: "dd/MM/yyyy hh:mm aa");

//            let dateStr = "\(String(describing: b_date.titleLabel!.text)) \(String(describing: b_time.titleLabel!.text))";
            let dateStr = (b_date.titleLabel?.text!)! + " " + (b_time.titleLabel?.text!)!;
            print(dateStr);

            let dateWithTime: Date = allDateFormatter.date(from: dateStr)!;

            var dictToUpdate = [String: Any]();
            dictToUpdate[Names.APPOINTMENTFROM] = dateWithTime.millisecondsSince1970;
            dictToUpdate[Names.APPOINTMENTTO] = dateWithTime.millisecondsSince1970;
            dictToUpdate[Names.DOCTORPERSONID] = appointment.doctorId;
            dictToUpdate[Names.ID] = appointment.id;
            dictToUpdate[Names.PURPOSE] = appointment.purpose;
            dictToUpdate[Names.PATIENTPERSONID] = appointment.patientInfo.id;

            try? realm?.write {
                let appRes = self.realm?.objects(AppointmentModel.self).filter("id = '\(appointment.id!)'").first;
                if appRes != nil {
                    appRes?.purpose = self.e_purpose.text;
                    appRes?.appointmentFrom = dateWithTime.millisecondsSince1970;
                    appRes?.appointmentTo = dateWithTime.millisecondsSince1970 + 3600000;
                    self.navigationController?.popViewController(animated: true);
                    if self.appointmentDelegate != nil {
                        self.appointmentDelegate?.onRescheduled();
                    }
                }

            }


//            let urlRequest = ApiServices.createPostRequest(urlStr:
//            DAMUrls.urlRescheduleAppointment(), parameters: dictToUpdate);
//            AlamofireManager.Manager.request(urlRequest).responseString(completionHandler: {
//                response in
//                if response.response?.statusCode == 200 {
//                    self.navigationController?.popViewController(animated: false);
//                }
//
//            });

        }


    }

    let realm = try? Realm();

    func showDatePicker() {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if date != nil
            {
            self.b_date.setTitle("\(String(describing: self.dateFormatter.string(from: date!)))", for: UIControlState.normal);
            }
        }
    }

    func showTimePicker() {
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in

            self.b_time.setTitle("\(String(describing: self.timeFormatter.string(from: date!)))", for: UIControlState.normal);
        }
    }

    func datePickerChanged(sender: Any) {
        print("changed");
    }

    @IBOutlet weak var l_patientname: UILabel!;
    @IBOutlet weak var b_date: UIButton!;
    @IBOutlet weak var b_time: UIButton!;
    @IBOutlet weak var e_purpose: UITextField!;


    override func viewDidLoad() {
        super.viewDidLoad()
        self.pupulateData(appointment: appointment);
    }

    func pupulateData(appointment: AppointmentModel) {
        self.title = "Reschedule Appointment"
        self.l_patientname.text = appointment.patientInfo.name
        self.e_purpose.text = appointment.purpose
        let date = Date(milliseconds: appointment.appointmentFrom);
        b_date.setTitle(dateFormatter.string(from: date), for: UIControlState.normal);
        b_time.setTitle(timeFormatter.string(from: date), for: UIControlState.normal);
    }


}
