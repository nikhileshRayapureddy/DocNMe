//
//  VCGynecHistory.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 05/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import DatePickerDialog
import XLPagerTabStrip
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class VCGynecHistory: UIViewController {
    @IBOutlet var indicator: UIActivityIndicatorView?;

    private let realm = try? Realm();

    func getStringFromButton(sender: UIButton) -> String? {
        if (sender.titleLabel?.text == "Date") {
            return nil;
        } else {
            return sender.titleLabel?.text;
        }
    }

    func getStringFromTextField(sender: UITextField) -> String? {
        if (sender.text == "Date") {
            return nil;
        } else {
            return sender.text;
        }
    }

    @IBAction func onClickSaveGynecHistory(_ sender: UIButton) {


        var arrOfAttributes = [BasicProfileAttributes]();

        if let bon = self.getStringFromButton(sender: self.bBoneDensityScanDate) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTBONEDENSITYDATE, value: bon, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        if let lastCopos = self.getStringFromButton(sender: self.bLastColposcopyDate) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTCOLONOSCOPYDATE, value: lastCopos, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        if let lastCopos = self.getStringFromButton(sender: self.bLastCervicalCancerShotDate) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTCERVICALCANCERSHOTDATE, value: lastCopos, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        if let lastCopos = self.getStringFromButton(sender: self.bLastTeanusSmear) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTTETANUSSHOTDATE, value: lastCopos, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        if let lastCopos = self.getStringFromButton(sender: self.bLastPapSmearDate) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTPAPSMEARDATE, value: lastCopos, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        if let lastCopos = self.getStringFromButton(sender: self.bLastMammogramDate) {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTMAMMOGRAMDATE, value: lastCopos, personId: self.patientInfo?.id);
            arrOfAttributes.append(attr);
        }

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.LIFESTYLETIPSINPRESCRIPTION, value:
        (self.sAreYouINterestedInLifeStyleModification.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HABITS, value: self.eHabits.text,
                personId: self.patientInfo?.id));
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.NOOFLIVINGCHILDREN,
                value: self.eCurrentNumberOfLivingChildren.text,
                personId: self.patientInfo?.id));
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.CONGENITALFAMILYDETAILS,
                value: self.eDetail.text, personId: self.patientInfo?.id))
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.CONGENITALANOMALIES, value:
        (self.sCongenitalAnomaliesWithinFamily.isOn ? "1" : "0"), personId: self.patientInfo?.id));
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.PARENTSMARRIAGECONSANGUINEOUS, value:
        (self.sIsYourParentsMarriageConsanguineours.isOn ? "1" : "0"), personId: self.patientInfo?.id));
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.MARRIAGECONSANGUINEOUS, value:
        (self.sIsYourMarriageConsanguineous.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.OTHERHAEMATOLOGYCONDITION,
                value: self.eAnyOtherHaematologicalCondition.text,
                personId: self.patientInfo?.id));

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.PRIMARYMETHODOFBIRTHCONTROL,
                value: self.ePrimaryMethodOfBirthControl.text,
                personId: self.patientInfo?.id));

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.AUTOIMMUNEHAEMATOLOGY, value:
        (self.sAutoimmuneHaematologicalCondition.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.MMRVACCINATION, value:
        (self.sHaveYouGotMmrVaccinationinpast.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.ABNORMALMAMMOGRAMDETAILS,
                value: self.eAnyAbnormalMammogram.text,
                personId: self.patientInfo?.id));
        arrOfAttributes.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.ABNORMALPAPSMEARDETAILS,
                value: self.eAnyAbnormalPapSmears.text,
                personId: self.patientInfo?.id));

        var id: String = "";
        id = (self.patientInfo?.id)!;
        try? self.realm?.write({
            for item in arrOfAttributes {
                var name: String = "";
                name = item.name!;
                let res = realm?.objects(BasicProfileAttributes.self).filter("personId = '\(id)' AND name = '\(name)'").first;
                if res != nil {
                    res?.value = item.value;
                    res?.isUpdated = true;
                } else {
                    realm?.add(item);
                }
            }
        })


