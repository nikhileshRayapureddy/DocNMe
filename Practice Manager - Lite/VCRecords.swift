//
// Created by Sandeep Rana on 01/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import XLPagerTabStrip
import SKPhotoBrowser
import RealmSwift

class VCRecords: UIViewController, OnRecordAddedDelegate {
    @IBOutlet var collectionView: UICollectionView?;
    @IBOutlet var indicator: UIActivityIndicatorView?;

    var patientInfo: PersonInfoModel?;
    var listRecords = [String: [Record]]();
    let dateFormatter = DateFormatter();

    @IBAction func btnSave(_ sender: Any) {
    }
    //    let dictImages = [String:[String]]();

    private var data = [Record]();

    override func viewDidLoad() {
        super.viewDidLoad();
        dateFormatter.timeZone = Calendar.current.timeZone;
        dateFormatter.locale = Calendar.current.locale;
        dateFormatter.dateFormat = "dd MMM yyyy";
        self.apiCallGetList();
        self.collectionView?.delegate = self;
        self.collectionView?.dataSource = self;
    }


    @IBAction func onClickSelectRecordDate(_ sender: UIButton) {
        let vcAddRecords = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_ADDRECORDS) as! VCAddRecords;
        vcAddRecords.personInfo = self.patientInfo;
        vcAddRecords.onRecordAddedDelegate = self;
        self.navigationController?.pushViewController(vcAddRecords, animated: true);
    }

    let realm = try? Realm();

    private func apiCallGetList() {
        let results = realm?.objects(Record.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (results != nil) {
            self.populateData(data: Array(results!));
        }

        let request = ApiServices.createGetRequest(urlStr: DAMUrls.urlPatientRecords(patientInfo: self.patientInfo!), parameters: []);
        Utility.showProgressForIndicator(self.indicator, true);
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[Record]>) in
            Utility.showProgressForIndicator(self.indicator, false);
            if response.response?.statusCode == 200 {
                print("Response : VCRecord success!");
//                self.populateData(data: response.result.value!);
                self.saveFetchedResults(response.result.value);
            } else {
                print(response.response?.statusCode.description);
                print("Response : VCRecord failed!");
            }
        }
    }


    private func saveFetchedResults(_ value: [Record]?) {
        try? realm?.write({
            if let data = value {
                for item in data {
                    if item.id != nil {
                        if let res = self.realm?.objects(Record.self).filter("id = '\(item.id!)'").first {
//                        realm?.delete(res);
                        } else {
                            realm?.add(item);
                        }
                    }
                }
            }
        });
    }

    private func refreshFromDatabase() {
        let results = realm?.objects(Record.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (results != nil) {
            self.populateData(data: Array(results!));
        }
    }

    private func populateData(data: [Record]) {
//        self.listRecords.append(contentsOf: data);
        do {
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
        } catch {
            print(error);
        }
    }

    func onRecordAdded(_ record: [Record]) {
        self.data.append(contentsOf: record);
        self.populateData(data: self.data);
    }
}

extension VCRecords: UICollectionViewDelegate, UICollectionViewDataSource, IndicatorInfoProvider {


    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_RECORDS);
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let recListKey = Array(listRecords.keys)[indexPath.row];

        let record = (listRecords[recListKey])?[0];

        let cell: CellRecordsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Names.VContIdentifiers.CELL_RECORDS, for: indexPath) as! CellRecordsCollectionViewCell;
        cell.lTitle?.text = record?.type;
        if record?.dateofissue != nil {
            cell.lDate?.text = dateFormatter.string(from: (record?.getDateOfIssue())!);
        }

        if record?.doctorName != nil {
            cell.lDoctorName?.text = String(format: "Doctor: %@", (record?.doctorName!)!);
        }
        if record?.issuerName != nil {
            cell.lIssuerName?.text = String(format: "Issuer: %@", (record?.issuerName!)!);
        }
        if let note = record?.notes {
            cell.lNotes?.text = String(format: "Notes: %@", note);
        }

        if (hasImage(record: listRecords[recListKey]!)) {
            cell.iAttachment?.isHidden = false;
        } else {
            cell.iAttachment?.isHidden = true;
        }

        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listRecords.count;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let recListKey = Array(listRecords.keys)[indexPath.row];

        let record = (listRecords[recListKey])?[0];

        var urlArray = [Record]();
        if hasImage(record: listRecords[recListKey]!) {

            for ite in listRecords[recListKey]! {
                urlArray.append(ite);
            }

            let vc: VCRecordsImageViewerViewController = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.IMAGE_VIEWER) as! VCRecordsImageViewerViewController;
            vc.urlArray = urlArray;
            self.navigationController?.pushViewController(vc, animated: true);
        }

    }

    func hasImage(record: [Record]) -> Bool {
        for item in record {
            if (item.mimetype != nil) && (item.mimetype?.hasPrefix("image"))! {
                return true;
            }
        }
        return false;
    }
}

