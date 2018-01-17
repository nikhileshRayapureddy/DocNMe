//
//  VCAddAllergy.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 08/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import SearchTextField
import Toaster

class VCAddAllergy: UIViewController {

//    @IBOutlet weak var eAllergyName: UITextField!
    @IBOutlet weak var eAllergySearchName: SearchTextField!

    @IBOutlet weak var eSymptoms: UITextView!
    @IBOutlet weak var sSeasonal: UISwitch!
    @IBOutlet weak var sHeredity: UISwitch!

    var patientInfo: PersonInfoModel?;

    var listenerOnAllergyAdded: AllergyAddedListener?;
    let realm = try? Realm();

//    let realmSearch = try? Realm(configuration: DBUtils.config);


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Allergies"
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
                self.eAllergySearchName.filterItems(fieldsArray);
            }
        }

    }

//    @IBAction func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText);
//
//        let predicate = NSPredicate(format: "name BEGINSWITH %@", searchText);
//        let results = realm?.objects(AllergiesModel.self).filter(predicate);
//
//
////        do {
////            let results = self.allPatients.filter() {
////                res in
////                let per = res.personPregnancyInfo;
////                if ((per?.name?.hasPrefix(searchText))! || (per?.phonenumber?.hasPrefix(searchText))!) {
////                    return true;
////                } else {
////                    return false;
////                }
////            };
////            self.arrOfPatients.removeAll();
////            self.arrOfPatients.append(contentsOf: results);
////            self.collectionView.reloadData();
////        } catch {
////            print(error.localizedDescription);
////        }
//
////        print(results.count);
//
//    }


    @IBAction func onClickAddButton(_ sender: UIButton) {
        if ((eAllergySearchName.text?.characters.count)! > 0) {

            let url = DAMUrls.urlPatientAllergyAdd();
            let allergy = Allergies();
            let date = Date();

            allergy.setFields(
                    hereditary: sHeredity.isOn,
                    isseasonal: sSeasonal.isOn,
                    medicalname: self.eAllergySearchName.text!,
                    symptoms: self.eSymptoms.text,
                    personId: (self.patientInfo?.id)!,
                    since: date.millisecondsSince1970);

            try? realm?.write({
                realm?.add(allergy);
            });


            if (self.listenerOnAllergyAdded != nil) {
                self.listenerOnAllergyAdded?.onAllergyAdded(allergy: allergy);
            }
            self.navigationController?.popViewController(animated: true);


//            sender.setTitle("adding...", for: .normal);
//            sender.isEnabled = false;
//
//            let request = ApiServices.createPostRequest(urlStr: url, parameters: allergy.toJSON());
//
//
//            (request).responseObject {
//                (response: DataResponse<Allergies>) in
//                print(response.result.value ?? "nothign");
////                self.dismiss(animated: true, completion: nil);
//                sender.setTitle("Save", for: .normal);
//                sender.isEnabled = true;
//
//                if (self.listenerOnAllergyAdded != nil && response.result.value != nil) {
//                    self.listenerOnAllergyAdded?.onAllergyAdded(allergy: response.result.value);
//                }
//                self.navigationController?.popViewController(animated: true);
//
//            }

        } else {
            Toast(text: "Allergy Name is required").show();
            print("Nothing entered");
        }
    }


}
