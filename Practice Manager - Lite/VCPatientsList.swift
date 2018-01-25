//
// Created by Sandeep Rana on 19/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import InitialsImageView
import RealmSwift

class VCPatientsList: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, OnChangeListener {
    var offSet = 0
    func onChange() {
        self.loadDataFromDatabase();
//        let when = DispatchTime.now() + 5 // Expected delay for realm to process data.
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.loadDataFromDatabase();
//        }
    }

    var allPatients = [Patient]();
    var arrOfPatients = [Patient]();

    var onPatientClickedListener: OnPatientClickedListener?;


    @IBOutlet weak var collectionView: UICollectionView!;
    @IBOutlet weak var indicator: UIActivityIndicatorView!;

    private let realm = try? Realm();

    private var colorCircle: UIColor?;

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrOfPatients.count;
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchBar.text = ""
        self.view.endEditing(true)

        let patient: Patient = self.arrOfPatients[indexPath.row];
        if self.onPatientClickedListener != nil {
            self.onPatientClickedListener?.onPatientClicked(patient, indexPath);
        } else {
            let patientInfo = PersonInfoModel();
            patientInfo.setFields(from: patient);
            let vcPatientInfo: PatientInfoPagerViewController = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.PATIENTINFO_PAGERVIEWCONTROLLER) as! PatientInfoPagerViewController;
            vcPatientInfo.patientInfo = patientInfo;
            self.navigationController?.pushViewController(vcPatientInfo, animated: true);
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pat = self.arrOfPatients[indexPath.row].personPregnancyInfo;
        let patientRoot = self.arrOfPatients[indexPath.row];

        let cell: CellPatientInfo = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_PATIENTINFO,
                for: indexPath) as! CellPatientInfo;
        cell.lTitle.text = pat?.name;

        var strGSA = "";

        if let gen = pat?.gender {
            switch gen {
            case Names.Gender.MALE:
                strGSA = "Male | ";
                break;
            case Names.Gender.FEMALE:
                strGSA = "Female | ";
                break;
            default:
                strGSA = "";
                break;
            }
        }

        if let isVip = pat?.vip {
            if isVip == 1 {
                cell.iStar.isHidden = false;
            } else {
                cell.iStar.isHidden = true;
            }
        }


        if let ms = pat?.mstatus {
            switch ms {
            case Names.StatusMarriage.MARRIED:
                strGSA = strGSA + "Married";
                break;
            case Names.StatusMarriage.DIVORCED:
                strGSA = strGSA + "Divorced";
                break;
            case Names.StatusMarriage.WIDOW:
                strGSA = strGSA + "Widow";
                break;
            default:
                strGSA = strGSA + "Single";
                break;
            }

        }

        if (pat?.dob != nil && pat?.dob != "") {
            let age = Utility.calculateAgefromDOB((pat?.dob!)!)!;
            if age != "-1" {
            strGSA = strGSA + " | " + age;
            }
        }


        cell.lGenderStatusAge.text = strGSA;
        cell.lPhone.text = pat?.phonenumber;
        cell.lEmail.text = pat?.email;
        cell.lId.text = patientRoot.clinicPersonId;
        if (pat?.name != nil) {
            cell.iImageAvatar.setImageForName(string: (pat?.name!)!, backgroundColor: self.colorCircle, circular: true,
                    textAttributes: [NSForegroundColorAttributeName: UIColor.white]);
        }
        cell.bEdit.tag = indexPath.row;
        cell.bEdit.addTarget(self, action: #selector(VCPatientsList.onEditButtonClicked(_:)), for: .touchUpInside);
        return cell;

    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // Make sure that the number of items is worth the computing effort.
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
              let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
              dataSourceCount > 0 else {
            return .zero
        }


        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset


        // Make sure to remove the last item spacing or it will
        // miscalculate the actual total width.
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right


        // If the number of cells that exist take up less room than the
        // collection view width, then center the content with the appropriate insets.
        // Otherwise return the default layout inset.
        guard totalCellWidth < contentWidth else {
            return insets
        }


        // Calculate the right amount of padding to center the cells.
        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
    }

    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        self.searchBar.text = ""
        self.view.endEditing(true)

        print("OnEditButtonClicked");
        let vc: VCEditPatientsBasicInfo = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_EDITPERSONPROFILE) as! VCEditPatientsBasicInfo;
        vc.personInfo = self.arrOfPatients[sender.tag];
        vc.onChangeListener = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBAction func onAddPatientButtonClicked(_ sender: UIButton) {
        self.searchBar.text = ""
        self.view.endEditing(true)

        print("OnAddPatientButtonClicked");
        let vc: VCEditPatientsBasicInfo = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_EDITPERSONPROFILE) as! VCEditPatientsBasicInfo;
