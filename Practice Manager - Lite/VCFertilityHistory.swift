//
// Created by Sandeep Rana on 18/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import Alamofire
import XLPagerTabStrip
import RealmSwift

class VCFertilityHistory: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var dateFormatter: DateFormatter?;
    @IBOutlet var indicator: UIActivityIndicatorView?;

    @IBAction func onClickAddMoreFertilityHistory(_ sender: UIButton) {
        let vc: VCAddFertilityHistory = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_ADDFERTILITYHISTORY) as! VCAddFertilityHistory;
        vc.patientInfo = self.patientInfo;
        vc.onFertilityHistoryAddedListener = self;
        self.navigationController?.pushViewController(vc, animated: true);

    }

    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfData.count;
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellFertilityHistoryCollectionView = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_FERTILITYHISTORY,
                for: indexPath) as! CellFertilityHistoryCollectionView;
        let history = self.arrOfData[indexPath.row];
        cell.lTitleType.text = history.treatmentType;
        cell.lNotes.text = "Notes: " + (history.note?.description)!;
        if let dat = history.getDateFromInFormat() {
            cell.lDateFrom.text = "Date From: " + (self.dateFormatter?.string(from: dat).description)!;
        }
        if let dat = history.getDateToInFormat() {
            cell.lDateTo.text = "Date To: " + (self.dateFormatter?.string(from: dat).description)!;
        }
        cell.lResultedInPregnancy.text = "Resulted in Pregnancy: " + (history.pregnant == 1 ? "Yes" : "No").description;

        cell.lNoOfCycles.text = "No of Cycles:" + (history.numberOfCycles.description);

        return cell;
    }

    var patientInfo: PersonInfoModel?;

    var arrOfData = [FertilityHistory]();

    @IBOutlet weak var collectionView: UICollectionView!;

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallGetData();
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd-MM-yyyy");

    }
    let realm = try? Realm();

    private func checkAndStoreToData(_ list: [FertilityHistory]) {

        do {
            try realm?.write({
                for item in list {
                    let res = self.realm?.objects(FertilityHistory.self).filter("id = '\((item.id)!)'").first;
                    if res == nil {
                        self.realm?.add(item);
                    } else {
                        if (!(res?.isUpdated)!) {
                            res?.setFields(item, false);
                        }
                    }
                }
            });
        } catch {

            print(error);
        }
        self.refreshDataFromDB();
    }

    private func refreshDataFromDB() {
        let results = self.realm?.objects(FertilityHistory.self).filter("patientPersonId = '\((self.patientInfo?.id)!)'");
        if results != nil {
            self.pupulateData(Array(results!));
        }
    }


    private func apiCallGetData() {

        self.refreshDataFromDB();


        let url = DAMUrls.urlPatientFertilityHistoryGet(patientInfo: self.patientInfo!);
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
        Utility.showProgressForIndicator(self.indicator, true);
        AlamofireManager.Manager.request(request).responseArray { (response: DataResponse<[FertilityHistory]>) in
            Utility.showProgressForIndicator(self.indicator, false);
            if (response.response?.statusCode == 200) {
//                self.pupulateData(response.result.value!);
                self.checkAndStoreToData((response.result.value)!);
            }
        }
    }

    private func pupulateData(_ value: [FertilityHistory]) {
        self.arrOfData.removeAll();
        self.arrOfData.append(contentsOf: value);
        self.collectionView.reloadData();
    }
}

extension VCFertilityHistory: IndicatorInfoProvider, OnFertilityHistoryAddedListener {
    func onFertilityAdded(_ history: FertilityHistory?) {
        self.arrOfData.append(history!);
        self.collectionView.reloadData();
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_FERTILITY_HISTORY);
    }
}
