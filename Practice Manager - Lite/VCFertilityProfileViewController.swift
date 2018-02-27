//
//  VCFertilityProfileViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 14/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import AlamofireObjectMapper
import RealmSwift


class VCFertilityProfileViewController: UIViewController {
    @IBOutlet var indicator: UIActivityIndicatorView?;

    let realm = try? Realm();
    static let CHANCES_OF_EXPOSURE = 0;
    static let CHANCES_OF_EXPOSURE_SPOUSE = 1;

    private var dateFormatter = DateFormatter();

    private var arrOfChancesOfExposure: [CheckModel] = [CheckModel]();

    private var arrOfChancesOfExposureSpouse: [CheckModel] = [CheckModel]();

    @IBAction func onClickSaveButton(_ sender: UIButton) {
        var idStr: String = "";
        idStr = (self.patientInfo?.id!)!;
        var arrOfAttributes: [[String: Any]] = [];
        if true {
            let str = self.eMonthTryingToConceive.text;
            let attrib = BasicProfileAttributes();

            attrib.setFields(name: Names.MONTHS_TRYING_TO_CONCEIVE, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if true {
            let str = self.eIntercoursePerWeek.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.INTERCOURSE_PER_WEEK, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if (sNeedMedicationToBringInPeriod.isOn) {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.MEDS_FOR_PERIOD, value: "1", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        } else {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.MEDS_FOR_PERIOD, value: "0", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if (self.sSevereCrampingPelvicPainWithYourPeriods.isOn) {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.HASPAINFULPERIODS, value: "1", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        } else {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.HASPAINFULPERIODS, value: "0", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        if true {
            let str = self.eOccupation.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.OCCUPATION, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if true {
            let str = self.bChancesOfExposureTo.titleLabel?.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.PATIENTCHANCESOFEXPOSURETO, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        if true {
            let str = self.eSpouseOccupation.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.SPOUSEOCCUPATION, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        if true {
            let str = self.bSpouseChancesOfExposure.titleLabel?.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.SPOUSECHANCESOFEXPOSURETO, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        if true {
            let str = self.eSpouseAnyKnownMedicalProblem.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.HUSBAND_CURRENT_MEDICAL_PROBLEMS, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());

            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if true {
            let str = self.eDoYouTakeHerbalMedicine.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.HUSBAND_USE_HERBAL_MEDICATION, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());

            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }

        if true {
            let str = self.eAnyMedicationsCurrentlyTaking.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.HUSBAND_CURRENT_MEDICATION, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());

            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        if (self.sSemenAnalysis.isOn) {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.SEMEN_ANALYSIS_YN, value: "1", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        } else {
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.SEMEN_ANALYSIS_YN, value: "0", personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            });
        }


        if true {
            let str = self.eAdditionalInfo.text;
            let attrib = BasicProfileAttributes();
            attrib.setFields(name: Names.SEMEN_ANALYSIS_ADDITIONAL_INFO, value: str, personId: self.patientInfo?.id);
            arrOfAttributes.append(attrib.toJSON());
            let name = attrib.name;
            try? realm?.write({
                let str = "personId = '\(idStr)' AND name = '\(name!)'";
                let res = realm?.objects(BasicProfileAttributes.self).filter(str).first;
                if (res == nil) {
                    realm?.add(attrib);
                } else {
                    res?.setFields(name: name!, value: attrib.value, personId: self.patientInfo?.id);
                }
            })
        }


        let url = DAMUrls.urlPatientUpdateProfile();
        let request = ApiServices.createPostRequest(urlStr: url,
                parameters: [Names.PERSON_ATTRIBUTES: arrOfAttributes]);
        AlamofireManager.Manager.request(request).responseString {
            response in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success!"
                    , message: "Fertility Saved successfully.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            print(response.result.value);
        }


    }

    @IBAction func onClickAddMoreAnalaysis(_ sender: UIButton) {

    }

    @IBOutlet weak var collectionViewAnalysisInfo: UICollectionView!
    @IBOutlet weak var eAdditionalInfo: UITextField!
    @IBOutlet weak var sSemenAnalysis: UISwitch!
    @IBOutlet weak var eDoYouTakeHerbalMedicine: UITextField!
    @IBOutlet weak var eAnyMedicationsCurrentlyTaking: UITextField!
    @IBOutlet weak var eSpouseAnyKnownMedicalProblem: UITextField!

    @IBAction func onClickSpouseChancesOfExposure(_ sender: UIButton) {
        let vc: VCListOfCheckboxes = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_LISTOFCHECKBOXES) as! VCListOfCheckboxes;
        vc.arrOfModels = self.arrOfChancesOfExposure;
        vc.tag = VCFertilityProfileViewController.CHANCES_OF_EXPOSURE_SPOUSE;
        vc.delegate = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBOutlet weak var bSpouseChancesOfExposure: UIButton!
    @IBOutlet weak var eSpouseOccupation: UITextField!

    @IBAction func onClickChancesOfExposure(_ sender: UIButton) {
        let vc: VCListOfCheckboxes = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_LISTOFCHECKBOXES) as! VCListOfCheckboxes;
        vc.arrOfModels = self.arrOfChancesOfExposureSpouse;
        vc.tag = VCFertilityProfileViewController.CHANCES_OF_EXPOSURE;
        vc.delegate = self;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBOutlet weak var bChancesOfExposureTo: UIButton!
    @IBOutlet weak var eOccupation: UITextField!
    @IBOutlet weak var sSevereCrampingPelvicPainWithYourPeriods: UISwitch!
    @IBOutlet weak var sNeedMedicationToBringInPeriod: UISwitch!
    @IBOutlet weak var eIntercoursePerWeek: UITextField!
    @IBOutlet weak var eMonthTryingToConceive: UITextField!
    var patientInfo: PersonInfoModel?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.timeZone = Calendar.current.timeZone;
        self.dateFormatter.locale = Calendar.current.locale;
        self.dateFormatter.dateFormat = "dd-MM-yyyy";

        let dict = [0: "Cat Pet",
                    1: "Chemical Industry",
                    2: "Clinical & Lab Healthcare",
                    3: "Dry Cleaning",
                    4: "Dye",
                    5: "Paint",
                    6: "Pesticides",
                    7: "X-Ray"];
        for di in dict {
            let daMo = CheckModel();
            daMo.setFields(di.key, di.value, false);
            self.arrOfChancesOfExposure.append(daMo);
        }

        let dictSpouse = [
            0: "Cat Pet",
            1: "Chemical Industry",
            2: "Clinical & Lab Healthcare",
            3: "Dry Cleaning",
            4: "Dye",
            5: "Hot Baths",
            6: "Hot Furnace",
            7: "Large Amount of Radiation",
            8: "Lengthy Hours with Laptop on the Lap",
            9: "Mumps as a Child",
            10: "Paint",
            11: "Pesticides",
            12: "Regular Cycling",
            13: "Regular Exercise",
            14: "Sauna",
            15: "Tight Underclothing",
            16: "Whirlpool",
            17: "X-Ray"];

        for di in dictSpouse {
            let daMo = CheckModel();
            daMo.setFields(di.key, di.value, false);
            self.arrOfChancesOfExposureSpouse.append(daMo);
        }

        self.apiCallGetFertilityProfile();

    }

    private func apiCallGetFertilityProfile() {

        let res = realm?.objects(BasicProfileAttributes.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if (res != nil) {
            self.pupulateData(Array(res!));
        }


//        let url = DAMUrls.urlPatientFertilityProfile(patientInfo: self.patientInfo);
//        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//        AlamofireManager.Manager.request(request).responseArray {
//            (response: DataResponse<[BasicProfileAttributes]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if (response.response?.statusCode == 200) {
//                self.pupulateData(response.result.value!);
//            }
//        }

    }

    private func pupulateData(_ value: [BasicProfileAttributes]) {

        for attr: BasicProfileAttributes in value {
            switch attr.name! {
            case Names.OCCUPATION:
                self.eOccupation.text = attr.value;
                break;
            case Names.SPOUSEOCCUPATION:
                self.eSpouseOccupation.text = attr.value;
                break;
            case Names.MONTHS_TRYING_TO_CONCEIVE:
                self.eMonthTryingToConceive.text = attr.value;
                break;
            case Names.MEDS_FOR_PERIOD:
                if (attr.value == "0") {
                    self.sNeedMedicationToBringInPeriod.isOn = false;
                } else {
                    self.sNeedMedicationToBringInPeriod.isOn = true;
                }
                break;
            case Names.INTERCOURSE_PER_WEEK:
                self.eIntercoursePerWeek.text = attr.value;
                break;
            case Names.PATIENTCHANCESOFEXPOSURETO:
                self.bChancesOfExposureTo.setTitle(attr.value, for: .normal)
                for obj in self.arrOfChancesOfExposure {
                    let val = attr.value?.contains(obj.value!);
                    if (val != nil && val!) {
                        obj.isChecked = true;
                    }
                }

                break;
            case Names.SPOUSECHANCESOFEXPOSURETO:
                self.bSpouseChancesOfExposure.setTitle(attr.value, for: .normal)

                for obj in self.arrOfChancesOfExposureSpouse {
                    let val = attr.value?.contains(obj.value!);
                    if (val != nil && val!) {
                        obj.isChecked = true;
                    }
                }

                break;
            case Names.SEMEN_ANALYSIS_YN:
                if (attr.value == "0") {
                    self.sSemenAnalysis.isOn = false;
                } else {
                    self.sSemenAnalysis.isOn = true;
                }
                break;
            case Names.SEMEN_ANALYSIS_COUNT:
                // TODO: Semen analysis is a maintenance.
                break;
            case Names.SEMEN_ANALYSIS_MOTILITY:
                // TODO: Semen analysis motility is a maintenance.
                break;
            case Names.SEMEN_ANALYSIS_ADDITIONAL_INFO:
                self.eAdditionalInfo.text = attr.value;
                break;
            case Names.HUSBAND_USE_HERBAL_MEDICATION:
                self.eDoYouTakeHerbalMedicine.text = attr.value;
                break;
            case Names.HUSBAND_CURRENT_MEDICATION:
                self.eAnyMedicationsCurrentlyTaking.text = attr.value;
                break;
            case Names.HUSBAND_CURRENT_MEDICAL_PROBLEMS:
                self.eSpouseAnyKnownMedicalProblem.text = attr.value;
                break;
            case Names.HASPAINFULPERIODS:
                if (attr.value == "0") {
                    self.sSevereCrampingPelvicPainWithYourPeriods.isOn = false;
                } else {
                    self.sSevereCrampingPelvicPainWithYourPeriods.isOn = true;
                }
                break;
            default:
                break;
            }
        }
    }
}

extension VCFertilityProfileViewController: IndicatorInfoProvider, OnListOfCheckBoxListeners {

    func onResult(_ tag: Int, _ models: [CheckModel]?, _ checked: [CheckModel]?, _ stringOfSel: String?) {

        switch tag {
        case VCFertilityProfileViewController.CHANCES_OF_EXPOSURE:
            self.bChancesOfExposureTo.setTitle(stringOfSel, for: .normal);
            break;
        case VCFertilityProfileViewController.CHANCES_OF_EXPOSURE_SPOUSE:
            self.bSpouseChancesOfExposure.setTitle(stringOfSel, for: .normal);
            break;
        default:
            break;
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_FERTILITY_PROFILE);
    }
}
