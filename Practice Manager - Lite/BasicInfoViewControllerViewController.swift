//
//  BasicInfoViewControllerViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 28/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Dropper
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import Toaster


class BasicInfoViewControllerViewController: UIViewController, IndicatorInfoProvider, DropperDelegate {

    @IBOutlet weak var txtBloodGroupPersonal: UITextField!
    @IBOutlet weak var txtSpouseBloodGroup: UITextField!
    @IBOutlet weak var scrlView: UIScrollView!
    let picker = UIPickerView()
    var arrPickerComponents = [String]()
    var currentTextField = UITextField()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }

    let realm = try? Realm();

    private var arrAttributes: [String: BasicProfileAttributes]? = [String: BasicProfileAttributes]();

    @IBOutlet weak var bSave: UIButton!
    @IBOutlet weak var bOverBlodGroup: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var patientInfo: PersonInfoModel?;
    
    static let TAG_USER = "user";
    static let TAG_SPOUSE = "spouse";
    var dropper: Dropper?;
    var tag = TAG_USER;
    var btnBg = UIButton()
    @IBOutlet weak var bBloodGroupSpouse: UIButton!
    @IBOutlet weak var containerViewSpouse: UIView!

    @IBAction func onClickSaveBasicInfo(_ sender: Any) {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        if self.lPatientOccupation.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            Toast(text: "Patient occupation can contain only numbers and alphabets").show();
            return;
        }

//        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if self.eSpouseName.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            Toast(text: "Spouse ame can contain only numbers and alphabets").show();
            return;
        }

        try? realm?.write({
            if let arrOfAttr: [String: BasicProfileAttributes] = getArrayOfAttributesAfterSettingValuesFromViews() {
                print(arrOfAttr.count);
                var jsonArr = [[String: Any]]();
                for attr in arrOfAttr.values {
                    jsonArr.append(attr.toJSON())
                }

                let personInfoResult = self.realm?.objects(PersonInfoModel.self).filter("id = '" + (self.patientInfo?.id.description)! + "'").first;

                let pregInfo = self.realm?.objects(PregnancyInfo.self).filter("id = '" + (self.patientInfo?.id.description)! + "'").first;

                if (personInfoResult != nil && patientInfo?.mstatus != nil) {
                    personInfoResult?.mstatus = (self.patientInfo?.mstatus)!;
                    if pregInfo != nil {
                        pregInfo?.mstatus = (self.patientInfo?.mstatus)!;
                    }
                }


                let reqObj = [Names.PERSON_ATTRIBUTES: jsonArr];


                for attr in arrOfAttr.values {
                    let resu = realm?.objects(BasicProfileAttributes.self).filter("personId = '" + attr.personId! + "' AND name = '" + attr.name! + "'");
                    if (resu?.count)! > 0 {
                        resu?.first?.value = attr.value;
                        resu?.first?.isUpdated = true;
                    } else {
                        attr.isUpdated = true;
                        realm?.add(attr);
                    }

                }
                DispatchQueue.main.async {
                    let Alert = UIAlertController(title: "Success!", message: "Saved Successfully", preferredStyle: UIAlertControllerStyle.alert)
                    Alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(Alert, animated: true, completion: nil)

                }
                
            }
        });

    }


    private func getArrayOfAttributesAfterSettingValuesFromViews() -> [String: BasicProfileAttributes]? {


        if let atr = self.arrAttributes![Names.Attr.OCCUPATION] {
            atr.value = lPatientOccupation.text
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.OCCUPATION, value: self.lPatientOccupation.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.OCCUPATION] = atr;
        }

        if let atr = self.arrAttributes![Names.Attr.SPOUSENAME] {
            atr.value = self.eSpouseName.text
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.SPOUSENAME, value: self.eSpouseName.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.SPOUSENAME] = atr;
        }

        if let atr = self.arrAttributes![Names.Attr.SPOUSEAGE] {
            atr.value = self.eSpouseAge.text
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.SPOUSEAGE, value: self.eSpouseAge.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.SPOUSEAGE] = atr;
        }
        if let atr = self.arrAttributes![Names.Attr.SPOUSEPHONE] {
            atr.value = String(format: "%@%@", "+91",self.eSpousePhone.text!) //self.eSpousePhone.text
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.SPOUSEPHONE, value: self.eSpousePhone.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.SPOUSEPHONE] = atr;
        }
        if let atr = self.arrAttributes![Names.Attr.SPOUSEBLOODGROUP] {
            atr.value = self.dictBloodGroups[txtSpouseBloodGroup.text!]
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.SPOUSEBLOODGROUP, value: self.dictBloodGroups[txtSpouseBloodGroup.text!], personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.SPOUSEBLOODGROUP] = atr;
        }

        if let atr = self.arrAttributes![Names.Attr.MARRIEDSINCE] {
//            atr.value = self.dictBloodGroups[lBloodGroupSpouse.text!]
            atr.value = self.eAgeOfMarriage.text;
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.MARRIEDSINCE, value: self.eAgeOfMarriage.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.MARRIEDSINCE] = atr;
        }

        if let atr = self.arrAttributes![Names.Attr.AADHAAR] {
            atr.value = self.lAadharCardNumber.text
            atr.isUpdated = true;
        } else {
            let atr = BasicProfileAttributes();
            atr.setFields(name: Names.Attr.AADHAAR, value: self.lAadharCardNumber.text, personId: self.patientInfo?.id);
            self.arrAttributes![Names.Attr.AADHAAR] = atr;
        }


