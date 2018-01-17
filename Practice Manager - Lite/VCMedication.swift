//
//  VCMedication.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 31/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class VCMedication: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBAction func onClickAddMedication(_ sender: UIButton) {
        let vc: VCAddMedication = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_ADDMEDICATION) as! VCAddMedication;
        vc.patientInfo = self.patientInfo;
        vc.listenerOnMedicationAdded = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    var listMedications = [Medication]();
    var patientInfo: PersonInfoModel?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.apiCallGetMedications();
    }

    let realm = try? Realm();

    func apiCallGetMedications() {
        let results = realm?.objects(Medication.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (results != nil) {
            self.populateData(data: Array(results!));
        }


//        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientCurrentMedications(patientInfo: self.patientInfo!), parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//        (request).responseArray { (response: DataResponse<[Medication]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                print("Response : VCMedications success!");
//                self.populateData(data: response.result.value!);
//            } else {
//                print(response.response?.statusCode.description);
//                print("Response : VCMedications failed!");
//            }
//        }
    }


    private func populateData(data: [Medication]) {
        self.listMedications.removeAll();
        self.listMedications.append(contentsOf: data);
        self.collectionView.reloadData();
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listMedications.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let medicat = listMedications[indexPath.row];
        let cell: CellMedicationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_MEDICATION, for: indexPath) as! CellMedicationCollectionViewCell;
        cell.lTitle.text = medicat.name;
        cell.lblDosageValue.text = medicat.dosage
        let strDescripto = String(format: "%@ %@ %@", medicat.duration!, medicat.notes!,medicat.schedule!);
        cell.lblDurationValue.text = strDescripto
        cell.btnDelete.tag = indexPath.item + 1000
        cell.btnDelete.addTarget(self, action: #selector(deleteMedication(sender:)), for: .touchUpInside)
        return cell;
    }
    
    func deleteMedication(sender: UIButton)
    {
        listMedications.remove(at: sender.tag - 1000)
        collectionView.reloadData()
    }
}

extension VCMedication: IndicatorInfoProvider, OnMedicationAddedListener {
    func onMedicineAdded(_ value: Medication?) {
//        self.listMedications.append(value!);
        self.apiCallGetMedications();
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_MEDICATION);
    }
}
