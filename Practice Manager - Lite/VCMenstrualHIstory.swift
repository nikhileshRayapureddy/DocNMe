//
//  VCMenstrualHIstory.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 06/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import AlamofireObjectMapper
import Dropper
import DatePickerDialog
import RealmSwift

class VCMenstrualHIstory: UIViewController {

    @IBOutlet var indicator: UIActivityIndicatorView?;

    var tag: Int = 0;
    static let TYPE_MENSES_IN_YEAR: Int = 0;
    static let TYPE_DAYSPERIODLASTS: Int = 1;
    static let TYPE_QUALITY_OF_FLOW: Int = 2;
    static let TYPE_FREQU_OF_PERIODS: Int = 3;
    let dateFormatter = DateFormatter();

    private let realm = try? Realm();
    let picker = UIPickerView()
    var arrPickerComponents = [String]()
    var currentTextField = UITextField()

    @IBOutlet weak var sVaginalDryness: UISwitch!
    @IBOutlet weak var sTakingHormoneReplacement: UISwitch!
    @IBOutlet weak var sHavePainOrPeriods: UISwitch!
    @IBOutlet weak var sChronicConstipationOrDiarrhea: UISwitch!
    @IBOutlet weak var sPassClots: UISwitch!
    @IBOutlet weak var sAreThereAnyMenopausalSymptoms: UISwitch!
    @IBOutlet weak var sAreYouTryingToGetPregnant: UISwitch!
    @IBOutlet weak var sIsThereBloodInUrine: UISwitch!
    @IBOutlet weak var sGetUpMultiTimesAtNightToUrinate: UISwitch!
    @IBOutlet weak var sMissSchoolWorkMonthly: UISwitch!
    @IBOutlet weak var sExperienceHotFlashes: UISwitch!
    @IBOutlet weak var sFacingInfertilityIssues: UISwitch!
    @IBOutlet weak var lAgeMensesInYears: UITextField!
    @IBOutlet weak var lFrequencyOfPeriod: UITextField!
    @IBOutlet weak var lDaysPeriodLasts: UITextField!
    @IBOutlet weak var lQuantityOfFlow: UITextField!
    @IBOutlet weak var sAreYourMensesRegular: UISwitch!
    @IBOutlet weak var sFrequentHeadaches: UISwitch!
    @IBOutlet weak var sSpotOrBleedBetweenPeriods: UISwitch!
    
    @IBOutlet weak var eMensesDetailWasItNormal: UITextField!
    @IBOutlet weak var bLastMensesDate: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    let listQualityOfFlow = ["Scanty": "scanty",
                             "Average": "average",
                             "Heavy": "heavy",
                             "With Clots": "withclots"];
    
    let listFreqOfPeriods: Dictionary = ["Less than 20 days apart": "LT20",
                                         "Between 20-22 days apart": "LT22",
                                         "Between 23-25 days apart": "LT25",
                                         "Between 26-28 days apart": "LT28",
                                         "Between 28-30 days apart": "LT30",
                                         "Between 30-35 days apart": "LT35",
                                         "Between 35-40 days apart": "LT40",
                                         "More than 40 days apart": "GT40"];
    
    let listDaysPeriodLasts = ["2 days": "LT02",
                               "3 days": "LT03",
                               "4 days": "LT04",
                               "5 days": "LT05",
                               "6 days": "LT06",
                               "7 days": "LT07",
                               "Between 7-10 days": "GT07",
                               "More than 10 days": "GT10"];
    
    let listAgeAtMenses: Dictionary = ["9": "1",
                                       "10": "2",
                                       "11": "3",
                                       "12": "4",
                                       "13": "5",
                                       "14": "6",
                                       "15": "7",
                                       "16": "8",
                                       "17": "9",
                                       "18": "10",
                                       "19": "11"];
    
    let arrAgeMensus = ["9","10","11","12","13","14","15","16","17","18","19"]
    var dropper: Dropper?;