//        vc.personInfo = self.arrOfPatients[sender.tag];
        vc.onChangeListener = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

//    let realm;
    var dateFormatter: DateFormatter?;

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadDataFromDatabase();
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.text = ""
        self.view.endEditing(true)
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
//        self.loadDataFromDatabase();
        self.performSelector(inBackground: #selector(apiCallGetPatientsList), with: nil)
//        self.apiCallGetPatientsList();
        colorCircle = UIColor(hexString: "#01715C")
        //        self.realm = try! Realm();
        
        self.dateFormatter = Utility.getDateFormatter(dateFormat: "yyyy-MM-dd");
        
        if (UserPrefUtil.getClinicResponse() != nil) {
            self.title = "Patients | " + (UserPrefUtil.getClinicResponse()?.clinic?.name!)!;
        }
        
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        //        searchBar.placeholder = " Search..."
        //        searchBar.sizeToFit()
        //        searchBar.isTranslucent = false
        //        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        //        navigationItem.titleView = searchBar

    }
    @IBOutlet weak var searchBar: UISearchBar!;

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText);

        do {
            let results = self.allPatients.filter() {
                res in
               if let per = res.personPregnancyInfo
               {
                if ((per.name?.lowercased().hasPrefix(searchText.lowercased()))! || (per.phonenumber?.hasPrefix(searchText))!) {
                    return true;
                } else {
                    return false;
                }
                }
                return false
            };
            self.arrOfPatients.removeAll();
            self.arrOfPatients.append(contentsOf: results);
            self.collectionView.reloadData();
        } catch {
            print(error.localizedDescription);
        }

//        print(results.count);

    }

    @objc func apiCallGetPatientsList() {
        let url = DAMUrls.urlAllPatientsListWithPagination(fromOffset: offSet, andLimit: 50)
//        let url = DAMUrls.urlAllPatientsList();
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
        app_delegate.showLoader(message: "Fetching patients...")
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[Patient]>) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                if response.response?.statusCode == 200 {
                    self.writeToDatabase(response.result.value);
                }
            }
            
        }
    }

    private func loadDataFromDatabase() {
//        Realm.refresh(realm!);
        self.allPatients.removeAll()
        try? realm?.commitWrite();
        realm?.refresh();
        let res = realm?.objects(Patient.self);
        if res != nil {
            for item in res! {
                let patient = Patient();
                patient.copyFromObject(item);

                let resPrg = realm?.objects(PregnancyInfo.self).filter("id = '\((item.personId))'").first;
                if resPrg != nil {
                    let pregInfo = PregnancyInfo();
                    pregInfo.copyFromObject(resPrg!);
                    patient.personPregnancyInfo = pregInfo;
                }

                self.allPatients.append(patient);
            }
            self.populateDate(allPatients);
            self.collectionView.reloadData();
        }
    }

    private func writeToDatabase(_ value: [Patient]?) {
        if let objects = value {
            try! realm?.write {
                for item in objects {
                    let res = realm?.objects(Patient.self).filter("personId = '\(item.personId)' AND isUpdated = false").first;
                    if res == nil {
                        realm?.add(item);
                        let resPreg = realm?.objects(PregnancyInfo.self).filter("id = '\(item.personId)' AND isUpdated = false").first;
                        if resPreg == nil {
                            realm?.add(item.personPregnancyInfo!);
                        }

                        let resPerson = realm?.objects(PersonInfoModel.self).filter("id = '\((item.personId))' AND isUpdated = false").first;
                        let pregInfo = realm?.objects(PregnancyInfo.self).filter("id = '\(item.personId)'").first;
                        if resPerson == nil && pregInfo != nil {
                            let perInfo = PersonInfoModel();
                            perInfo.copyFromPregnancy(pregInfo!);
                            realm?.add(perInfo);
                        }

                    }
                };
                self.populateDate(value);
                self.loadDataFromDatabase();
            }
        }

    }


    private func populateDate(_ data: [Patient]?) {
        self.arrOfPatients.removeAll();
        self.arrOfPatients.append(contentsOf: data!);
        self.collectionView.reloadData();
    }

}

extension VCPatientsList: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height
        {
            offSet = offSet + 1
            apiCallGetPatientsList()
        }
        else
        {
            print("Not reached")
        }
    }
}
