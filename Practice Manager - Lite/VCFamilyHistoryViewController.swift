//
//  VCFamilyHistoryViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 31/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AlamofireObjectMapper
import Alamofire
import RealmSwift


class VCFamilyHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView?;
    @IBOutlet var indicator: UIActivityIndicatorView?;

    @IBAction func onClickAddNew(_ sender: UIButton) {
        let vc: VCAddFamilyHistory = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_ADDFAMILYHISTORY) as! VCAddFamilyHistory;
        vc.patientInfo = self.patientInfo;
        vc.onFamilyHistoryAddedListener = self;
        self.navigationController?.pushViewController(vc, animated: true);

    }


    var listFamilyMembers = [FamilyMember]();

    var patientInfo: PersonInfoModel?;

    let realm = try? Realm();

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        self.callApiGetFamilyMembersList();
    }

    private func callApiGetFamilyMembersList() {

        let results = realm?.objects(FamilyMember.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (results != nil) {
            var tempAllRes = [FamilyMember]();
            for item in Array(results!) {
                let alle = FamilyMember();
                alle.setRefinedFields(obj: item)
                tempAllRes.append(alle);
            }
            self.populateData(data: tempAllRes);
        }


//        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientFamilyHistory(patientInfo: self.patientInfo!), parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//        AlamofireManager.Manager.request(request).responseArray { (response: DataResponse<[FamilyMember]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                print("Response : VCFamilyHistory success!");
//                self.populateData(data: response.result.value!);
//            } else {
//                print(response.response?.statusCode.description);
//                print("Response : VCFamilyHistory failed!");
//            }
//        }
    }

    private func populateData(data: [FamilyMember]) {
        self.listFamilyMembers.append(contentsOf: data);
        self.collectionView?.reloadData();
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let familyMember = listFamilyMembers[indexPath.row];
        let cell: CellFamilyHistoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:
        Names.VContIdentifiers.CELL_FAMILYHISTORY, for: indexPath) as! CellFamilyHistoryCollectionViewCell;
        cell.lTitle.text = familyMember.relation!;
        if let cond = familyMember.conditions {
            cell.lCondition.text = String(format: "Conditions: %@", cond);
        }

        if familyMember.isalive == "1" {
            cell.lIsAlive.text = "Yes";
            cell.lReasonDeath.text = "";
        } else {
            cell.lIsAlive.text = "No";
            if let cause = familyMember.causeofdeath {
                cell.lReasonDeath.text = "Cause of Death:" + cause;
            } else {
                cell.lReasonDeath.text = "Cause of Death: Not Specified"
            }
        }
        cell.btnDelete.tag = indexPath.item + 1000
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteFailyHistoryClicked(sender:)), for: .touchUpInside)
        if let ageUn = familyMember.age {
            cell.lYears.text = ageUn;
        }
        return cell;
    }

    func btnDeleteFailyHistoryClicked(sender: UIButton)
    {
        let familyMember = listFamilyMembers[sender.tag - 1000]
        do {
            
            let updatedAppointments = self.realm?.objects(FamilyMember.self).filter("relation = '\(familyMember.relation!)'")
            try realm?.write {
                realm?.delete(updatedAppointments!)
            }
        } catch {
            print(error);
        }
        listFamilyMembers.remove(at: sender.tag - 1000)
        collectionView?.reloadData()


    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listFamilyMembers.count;
    }


}

extension VCFamilyHistoryViewController: IndicatorInfoProvider, OnFamilyHistoryAddedListener {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_FAMILY_HISTORY);
    }

    func onFamilyMemberAdded(_ history: FamilyMember) {
        if (history != nil) {
            self.listFamilyMembers.append(history);
        }

        self.collectionView?.reloadData();
    }


}