//         if (self.arrAttributes != nil) {
//            for attribute in self.arrAttributes! {
//                switch attribute.name! {
//                case Names.Attr.OCCUPATION:
//                    attribute.value = lPatientOccupation.text;
//                    break;
//                case Names.Attr.SPOUSENAME:
//                    attribute.value = eSpouseName.text;
//                    break;
//                case Names.Attr.SPOUSEAGE:
//                    attribute.value = eSpouseAge.text;
//                    break;
//                case Names.Attr.SPOUSEPHONE:
//                    attribute.value = eSpousePhone.text;
//                    break;
//                case Names.Attr.SPOUSEBLOODGROUP:
//                    attribute.value = dictBloodGroups[lBloodGroupSpouse.text!];
//                    break;
//                case Names.Attr.MARRIEDSINCE:
//                    attribute.value = eAgeOfMarriage.text;
//                    break;
//                case Names.Attr.AADHAAR:
//                    attribute.value = lAadharCardNumber.text;
//                    break;
//                default:
//                    break;
//
//                }
//            }
//        }
        return self.arrAttributes;
    }

    @IBAction func onClickShowSpouseBloodGroupList(_ sender: Any) {
        txtSpouseBloodGroup.becomeFirstResponder()
//        self.closeDropper();
//        btnBg.isHidden = false
//        self.dropper = Dropper(width: 75, height: 250)
//        self.dropper?.items = Array(dictBloodGroups.keys);
//        self.dropper?.delegate = self;
//        self.dropper?.show(Dropper.Alignment.center, button: bBloodGroupSpouse);
//        tag = BasicInfoViewControllerViewController.TAG_SPOUSE;
    }


    func closeDropper() {
        if self.dropper != nil && self.dropper?.status != Dropper.Status.hidden {
            dropper?.hide();
        }
    }

    @IBOutlet weak var eSpousePhone: UITextField!
    @IBOutlet weak var eSpouseAge: UITextField!

    @IBOutlet weak var eAgeOfMarriage: UITextField!
    @IBOutlet weak var eSpouseName: UITextField!

