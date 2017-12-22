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

class VCPregnancyHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var indicator: UIActivityIndicatorView?;

    private let realm = try? Realm();

    @IBAction func onClickAdd(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select delivery type" as? String
                , message: nil, preferredStyle: UIAlertControllerStyle.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Normal Delivery", style: UIAlertActionStyle.default, handler: {
            action in
            self.onSelectNormalDelivery();
        }))
        alert.addAction(UIAlertAction(title: "C-Section Delivery", style: UIAlertActionStyle.default, handler: {
            action in
            self.onSelectCSectionDelivery();
        }))

        alert.addAction(UIAlertAction(title: "Spontaneous Abortion", style: UIAlertActionStyle.default, handler: {
            action in
            self.onSelectSpontaneousAbortion();
        }))

        alert.addAction(UIAlertAction(title: "Induced Abortion", style: UIAlertActionStyle.default, handler: {
            action in
            self.onSelectInducedAbortionOption();
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))


        // show the alert
        self.present(alert, animated: true, completion: nil)

    }

    @IBOutlet var collectionView: UICollectionView?;

    private var listPregnancyMembers = [Pregnancy]();
    let dateFormatter = DateFormatter();

    var patientInfo: PersonInfoModel?;

    private func onSelectInducedAbortionOption() {
        let vc: VCSpontaneousAbortion = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_SPONTANEOUSABORTION) as! VCSpontaneousAbortion;
        vc.patientInfo = self.patientInfo;
        vc.onAddedListener = self;
        vc.obType = "Induced Abortion";
        self.navigationController?.pushViewController(vc, animated: true);

    }

    private func onSelectSpontaneousAbortion() {
        let vc: VCSpontaneousAbortion = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_SPONTANEOUSABORTION) as! VCSpontaneousAbortion;
        vc.patientInfo = self.patientInfo;
        vc.onAddedListener = self;
        vc.obType = "Spontaneous Abortion";
        self.navigationController?.pushViewController(vc, animated: true);
    }

    private func onSelectCSectionDelivery() {
        let vc: VCNormalDelivery = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_NORMALDELIVERY) as! VCNormalDelivery;
        vc.patientInfo = self.patientInfo;
        vc.pregnancyType = Names.C_SECTION_DELIVERY;
        vc.onAddedListener = self;
        self.navigationController?.pushViewController(vc, animated: true);

    }

    private func onSelectNormalDelivery() {
        let vc: VCNormalDelivery = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_NORMALDELIVERY) as! VCNormalDelivery;
        vc.patientInfo = self.patientInfo;
        vc.pregnancyType = Names.NORMAL_DELIVERY;
        vc.onAddedListener = self;
        self.navigationController?.pushViewController(vc, animated: true);

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        self.callApiGetPregnancyMembersList();
        dateFormatter.timeZone = Calendar.current.timeZone;
        dateFormatter.locale = Calendar.current.locale;
        dateFormatter.dateFormat = "dd, MMM yyyy";
    }

    func callApiGetPregnancyMembersList() {

        let result = self.realm?.objects(Pregnancy.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (result != nil) {
            self.populateData(data: Array(result!));
        }


//        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientPregnancyHistory(
//                patientInfo: self.patientInfo!), parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//        (request).responseArray { (response: DataResponse<[Pregnancy]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                print("Response : VCPregnancyHistory success!");
//                self.populateData(data: response.result.value!);
//            } else {
//                print(response.response?.statusCode.description);
//                print("Response : VCPregnancyHistory failed!");
//            }
//        }
    }

    private func populateData(data: [Pregnancy]) {
        self.listPregnancyMembers.removeAll();
        self.listPregnancyMembers.append(contentsOf: data);
        self.collectionView?.reloadData();
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pregnancy = listPregnancyMembers[indexPath.row];
        let cell: CellPregnencyHistoryCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_PREGNANCYHISTORY,
                for: indexPath) as! CellPregnencyHistoryCollectionViewCell;
        cell.lTitle?.text = pregnancy.obType!;
        cell.lDate?.text = dateFormatter.string(for: pregnancy.getOBDate());

        cell.lCommentsAge?.setHTML(html: pregnancy.comments!);

        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listPregnancyMembers.count;
    }


}

extension VCPregnancyHistoryViewController: IndicatorInfoProvider, OnAddedListener {
    func onAddedHistory(_ pregnancy: Pregnancy) {
//        print(pregnancy.toJSONString());
        self.callApiGetPregnancyMembersList();
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_PREGNANCY_HISTORY);
    }
}
