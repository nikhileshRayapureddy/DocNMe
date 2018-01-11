//
// Created by Sandeep Rana on 15/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import RealmSwift
import DatePickerDialog

//import Dropper

import SearchTextField
import Toaster


class VCAddAppointment: UIViewController {
    let dateFormatter = Utility.getDateFormatter(dateFormat: "dd/MM/yyyy");
    let timeFormatter = Utility.getDateFormatter(dateFormat: "hh:mm aa");

    var doctorId: String?;

    @IBOutlet weak var ePhoneNumber: SearchTextField!
    let realm = try? Realm();
    @IBOutlet weak var ePatientName: SearchTextField!
    @IBOutlet weak var bDate: UIButton!
    @IBOutlet weak var bTime: UIButton!


    @IBAction func onSearchStringChangedPatientName(_ sender: UITextField) {
        //        print(sender.text);
        let predicate = NSPredicate(format: "name BEGINSWITH[c] %@", sender.text!);
        let results = realm?.objects(PersonInfoModel.self).filter(predicate);
        if results != nil {
            if (results?.count)! > 0 {
                var fieldsArray = [SearchTextFieldItem]();
                //                for item in DBUtils.getStringAllergies() {
                for item in results! {
                    let searchTextField = SearchTextFieldItem(title: item.name, subtitle: item.phonenumber, image: nil, id: item.id);
                    fieldsArray.append(searchTextField);
                }
                self.ePatientName.filterItems(fieldsArray);
            }
        }

    }

    @IBAction func onSearchStringChangedPatientPhone(_ sender: UITextField) {
        //        print(sender.text);
        let predicate = NSPredicate(format: "phonenumber BEGINSWITH[c] %@", sender.text!);
        let results = realm?.objects(PersonInfoModel.self).filter(predicate);
        if results != nil {
            if (results?.count)! > 0 {
                var fieldsArray = [SearchTextFieldItem]();
                //                for item in DBUtils.getStringAllergies() {
                for item in results! {
                    let searchTextField = SearchTextFieldItem(title: item.name, subtitle: item.phonenumber, image: nil, id: item.id);
                    fieldsArray.append(searchTextField);
                }
                self.ePhoneNumber.filterItems(fieldsArray);
            }
        }

    }

    var patient: Patient?;

    @IBAction func onClickAddButton(_ sender: UIButton) {
        if self.ePatientName.text == "" || self.ePhoneNumber.text == "" {
            Toast(text: "Patient Name and Phone can't be empty!").show();
            return;
        }


        let combinedDateFormatter = Utility.getDateFormatter(dateFormat: "\(self.dateFormatter.dateFormat!)\(self.timeFormatter.dateFormat!)");
        let appointmentDate = combinedDateFormatter.date(from: "\((self.bDate.titleLabel?.text!)!)\((self.bTime.titleLabel?.text!)!)");
        let milliFrom = appointmentDate?.millisecondsSince1970;

        let milCurr = Date();
        if milliFrom! < milCurr.millisecondsSince1970 {
            Toast(text: "Appointment can't be in past.").show();
            return;
        }

        let milliTo = (appointmentDate?.millisecondsSince1970)! + 3600000;
        if self.patient == nil {
            let patient = Patient();
            let personInfo = PersonInfoModel();
            personInfo.id = Date().millisecondsSince1970.description;
            personInfo.name = self.ePatientName.text;
            personInfo.gender = self.segmentGender.selectedSegmentIndex;
            personInfo.phonenumber = self.ePhoneNumber.text;
            
            try? realm?.write({
                patient.isUpdated = true;
                
                realm?.add(patient);
                realm?.add(personInfo);
                
                let pregIn = PregnancyInfo();
                pregIn.id = personInfo.id;
                pregIn.name = personInfo.name;
                pregIn.gender = personInfo.gender;
                pregIn.phonenumber = personInfo.phonenumber;
                
                realm?.add(pregIn);
            });
            self.patient = patient;
            let appoint = AppointmentModel();
            appoint.isUpdated = true;
            appoint.id = Date().millisecondsSince1970.description;
            appoint.patientId = personInfo.id;
            appoint.appointmentFrom = milliFrom!;
            appoint.appointmentTo = milliTo;
            appoint.doctorId = self.doctorId!;
            appoint.purpose = self.ePurpose.text;
            try? realm?.write({
                realm?.add(appoint);
            })
        } else {
            let appoint = AppointmentModel();
            appoint.isUpdated = true
            appoint.patientId = self.patient?.personInfo?.id;
            appoint.appointmentFrom = milliFrom!;
            appoint.appointmentTo = milliTo;
            appoint.id = Date().millisecondsSince1970.description;
            appoint.doctorId = self.doctorId!;
            appoint.purpose = self.ePurpose.text;
            try? realm?.write({
                realm?.add(appoint);
            })
        }
        self.navigationController?.popViewController(animated: true);
    }

    @IBOutlet weak var ePurpose: UITextField!

    @IBOutlet weak var segmentGender: UISegmentedControl!

    @IBAction func onClickTime(_ sender: UIButton) {
        var dateTaken = Date()
        let combinedDateFormatter = Utility.getDateFormatter(dateFormat: "\(self.dateFormatter.dateFormat!)");
        let appointmentDate = combinedDateFormatter.date(from: (self.bDate.titleLabel?.text)!);
        switch appointmentDate?.compare(dateTaken) {
        case .orderedAscending?     : break
        case .orderedDescending?    :   dateTaken = appointmentDate!; break
        case .orderedSame?          : break
        case .none: break
            
        }

        DatePickerDialog().show("Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: dateTaken, maximumDate: nil, datePickerMode: .time){
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.timeFormatter.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: Date(), maximumDate: nil, datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bDate.setTitle(self.dateFormatter.string(from: Date()), for: .normal);
        self.bTime.setTitle(self.timeFormatter.string(from: Date()), for: .normal);
        self.ePatientName.itemSelectionHandler = {
            (item, itemPosition) in
            self.onSelectUpdateUI(item: item, itemPosition: itemPosition);
        };
        self.ePhoneNumber.itemSelectionHandler = {
            (item, itemPosition) in
            self.onSelectUpdateUI(item: item, itemPosition: itemPosition);
        };
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectedRow(notification:)), name: NSNotification.Name(rawValue: "SelectedSearchTextField"), object: nil)

    }
    func selectedRow(notification : Notification)
    {
        let item = notification.object as! SearchTextFieldItem
        ePhoneNumber.text = item.subtitle
        ePatientName.text = item.title
        self.view.endEditing(true)
    }
    private func onSelectUpdateUI(item: SearchTextFieldItem, itemPosition: Int) {
        print(item);
        let res = self.realm?.objects(Patient.self).filter("personId = '\(item.id!)'").first;
        if (res != nil) {

            var patient = Patient();
            patient = patient.copyFromObject(patient);
            let resPers = self.realm?.objects(PersonInfoModel.self).filter("id = '\(item.id!)'").first;
            if resPers != nil {
                let person = PersonInfoModel();
                person.setFields(resPers!);
                patient.personInfo = person;
            }

            let resPreg = self.realm?.objects(PregnancyInfo.self).filter("id = '\(item.id!)'").first;
            if resPreg != nil {
                let person = PregnancyInfo();
                person.copyFromObject(resPreg!);
                patient.personPregnancyInfo = person;
            }

            self.patient = patient;
            self.updateOnSelectPatient();
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func updateOnSelectPatient() {
        self.ePatientName.text = self.patient?.personInfo?.name;
        self.ePhoneNumber.text = self.patient?.personInfo?.phonenumber;
    }
}













