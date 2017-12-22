//
// Created by Sandeep Rana on 12/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import AlamofireObjectMapper
import Alamofire
import XLPagerTabStrip


public class VCVisits: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let realm = try? Realm();
    var arrOfVisits = [Visit]();

    weak var collectionView: UICollectionView!;
    let dateFormatter = Utility.getDateFormatter(dateFormat: "dd MMM yyyy");

    var patientInfo: PersonInfoModel?;

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCallGetData();
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.refreshDataFromDB();
    }


    private func apiCallGetData() {
        let url = DAMUrls.urlPatientVisitsList(personInfo: self.patientInfo!);
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[Visit]>) in
            if response.response?.statusCode == 200 {
                self.checkAndStoreToData(response.result.value!);
            }
        }

    }

    private func checkAndStoreToData(_ list: [Visit]) {

        do {
            try realm?.write({
                for item in list {
                    let res = self.realm?.objects(Visit.self).filter("id = '\((item.id))'").first;
                    if res == nil {
                        self.realm?.add(item);
                    }
                }
            });
        } catch {

            print(error);
        }
        self.refreshDataFromDB();
    }

    private func refreshDataFromDB() {
        let results = self.realm?.objects(Visit.self).filter("personId = '\((self.patientInfo?.id)!)'");
        if results != nil {
            arrOfVisits.append(contentsOf: Array(results!));
            self.collectionView.reloadData();
        }
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfVisits.count;
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellVisitsCollectionView = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_VISITS,
                for: indexPath) as! CellVisitsCollectionView;
        let visit = arrOfVisits[indexPath.row];
        cell.lDate.text = dateFormatter.string(from: Date(milliseconds: visit.visitTime));
        cell.lDoctName.text = visit.doctorInfo?.name;
        cell.lObservations.text = visit.observations;
        cell.lPurpose.text = visit.purpose;
        cell.lPrescriptions.text = visit.prescription;
        return cell;
    }

}


extension VCVisits: IndicatorInfoProvider {
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_VISITS);
    }

}