//    @IBOutlet weak var lBloodGroup: UILabel!
    @IBOutlet weak var lPatientOccupation: UITextField!
    @IBOutlet weak var lAadharCardNumber: UITextField!

    @IBAction func indexChanged(_ segmented: UISegmentedControl) {
        indexSelected(selectedIndex: segmented.selectedSegmentIndex);
    }

    func indexSelected(selectedIndex: Int) {
        patientInfo?.mstatus = selectedIndex;
        switch selectedIndex {
        case 0:
            self.containerViewSpouse.isHidden = true;
            break;
        default:
            self.containerViewSpouse.isHidden = false;
            break;
        }
    }

    let bloodGroups = ["A +ve","A -ve","B +ve","B -ve","AB +ve","AB -ve","O +ve","O -ve"]
    let dictBloodGroups = [
        "--": "",
        "A +ve": "A_POSITIVE",
        "A -ve": "A_NEGATIVE",
        "B +ve": "b_POSITIVE",
        "B -ve": "B_NEGATIVE",
        "AB +ve": "AB_POSITIVE",
        "AB -ve": "AB_NEGATIVE",
        "O +ve": "O_POSITIVE",
        "O -ve": "O_NEGATIVE"];

    @IBOutlet weak var bBloodGroup: UIButton!
    @IBOutlet weak var scMaritalStatus: UISegmentedControl!

    @IBAction func onClickBloodGroup(_ sender: Any) {
        txtBloodGroupPersonal.becomeFirstResponder()
//        btnBg.isHidden = false
//        self.closeDropper()
//        self.dropper = Dropper(width: 75, height: 250)
//        self.dropper?.items = Array(dictBloodGroups.keys);
//        self.dropper?.delegate = self;
//
//        self.dropper?.show(Dropper.Alignment.center, button: bOverBlodGroup);
//        tag = BasicInfoViewControllerViewController.TAG_USER;
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        assignPickerForFields()
        btnBg = UIButton(type: .custom)
        btnBg.backgroundColor = .clear
        btnBg.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        btnBg.addTarget(self, action: #selector(btnBgClicked(sender:)), for: .touchUpInside)
        btnBg.isHidden = true
        
        self.view.addSubview(btnBg)
        self.containerViewSpouse.isHidden = true;
//        self.dropper = Dropper(width: 75, height: 250)
//        self.dropper?.items = Array(dictBloodGroups.keys);
//        self.dropper?.delegate = self;
        self.apiCallGetBasicInfo(patientInfo: self.patientInfo!);

        self.getDataFromDB();

        txtSpouseBloodGroup.text = "A +ve"
        txtBloodGroupPersonal.text = "A +ve"
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
        txtBloodGroupPersonal.inputAccessoryView = toolBar
        txtSpouseBloodGroup.inputAccessoryView = toolBar
        
        txtBloodGroupPersonal.inputView = picker
        txtSpouseBloodGroup.inputView = picker
        
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrlView.contentSize = CGSize(width: self.view.frame.size.width, height: 690)
    }
    @objc func btnBgClicked(sender:UIButton)
    {
        sender.isHidden = true
        if !(dropper?.status == Dropper.Status.hidden) {
            dropper?.hide();
        }

    }
    func getDataFromDB() {
        let results = realm?.objects(BasicProfileAttributes.self).filter("personId = '" + (self.patientInfo?.id)! + "'");
        if results != nil && (results?.count)! > 0 {
            self.arrAttributes?.removeAll();
            for attr in results! {
                if attr.name != nil {
                    let attribute = BasicProfileAttributes()
                    attribute.setFields(attribute: attr)
                    self.arrAttributes![(attr.name?.description)!] = attribute;
                }
            }
            self.populateData(data: Array((self.arrAttributes?.values)!));
        }

    }

    func apiCallGetBasicInfo(patientInfo: PersonInfoModel) {


        if ((patientInfo.mstatus) != nil) {
            switch (patientInfo.mstatus) {
            case 0:
//                Single
                self.indexSelected(selectedIndex: 0);
                self.scMaritalStatus.selectedSegmentIndex = 0;
                break;
            case 1:
                self.scMaritalStatus.selectedSegmentIndex = 1;
                self.indexSelected(selectedIndex: 1);
//                married
                break;
            case 2:
                self.scMaritalStatus.selectedSegmentIndex = 2;
                self.indexSelected(selectedIndex: 2);
                break;
            default:
                self.scMaritalStatus.selectedSegmentIndex = 3;
                self.indexSelected(selectedIndex: 3);
                break;
            }

        }


        let url = DAMUrls.urlPatientBasicProfile(patientInfo: patientInfo);
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
//        URLCache.shared.removeAllCachedResponses()
        Utility.showProgressForIndicator(self.indicator, true);
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[BasicProfileAttributes]>) in
            Utility.showProgressForIndicator(self.indicator, false);
            if response.response?.statusCode == 200 && response.result.value != nil {
                print("Response : BasicInfo success!");
                self.checkAndStoreToData((response.result.value!))
            } else {
                print(response.response?.statusCode.description);
                print("Response : BasicInfo failed!");
            }
        }
    }

    private func checkAndStoreToData(_ list: [BasicProfileAttributes]) {

        do {
            try realm?.write({
                for item in list {
                    let res = self.realm?.objects(BasicProfileAttributes.self).filter("personId = '\((self.patientInfo?.id)!)' AND name = '\((item.name)!)'").first;
                    if res == nil {
                        self.realm?.add(item);
                    } else {
                        if res?.isUpdated == false {
                            /*  res?.id = item.id;
                            */  //res?.value = item.value;
                            self.realm?.delete(res!);
                            self.realm?.add(item);
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
        let results = self.realm?.objects(BasicProfileAttributes.self).filter("personId = '\((self.patientInfo?.id)!)'");
        if results != nil {
            self.populateData(data: Array(results!));
        }
    }


    func populateData(data: [BasicProfileAttributes]) {
//        self.arrAttributes = data;
        for attribute in data {
            switch attribute.name! {
            case Names.Attr.OCCUPATION:
                lPatientOccupation.text = attribute.value!;
                break;
            case Names.Attr.SPOUSENAME:
                eSpouseName.text = attribute.value!;
                break;
            case Names.Attr.SPOUSEAGE:
                eSpouseAge.text = attribute.value!;
                break;
            case Names.Attr.SPOUSEPHONE:
                if (attribute.value?.contains("+"))! == true
                {
                    let index = attribute.value?.index((attribute.value?.startIndex)!, offsetBy: 3)
                    var code = ""
                    code = (attribute.value?.substring(to: index!))!
                    eSpousePhone.text = attribute.value?.replacingOccurrences(of: code, with: "")
                }
                else
                {
                    eSpousePhone.text = attribute.value
                }

                eSpousePhone.text = attribute.value!;
                break;
            case Names.Attr.SPOUSEBLOODGROUP:
                if let index = dictBloodGroups.values.index(of: attribute.value!) {
                    let key = dictBloodGroups.keys[index]
                    txtSpouseBloodGroup.text = key
                }
                break;
            case Names.Attr.MARRIEDSINCE:
                eAgeOfMarriage.text = attribute.value!;
                break;
            case Names.Attr.AADHAAR:
                lAadharCardNumber.text = attribute.value!;
                break;
            default:
                break;

            }
        }
    }


    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_BASIC_INFO);
    }

//    @IBOutlet weak var lBloodGroupSpouse: UILabel!
}

extension BasicInfoViewControllerViewController {

    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        print("printe it");

        switch self.tag {
        case BasicInfoViewControllerViewController.TAG_USER:
            txtBloodGroupPersonal.text = contents;
            break;
        default:
            txtSpouseBloodGroup.text = contents;
            break;
        }

        if !(dropper?.status == Dropper.Status.hidden) {
            dropper?.hide();
        }

    }

}

extension BasicInfoViewControllerViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == lPatientOccupation) || (textField == eSpouseName)
        {
            if string.characters.count == 0
            {
                return true
            }
            else
            {
                if ACCEPTABLE_CHARACTER_ONLYLETTERS.contains(string)
                {
                    return true
                }
                else
                {
                    return false
                }
            }
        }
        else if textField == lAadharCardNumber
        {
            if string.characters.count == 0
            {
                return true
            }
            else
            {
                if ACCEPTABLE_CHARECTERS_WORDS.contains(string)
                {
                    return true
                }
                else
                {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtBloodGroupPersonal
        {
            currentTextField = textField
            arrPickerComponents = bloodGroups
            picker.reloadAllComponents()
        }
        if textField == txtSpouseBloodGroup
        {
            currentTextField = textField
            arrPickerComponents = bloodGroups
            picker.reloadAllComponents()
        }
    }
}

extension BasicInfoViewControllerViewController: UIPickerViewDelegate, UIPickerViewDataSource
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