//        sender.isEnabled = false;
//        sender.setTitle("saving...", for: .normal);
//        let params = [Names.PERSON_ATTRIBUTES: arrOfAttributes];
//        let url = DAMUrls.urlPatientGynecHistoryUpdate(patientInfo: self.patientInfo);
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: params);
//
//        (request).responseString {
//            response in
//            print(response.result.value ?? "#1");
//            sender.isEnabled = true;
//            sender.setTitle("Save", for: .normal);
//        }


    }

    var patientInfo: PersonInfoModel?;

    @IBOutlet weak var sAreYouINterestedInLifeStyleModification: UISwitch!
    @IBOutlet weak var eHabits: UITextField!
    @IBOutlet weak var eCurrentNumberOfLivingChildren: UITextField!
    @IBOutlet weak var eDetail: UITextField!
    @IBOutlet weak var sCongenitalAnomaliesWithinFamily: UISwitch!
    @IBOutlet weak var sIsYourParentsMarriageConsanguineours: UISwitch!
    @IBOutlet weak var sIsYourMarriageConsanguineous: UISwitch!
    @IBOutlet weak var eAnyOtherHaematologicalCondition: UITextField!
    @IBOutlet weak var sAutoimmuneHaematologicalCondition: UISwitch!
    @IBOutlet weak var ePrimaryMethodOfBirthControl: UITextField!
    @IBOutlet weak var sHaveYouGotMmrVaccinationinpast: UISwitch!
    @IBOutlet weak var bBoneDensityScanDate: UIButton!
    @IBOutlet weak var bLastColposcopyDate: UIButton!
    @IBOutlet weak var bLastCervicalCancerShotDate: UIButton!
    @IBOutlet weak var bLastTeanusSmear: UIButton!

    @IBOutlet weak var eAnyAbnormalMammogram: UITextField!

    @IBOutlet weak var eAnyAbnormalPapSmears: UITextField!
    @IBOutlet weak var bLastPapSmearDate: UIButton!

    @IBOutlet weak var bLastMammogramDate: UIButton!


    var dateFormatter: DateFormatter = DateFormatter();

    @IBAction func bDateOnClick(_ sender: UIButton) {
        self.showTimePicker(button: sender);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeZone = Calendar.current.timeZone;
        dateFormatter.locale = Calendar.current.locale;
        dateFormatter.dateFormat = "dd-MM-yyyy";

//        let date = Date();
//        self.bLastMammogramDate.setTitle(self.dateFormatter.string(from: date), for: .normal);
//        self.bLastPapSmearDate.setTitle(self.dateFormatter.string(from: date), for: .normal);
//        self.bLastTeanusSmear.setTitle(self.dateFormatter.string(from: date), for: .normal);
//        self.bLastCervicalCancerShotDate.setTitle(self.dateFormatter.string(from: date), for: .normal);
//        self.bLastColposcopyDate.setTitle(self.dateFormatter.string(from: date), for: .normal);
//        self.bBoneDensityScanDate.setTitle(self.dateFormatter.string(from: date), for: .normal);


        self.apiCallGynecHistory();

    }

    func apiCallGynecHistory() {

        let results = self.realm?.objects(BasicProfileAttributes).filter("personId = '" + (self.patientInfo?.id!)! + "'");
        self.pupulateData(Array(results!));

//        let url = DAMUrls.urlPatientGynecHistory(patientInfo: patientInfo!);
//        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//
//        (request).responseArray { (response: DataResponse<[BasicProfileAttributes]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                self.pupulateData(response.result.value);
//            }
//        }


    }

    private func pupulateData(_ data: [BasicProfileAttributes]?) {
        for ite: BasicProfileAttributes in data! {
            switch ite.name! {
            case Names.LASTPAPSMEARDATE:
                bLastPapSmearDate.setTitle(ite.value, for: .normal);
                break;
            case Names.ABNORMALPAPSMEARDETAILS:
                eAnyAbnormalPapSmears.text = ite.value;
                break;
            case Names.LASTMAMMOGRAMDATE:
                self.bLastMammogramDate.setTitle(ite.value, for: .normal);
                break;
            case Names.ABNORMALMAMMOGRAMDETAILS:
                self.eAnyAbnormalMammogram.text = ite.value;
                break;
            case Names.LASTTETANUSSHOTDATE:
                self.bLastTeanusSmear.setTitle(ite.value, for: .normal);
                break;
            case Names.LASTCERVICALCANCERSHOTDATE:
                self.bLastCervicalCancerShotDate.setTitle(ite.value, for: .normal);
                break;
            case Names.LASTBONEDENSITYDATE:
                self.bBoneDensityScanDate.setTitle(ite.value, for: .normal);
                break;
            case Names.LASTCOLONOSCOPYDATE:
                self.bLastColposcopyDate.setTitle(ite.value, for: .normal);
                break;
            case Names.AUTOIMMUNEHAEMATOLOGY:
                if (ite.value! == "1") {
                    sAutoimmuneHaematologicalCondition.isOn = true;
                } else {
                    sAutoimmuneHaematologicalCondition.isOn = false
                };
                break;
            case Names.OTHERHAEMATOLOGYCONDITION:
                self.eAnyOtherHaematologicalCondition.text = ite.value;
                break;
            case Names.MARRIAGECONSANGUINEOUS:
                if (ite.value! == "1") {
                    self.sIsYourMarriageConsanguineous.isOn = true;
                } else {
                    sIsYourMarriageConsanguineous.isOn = false
                };
                break;
            case Names.PARENTSMARRIAGECONSANGUINEOUS:
                if (ite.value! == "1") {
                    self.sIsYourParentsMarriageConsanguineours.isOn = true;
                } else {
                    sIsYourParentsMarriageConsanguineours.isOn = false
                };
                break;
            case Names.CONGENITALANOMALIES:
                if (ite.value! == "1") {
                    self.sCongenitalAnomaliesWithinFamily.isOn = true;
                } else {
                    sCongenitalAnomaliesWithinFamily.isOn = false
                };
                break;
            case Names.CONGENITALFAMILYDETAILS:
                self.eDetail.text = ite.value;
                break;
            case Names.NOOFLIVINGCHILDREN:
                self.eCurrentNumberOfLivingChildren.text = ite.value;
                break;
            case Names.HABITS:
                self.eHabits.text = ite.value;
                break;
            case Names.MMRVACCINATION:
                if (ite.value == "1") {
                    self.sHaveYouGotMmrVaccinationinpast.isOn = true;
                } else {
                    sHaveYouGotMmrVaccinationinpast.isOn = false
                };
                break;
            case Names.PRIMARYMETHODOFBIRTHCONTROL:
                self.ePrimaryMethodOfBirthControl.text = ite.value;
                break;
            case Names.LIFESTYLETIPSINPRESCRIPTION:
                if (ite.value! == "1") {
                    self.sAreYouINterestedInLifeStyleModification.isOn = true;
                } else {
                    sAreYouINterestedInLifeStyleModification.isOn = false
                };
                break;
            default:
                print("Some other new property");
                break;
            }

        }
    }

    func showTimePicker(button: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date){
            (date) -> Void in
            if (date != nil) {
                button.setTitle("\(String(describing: self.dateFormatter.string(from: date!)))", for: UIControlState.normal);
            }
        }
    }
}

extension VCGynecHistory: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_GYNECHISTORY);
    }
}
