//
//  VCConditions.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 11/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import DatePickerDialog
import RealmSwift
import SearchTextField
import Toaster

class VCAddConditions: UIViewController {

    let dateFormatter = DateFormatter();
    var patientInfo: PersonInfoModel?;

    let realm = try? Realm();


    @IBAction func onClickAddCondition(_ sender: UIButton) {
//        let url = DAMUrls.urlPatientConditionsAdd();

    if eCondition.text!.characters.count < 1 {
        Toast(text: "Condition name is required!").show();
        return;
    }

        let condition = Condition();
        condition.since = (dateFormatter.date(from: (bDateSince.titleLabel?.text)!)?.millisecondsSince1970)!;
        condition.medicalname = eCondition.text;
        condition.personId = self.patientInfo?.id;
        condition.isUpdated = true;

        try? realm?.write({
            realm?.add(condition);
        })

        let conditionTemp = Condition();
        conditionTemp.setFields(condition, isUpdated: true);

        self.listenerOnConditionAdded?.onConditionAdded(condition: conditionTemp);
        self.navigationController?.popViewController(animated: true);


//        sender.isEnabled = false;
//        sender.setTitle("adding...", for: .normal);
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: condition.toJSON());
//        AlamofireManager.Manager.request(request).responseObject {
//            (response: DataResponse<Condition>) in
//            sender.isEnabled = true;
//            sender.setTitle("Save", for: .normal);
//            if(response.response?.statusCode == 200 && self.listenerOnConditionAdded != nil){
//                self.listenerOnConditionAdded?.onConditionAdded(condition: response.result.value);
//                self.navigationController?.popViewController(animated: true);
//            }
//
//        }

    }


    @IBAction func onSearchStringChanged(_ sender: UITextField) {
        print(sender.text);
        let predicate = NSPredicate(format: "name BEGINSWITH[c] %@", sender.text!);
        let results = realm?.objects(AllergiesModel.self).filter(predicate);
        if results != nil {
            if (results?.count)! > 0 {
                var fieldsArray = [SearchTextFieldItem]();
//                for item in DBUtils.getStringAllergies() {
                for item in results! {
                    fieldsArray.append(SearchTextFieldItem(title: item.name!));
                }
                self.eCondition.filterItems(fieldsArray);
            }
        }
    }

    @IBAction func onClickDateSince(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    @IBOutlet weak var bDateSince: UIButton!
    @IBOutlet weak var eCondition: SearchTextField!
    var listenerOnConditionAdded: ListenerOnConditionAdded?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.timeZone = Calendar.current.timeZone;
        self.dateFormatter.locale = Calendar.current.locale;
        self.dateFormatter.dateFormat = "dd-MM-yyyy";
        self.bDateSince.setTitle(self.dateFormatter.string(from: Date()), for: .normal);
        self.title = "Add Conditions"
    }

}