    @IBAction func onSelectLastMensesDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }

    @IBAction func onClickSaveButton(_ sender: UIButton) {

        var arrOfAttr = [BasicProfileAttributes]();
        if let data = self.lAgeMensesInYears.text {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.MENSESONSETAGE, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }
        if let data = self.listFreqOfPeriods[self.lFrequencyOfPeriod.text!] {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.PERIODFREQUENCY, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }

        if let data = self.bLastMensesDate.titleLabel?.text {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.LASTMENSESDATE, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }

        if let data = self.eMensesDetailWasItNormal.text {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.MENSESDETAILS, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }


        if let data = self.lDaysPeriodLasts.text {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.PERIODDURATION, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }

        if let data = self.lQuantityOfFlow.text {
            let attr = BasicProfileAttributes();
            attr.setFields(name: Names.QUANTITYFLOW, value: data, personId: self.patientInfo?.id);
            arrOfAttr.append(attr);
        }

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASREGULAR,
                value: (sAreYourMensesRegular.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASFREQUENTHEADACHES,
                value: (self.sFrequentHeadaches.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASSPOTORBLOOD,
                value: (self.sSpotOrBleedBetweenPeriods.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASINFERTILITYISSUES,
                value: (self.sFacingInfertilityIssues.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASHOTFLASHES,
                value: (self.sExperienceHotFlashes.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.MISSESWORK,
                value: (self.sMissSchoolWorkMonthly.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.URINATESMULTIPLETIMESNIGHT,
                value: (self.sGetUpMultiTimesAtNightToUrinate.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASBLOODINURINE,
                value: (self.sIsThereBloodInUrine.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.ISTRYINGPREGNANCY,
                value: (self.sAreYouTryingToGetPregnant.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.MENOPAUSALSYMPTOMS,
                value: (self.sAreThereAnyMenopausalSymptoms.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASCLOTS,
                value: (self.sPassClots.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASCHRONICCONSTIPATION,
                value: (self.sChronicConstipationOrDiarrhea.isOn ? "1" : "0"), personId: self.patientInfo?.id));

        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASPAINFULPERIODS,
                value: (self.sHavePainOrPeriods.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.ISONHRT,
                value: (self.sTakingHormoneReplacement.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        arrOfAttr.append(BasicProfileAttributes().setFieldsAndGetSelf(name: Names.HASDRYNESS,
                value: (self.sVaginalDryness.isOn ? "1" : "0"), personId: self.patientInfo?.id));


        var id: String = "";
        id = (self.patientInfo?.id)!;
        try? self.realm?.write({
            for item in arrOfAttr {
                var nam: String = "";
                nam = item.name!;
                let res = realm?.objects(BasicProfileAttributes.self).filter("personId = '\(id)' AND name = '\(nam)'").first;
                if res != nil {
                    res?.value = item.value;
                    res?.isUpdated = true;
                } else {
                    realm?.add(item);
                }
            }
        })
        
        self.apiCallGetMenstrualHistory();

//        let url = DAMUrls.urlPatientMenstrualHistoryAdd();
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: [Names.PERSON_ATTRIBUTES: arrOfAttr]);

//        sender.isEnabled = false;
//        sender.setTitle("loading...", for: .normal);
//
//        AlamofireManager.Manager.request(request).responseString {
//            response in
//            print(response.result.value);
//
//            sender.isEnabled = true;
//            sender.setTitle("Save", for: .normal);
//        }


    }

    @IBAction func selectMensesInYears(_ sender: UIButton) {
        lAgeMensesInYears.becomeFirstResponder()
//        self.closeDropper();
//        dropper = Dropper(width: 75, height: 250);
//        dropper?.items = Array(listAgeAtMenses.keys);
//        dropper?.delegate = self;
//        dropper?.show(Dropper.Alignment.right, button: sender);
//        tag = VCMenstrualHIstory.TYPE_MENSES_IN_YEAR;
    }

    @IBAction func selectFrequencyOfYourPeriod(_ sender: UIButton) {
        lFrequencyOfPeriod.becomeFirstResponder()
//        self.closeDropper();
//        dropper = Dropper(width: 180, height: 250);
//        dropper?.items = Array(listFreqOfPeriods.keys);
//        dropper?.delegate = self;
//        dropper?.show(Dropper.Alignment.right, button: sender);
//        tag = VCMenstrualHIstory.TYPE_FREQU_OF_PERIODS;
    }

    @IBAction func selectDaysDoesPeriodLast(_ sender: UIButton) {
        lDaysPeriodLasts.becomeFirstResponder()
//        self.closeDropper();
//        dropper = Dropper(width: 180, height: 250);
//        dropper?.items = Array(listDaysPeriodLasts.keys);
//        dropper?.delegate = self;
//        dropper?.show(Dropper.Alignment.right, button: sender);
//        tag = VCMenstrualHIstory.TYPE_DAYSPERIODLASTS;
    }

    @IBAction func selectQuantityOfFlow(_ sender: UIButton) {
        lQuantityOfFlow.becomeFirstResponder()
//        self.closeDropper();
//        dropper = Dropper(width: 130, height: 250);
//        dropper?.items = Array(listQualityOfFlow.keys);
//        dropper?.delegate = self;
//        dropper?.show(Dropper.Alignment.right, button: sender);
//        tag = VCMenstrualHIstory.TYPE_QUALITY_OF_FLOW;
    }

    func closeDropper() {
        if self.dropper != nil && self.dropper?.status != Dropper.Status.hidden {
            dropper?.hide();
        }
    }


    var patientInfo: PersonInfoModel?;

    func onTouchScrollView(_ gesture: UITapGestureRecognizer) {
        Utility.hideDropper(self.dropper);
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        let recogN = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)));
        recogN.cancelsTouchesInView = false;
        scrollView.addGestureRecognizer(recogN);


        dateFormatter.dateFormat = "dd-MM-yyyy";
        dateFormatter.timeZone = Calendar.current.timeZone;
        dateFormatter.locale = Calendar.current.locale;
        assignPickerForFields()
        self.apiCallGetMenstrualHistory();
    }

    func assignPickerForFields()
    {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(sender:)))
        let flexiSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(sender:)))
        
        toolBar.items = [cancelButton,flexiSpace,flexiSpace,doneButton]
        toolBar.tintColor = UIColor.init(red: 32.0/255.0, green: 148.0/255.0, blue: 135.0/255.0, alpha: 1.0)
        
        picker.delegate = self
        picker.dataSource = self
        lAgeMensesInYears.inputAccessoryView = toolBar
        lAgeMensesInYears.inputView = picker
        
        lFrequencyOfPeriod.inputAccessoryView = toolBar
        lDaysPeriodLasts.inputAccessoryView = toolBar
        lQuantityOfFlow.inputAccessoryView = toolBar
        
        lFrequencyOfPeriod.inputView = picker
        lDaysPeriodLasts.inputView = picker
        lQuantityOfFlow.inputView = picker
    }
    
    func doneButtonTapped(sender: UIButton)
    {
        currentTextField.text = arrPickerComponents[picker.selectedRow(inComponent: 0)]
        arrPickerComponents.removeAll()
        picker.reloadAllComponents()
        currentTextField.resignFirstResponder()
    }
    
    func cancelButtonTapped(sender: UIButton)
    {
        arrPickerComponents.removeAll()
        picker.reloadAllComponents()
        currentTextField.resignFirstResponder()
    }

    func apiCallGetMenstrualHistory() {

        let results = self.realm?.objects(BasicProfileAttributes).filter("personId = '" + (self.patientInfo?.id!)! + "'");
        if (results != nil) {
            self.pupulateData(Array(results!));
        }

        let alert = UIAlertController(title: "Success", message: "History saved successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
//        let url = DAMUrls.urlPatientMenstrualHistory(patientInfo: self.patientInfo!);
//        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
//        Utility.showProgressForIndicator(self.indicator, true);
//        AlamofireManager.Manager.request(request).responseArray { (response: DataResponse<[BasicProfileAttributes]>) in
//            Utility.showProgressForIndicator(self.indicator, false);
//            if response.response?.statusCode == 200 {
//                self.pupulateData(response.result.value);
//            }
//        };
    }

    private func pupulateData(_ data: [BasicProfileAttributes]?) {
        for ite: BasicProfileAttributes in data! {

            switch ite.name! {
            case Names.MENSESONSETAGE:
                self.lAgeMensesInYears.text = ite.value!;
                break;
            case Names.PERIODFREQUENCY:
                self.lFrequencyOfPeriod.text = ite.value!;
                break;
            case Names.PERIODDURATION:
                self.lDaysPeriodLasts.text = ite.value;
                break;
            case Names.HASREGULAR:
                if (ite.value! == "1") {
                    self.sAreYourMensesRegular.isOn = true;
                } else {
                    self.sAreYourMensesRegular.isOn = false;
                }
                break;
            case Names.LASTMENSESDATE:
                if ite.value != nil && (ite.value?.isNumeric)! {
                    let date = Date.init(milliseconds: Int64(ite.value!)!);
                    self.bLastMensesDate.setTitle(self.dateFormatter.string(from: date), for: .normal);
                } else {
                    self.bLastMensesDate.setTitle(ite.value, for: .normal);
                }

                break;
            case Names.MENSESDETAILS:
                self.eMensesDetailWasItNormal.text = ite.value!;
                break;
            case Names.HASCLOTS:

                if (ite.value! == "1") {
                    self.sPassClots.isOn = true;
                } else {
                    self.sPassClots.isOn = false;
                }
                break;
            case Names.MISSESWORK:

                if (ite.value! == "1") {
                    self.sMissSchoolWorkMonthly.isOn = true;
                } else {
                    self.sMissSchoolWorkMonthly.isOn = false;
                }
                break;
            case Names.HASSPOTORBLOOD:

                if (ite.value! == "1") {
                    self.sSpotOrBleedBetweenPeriods.isOn = true;
                } else {
                    self.sSpotOrBleedBetweenPeriods.isOn = false;
                }
                break;
            case Names.HASPAINFULPERIODS:

                if (ite.value! == "1") {
                    self.sHavePainOrPeriods.isOn = true;
                } else {
                    self.sHavePainOrPeriods.isOn = false;
                }
                break;
            case Names.HASBLOODINURINE:

                if (ite.value! == "1") {
                    self.sIsThereBloodInUrine.isOn = true;
                } else {
                    self.sIsThereBloodInUrine.isOn = false;
                }
                break;
            case Names.HASHOTFLASHES:

                if (ite.value! == "1") {
                    self.sExperienceHotFlashes.isOn = true;
                } else {
                    self.sExperienceHotFlashes.isOn = false;
                }
                break;
            case Names.HASDRYNESS:

                if (ite.value! == "1") {
                    self.sVaginalDryness.isOn = true;
                } else {
                    self.sVaginalDryness.isOn = false;
                }
                break;
            case Names.MENOPAUSALSYMPTOMS:

                if (ite.value! == "1") {
                    self.sAreThereAnyMenopausalSymptoms.isOn = true;
                } else {
                    self.sAreThereAnyMenopausalSymptoms.isOn = false;
                }
                break;
            case Names.URINATESMULTIPLETIMESNIGHT:
                if (ite.value! == "1") {
                    self.sGetUpMultiTimesAtNightToUrinate.isOn = true;
                } else {
                    self.sGetUpMultiTimesAtNightToUrinate.isOn = false;
                }
                break;
            case Names.HASFREQUENTHEADACHES:

                if (ite.value! == "1") {
                    self.sFrequentHeadaches.isOn = true;
                } else {
                    self.sFrequentHeadaches.isOn = false;
                }
                break;
            case Names.HASCHRONICCONSTIPATION:

                if (ite.value! == "1") {
                    self.sChronicConstipationOrDiarrhea.isOn = true;
                } else {
                    self.sChronicConstipationOrDiarrhea.isOn = false;
                }
                break;
            case Names.ISTRYINGPREGNANCY:

                if (ite.value! == "1") {
                    self.sAreYouTryingToGetPregnant.isOn = true;
                } else {
                    self.sAreYouTryingToGetPregnant.isOn = false;
                }
                break;
            case Names.HASINFERTILITYISSUES:

                if (ite.value! == "1") {
                    self.sFacingInfertilityIssues.isOn = true;
                } else {
                    self.sFacingInfertilityIssues.isOn = false;
                }
                break;
            case Names.ISONHRT:

                if (ite.value! == "1") {
                    self.sTakingHormoneReplacement.isOn = true;
                } else {
                    self.sTakingHormoneReplacement.isOn = false;
                }
                break;
            case Names.QUANTITYFLOW:
                self.lQuantityOfFlow.text = ite.value!;
                break;
//            case Names.LASTMENSUSDATE:
//                self.bLastMensesDate.setTitle(ite.value!,for: .normal);
//                break;
            default:
                break;
            }


        }
    }
}

extension VCMenstrualHIstory: IndicatorInfoProvider, DropperDelegate {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_MENSTRUALHISTORY);
    }

    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        print("printe it");

        switch self.tag {
        case VCMenstrualHIstory.TYPE_MENSES_IN_YEAR:
            lAgeMensesInYears.text = contents;
            break;
        case VCMenstrualHIstory.TYPE_QUALITY_OF_FLOW:
            lQuantityOfFlow.text = contents;
            break;
        case VCMenstrualHIstory.TYPE_DAYSPERIODLASTS:
            lDaysPeriodLasts.text = contents;
            break;
        case VCMenstrualHIstory.TYPE_FREQU_OF_PERIODS:
            lFrequencyOfPeriod.text = contents;
            break;
        default:
            lAgeMensesInYears.text = contents;
        }

//        if !(dropper.status == Dropper.Status.hidden) {
//            dropper.hide();
//        }

    }

}

extension Dictionary {
    func findKeyForValue(value: String, dictionary: [String: [String]]) -> String? {
        for (key, array) in dictionary {
            if (array.contains(value)) {
                return key
            }
        }

        return nil
    }
}

extension VCMenstrualHIstory: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == lAgeMensesInYears
        {
            currentTextField = textField
            arrPickerComponents = arrAgeMensus
            picker.reloadAllComponents()
        }
        if textField == lFrequencyOfPeriod
        {
            currentTextField = textField
            arrPickerComponents = Array(listFreqOfPeriods.keys);
            picker.reloadAllComponents()
        }
        if textField == lDaysPeriodLasts
        {
            currentTextField = textField
            arrPickerComponents = Array(listDaysPeriodLasts.keys);
            picker.reloadAllComponents()
        }
        if textField == lQuantityOfFlow
        {
            currentTextField = textField
            arrPickerComponents = Array(listQualityOfFlow.keys)
            picker.reloadAllComponents()
        }
    }
}

extension VCMenstrualHIstory: UIPickerViewDelegate, UIPickerViewDataSource
{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPickerComponents.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPickerComponents[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
