//
// Created by Sandeep Rana on 10/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import XLPagerTabStrip
import RealmSwift

class VCInvestigations: UIViewController, OnRecordAddedDelegate {
    func onRecordAdded(_ record: [Record]) {
        self.refreshFromDatabase();
    }

    var patientInfo: PersonInfoModel?;


    @IBOutlet weak var collectionView: UICollectionView!;
    @IBOutlet weak var indicator: UIActivityIndicatorView!;
    var listRecords = [String: [Record]]();
    var dateFormatter = DateFormatter();

    @IBAction func onClickAddButton(_ sender: UIButton) {
        let vc = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_TESTRESULTS) as! VCAddTestResultsForAddingInvestigations;
        vc.personInfo = self.patientInfo;
        vc.onRecordAddedListener = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd MMM yyy");
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;

        self.apiCallInvestigations();
    }


    private func apiCallInvestigations() {
        let url = DAMUrls.URLs.baseUrl + "/records?personid=" + (self.patientInfo?.id.description)! + "&type=diagnostic_reports&access_token=" + UserPrefUtil.getAccessToken();

        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);

        self.refreshFromDatabase();

        Alamofire.request(request).responseArray {
//            response in
//            print(response.result.value);
            (response: DataResponse<[Record]>) in
            if response.response?.statusCode == 200 {
                print("Response : VCInvestigations success!");

                self.saveFetchedResults(response.result.value);

            } else {
                print(response.response?.statusCode.description);
                print("Response : VCInvestigations failed!");
            }
        }


    }


    var data = [Record]();
    let realm = try? Realm();


    private func saveFetchedResults(_ value: [Record]?) {
        try? realm?.write({
            if let data = value {
                for item in data {
                    if item.id != nil {
                        if let res = self.realm?.objects(Record.self).filter("id = '\(item.id!)'") {
//                        realm?.delete(res);
                        } else {
                            realm?.add(item);
                        }
                    }
                }
            }
        });

        self.refreshFromDatabase();
    }

    private func refreshFromDatabase() {
        let results = realm?.objects(Record.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (results != nil) {
            self.populateData(data: Array(results!));
        }
    }


    private func populateData(data: [Record]) {
//        self.listRecords.append(contentsOf: data)

        self.data = data;
        for record in data {
            if record.directoryId != nil {
            if ((listRecords[record.directoryId!]) != nil) {
                listRecords[record.directoryId!]?.append(record);
            } else {
                listRecords[record.directoryId!] = [record];
            }
            }
        }
        self.collectionView?.reloadData();
    }

}

extension VCInvestigations: UICollectionViewDelegate, UICollectionViewDataSource, IndicatorInfoProvider {


    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_INVESTIGATIONS);
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let recListKey = Array(listRecords.keys)[indexPath.row];

        var record = (listRecords[recListKey])?[0];
        if (record?.doctorName != nil && (record?.doctorName?.isEmpty)! && ((listRecords[recListKey])?.count)! > 1) {
            record = (listRecords[recListKey])?[1];
            if ((record?.doctorName?.isEmpty)! && ((listRecords[recListKey])?.count)! > 2) {
                record = (listRecords[recListKey])?[2];
            }
        }

        let cell: CellInvestigationsCollectionView = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_INVESTIGATIONS,
                for: indexPath) as! CellInvestigationsCollectionView;


        if record?.dateofissue != nil {
//            cell.lDate?.text = dateFormatter.string(from: (record?.getDateOfIssue())!);
        }
        if record?.doctorName != nil {
//            cell.lDoctorName?.text = record?.doctorName;
            cell.lDoctorName?.text = "\((record?.doctorName!)!)";
        }
        if record?.issuerName != nil {
//            cell.lIssuedBy?.text = String(format: "", (record?.issuerName!)!);
            cell.lIssuedBy.text = "\((record?.issuerName!)!)";
        }

        if (hasImage(record: record!)) {
            cell.lAttachment.text = "No";
        } else {
            cell.lAttachment.text = "Yes";
        }

        if let nota = record?.notes {
            cell.lNote.text = nota;
        }

        return cell;
    }

    func hasImage(record: Record) -> Bool {
        return (record.mimetype != nil) && (record.mimetype?.hasPrefix("image"))!
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listRecords.count;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let recListKey = Array(listRecords.keys)[indexPath.row];

        let record = (listRecords[recListKey])?[0];

        var urlArray = [Record]();
        if hasImage(record: record!) {

            for ite in listRecords[recListKey]! {
                urlArray.append(ite);
            }

            let vc: VCRecordsImageViewerViewController = UIStoryboard(name: Names.STORYBOARD.MAIN, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.IMAGE_VIEWER) as! VCRecordsImageViewerViewController;
            vc.urlArray = urlArray;
            self.navigationController?.pushViewController(vc, animated: true);
        }

    }


}



