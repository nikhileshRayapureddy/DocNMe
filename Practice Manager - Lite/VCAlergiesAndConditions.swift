//
//  VCAlergiesAndConditions.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 30/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import XLPagerTabStrip
import RealmSwift

class VCAlergiesAndConditions: UIViewController, IndicatorInfoProvider {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var patientInfo: PersonInfoModel?;

    var listAllergies = [Allergies]();
    var listConditions = [Condition]();

    var selectedButtonSegment = 0;

    @IBAction func onClickAddNew(_ sender: UIButton) {
        switch selectedButtonSegment {
        case 0:
            let vc: VCAddAllergy = self.storyboard?.instantiateViewController(
                    withIdentifier: Names.VContIdentifiers.VC_ADDALLERGY)
            as! VCAddAllergy;

            vc.patientInfo = self.patientInfo;
            vc.listenerOnAllergyAdded = self;
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        case 1:
            let vc: VCAddConditions = self.storyboard?.instantiateViewController(
                    withIdentifier: Names.VContIdentifiers.VC_ADDCONDITION)
            as! VCAddConditions;

            vc.patientInfo = self.patientInfo;
            vc.listenerOnConditionAdded = self;
            self.navigationController?.pushViewController(vc, animated: true);
            break;
        default:
            break;
        }
    }


    @IBOutlet weak var segmentedButton: UISegmentedControl!

    @IBAction func onClickSegmentButton(_ sender: UISegmentedControl) {

        self.collectionView.reloadData();
        switch sender.selectedSegmentIndex {
        case 0:
            selectedButtonSegment = 0;
            break;
        default:
            selectedButtonSegment = 1;
            break;
        }

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self;
        collectionView.dataSource = self;
        self.apiCallGetAllergies();
        self.apiCallGetConditions();
    }

    let realm = try? Realm();
    
    private func apiCallGetAllergies() {
        let allergiesResult = self.realm?.objects(Allergies.self).filter("personId = '"+(self.patientInfo?.id)!+"'");
        if (allergiesResult != nil){
            var tempAllRes = [Allergies]();
            for item in Array(allergiesResult!) {
                let alle = Allergies();
                alle.setRefinedFields(obj: item);
                tempAllRes.append(alle);
            }
            self.populateData(data: tempAllRes);
        }
        
        
        
        
//        Utility.showProgressForIndicator(self.indicator, true);
//        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientAllergies(patientInfo: self.patientInfo!), parameters: []);
//        (request).responseArray { (response: DataResponse<[Allergies]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                print("Response : VCAllergiesAndConditions success!");
//                self.populateData(data: response.result.value!);
//            } else {
//                print(response.response?.statusCode.description ?? "Nil come out");
//                print("Response : VCAllergiesAndConditions failed!");
//            }
//        }
    }

    private func apiCallGetConditions() {
        
        let conditionsResult = self.realm?.objects(Condition.self).filter("personId = '"+(self.patientInfo?.id)!+"'");
        var tempAllRes = [Condition]();
        for item in Array(conditionsResult!) {
            let alle = Condition();
            alle.setFields(item, isUpdated: item.isUpdated)
//            alle.setRefinedFields(obj: item);
            tempAllRes.append(alle);
        }
        self.populateConditionsData(data: tempAllRes);
        
        
//        Utility.showProgressForIndicator(self.indicator, true);
//        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientConditions(patientInfo: self.patientInfo!), parameters: []);
//        (request).responseArray { (response: DataResponse<[Condition]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                print("Response : VCAllergiesAndConditions success!");
//                self.populateConditionsData(data: response.result.value!);
//            } else {
//                print(response.response?.statusCode.description ?? "Nil");
//                print("Response : VCAllergiesAndConditions failed!");
//            }
//        }
    }

    private func populateConditionsData(data: [Condition]) {
        self.listConditions.append(contentsOf: data);
        self.collectionView.reloadData();
    }

    func populateData(data: [Allergies]) {
        self.listAllergies.append(contentsOf: data);
        self.collectionView.reloadData();
    }

    static let POSITION_ALLERGIES = 0;

}


extension VCAlergiesAndConditions: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch segmentedButton.selectedSegmentIndex {
        case VCAlergiesAndConditions.POSITION_ALLERGIES:
            return listAllergies.count;
        default:
            return listConditions.count;
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedButton.selectedSegmentIndex {
        case VCAlergiesAndConditions.POSITION_ALLERGIES:
            let allergy: Allergies = listAllergies[indexPath.row];
            let cell: CellAllergiesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_ALLERGIES, for: indexPath) as! CellAllergiesCollectionViewCell;
            cell.lTitle.text = allergy.medicalname;
            cell.lSubtitleSeasonalHeredity.text = String(format: "%@,", (allergy.isseasonal ? "Yes" : "No"))
            cell.lHeredityValue.text = (allergy.hereditary ? "Yes" : "No")
            cell.lSymptom.text = allergy.symptoms
            cell.btnDelete.tag = indexPath.item + 3000
            cell.btnDelete.addTarget(self, action: #selector(deleteAllergies(sender:)), for: .touchUpInside)
            return cell;
        default:
            let condition: Condition = listConditions[indexPath.row];
            let cell: CellConditionsViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_CONDITIONS, for: indexPath) as! CellConditionsViewCell;
            cell.lTitle.text = condition.medicalname!;
            let date: Date = Date(milliseconds: condition.since);
            cell.lSinceDay.text = String(format: "Since : %@", arguments: [date.getElapsedInterval()]);
            cell.btnDelete.tag = indexPath.item + 6000
            cell.btnDelete.addTarget(self, action: #selector(deleteConditions(sender:)), for: .touchUpInside)
            return cell;
        }
    }
    
    func deleteAllergies(sender: UIButton)
    {
        let allergy = listAllergies[sender.tag - 3000]

        do {
            
            let updatedAppointments = self.realm?.objects(Allergies.self).filter("medicalname = '\(allergy.medicalname!)'")
            try realm?.write {
                realm?.delete(updatedAppointments!)
            }
        } catch {
            print(error);
        }

        listAllergies.remove(at: sender.tag - 3000)
        collectionView.reloadData()
    }
    
    func deleteConditions(sender: UIButton)
    {
        let allergy = listConditions[sender.tag - 6000]

        do {
            
            let updatedAppointments = self.realm?.objects(Condition.self).filter("medicalname = '\(allergy.medicalname!)'")
            try realm?.write {
                realm?.delete(updatedAppointments!)
            }
        } catch {
            print(error);
        }

        listConditions.remove(at: sender.tag - 6000)
        collectionView.reloadData()
    }
}

extension VCAlergiesAndConditions: AllergyAddedListener, ListenerOnConditionAdded {
    func onConditionAdded(condition: Condition?) {
        self.listConditions.append(condition!);
        self.collectionView.reloadData();
    }

    func onAllergyAdded(allergy: Allergies?) {
        self.listAllergies.append(allergy!);
        self.collectionView.reloadData();
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_ALLERGIESANDCONDITIONS);
    }
}














