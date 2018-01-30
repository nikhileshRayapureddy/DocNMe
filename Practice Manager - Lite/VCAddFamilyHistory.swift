//
//  VCFamilyHistory.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 12/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Dropper
import DatePickerDialog
import RealmSwift
import Toaster

class VCAddFamilyHistory: UIViewController {

    let realm = try? Realm();
    let picker = UIPickerView()
    var arrPickerComponents = [String]()
    var currentTextField = UITextField()

    @IBOutlet weak var eConditions: UITextField!
    @IBOutlet weak var eAge: UITextField!
    @IBOutlet weak var lRelationLabel: UITextField!

    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            viewWrapperCauseOfDeath.isHidden = true;
        } else {
            viewWrapperCauseOfDeath.isHidden = false;
        }
    }

    @IBOutlet weak var sStatus: UISwitch!
    @IBOutlet weak var viewWrapperCauseOfDeath: UIView!

    @IBOutlet weak var eCauseOfDeath: UITextField!
    private var dropper: Dropper?;

    var patientInfo: PersonInfoModel?;

    var onFamilyHistoryAddedListener: OnFamilyHistoryAddedListener?;

    @IBAction func onClickSelectRelation(_ sender: UIButton) {
        lRelationLabel.becomeFirstResponder()
//        if (self.dropper != nil) {
//            self.dropper?.hide();
//        }
//        self.dropper = Dropper.init(width: 140, height: 200);
//        self.dropper?.items = Array(self.dictRelations.keys);
//        self.dropper?.delegate = self;
//        self.dropper?.show(.left, button: sender);
    }

    @IBAction func onClickSaveRelation(_ sender: UIButton) {


        if(self.eAge.text!.characters.count < 1 ){
            Toast(text: "Age is required!").show();
            return;
        }


        let relation: FamilyMember = FamilyMember();
        relation.personId = self.patientInfo?.id;
        relation.relation = self.lRelationLabel.text;
        relation.isalive = self.sStatus.isOn ? "1" : "0";
        relation.age = self.eAge.text;
        relation.conditions = self.eConditions.text;
        relation.isUpdated = true;


        try? realm?.write({
            realm?.add(relation);
            self.onFamilyHistoryAddedListener?.onFamilyMemberAdded(relation);

            self.navigationController?.popViewController(animated: true);
        })


////        print(relation.toJSONString());
//        let url = DAMUrls.urlPatientAddFamilyHistory();
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: [relation.toJSON()]);
//
//        sender.setTitle("saving...", for: .normal);
//        sender.isEnabled = false;
//
//        AlamofireManager.Manager.request(request).responseArray {
//            (response: DataResponse<[FamilyMember]>) in
//            print(response.result.value?.description);
//            if (response.response?.statusCode == 200) {
//                sender.setTitle("Save", for: .normal);
//                sender.isEnabled = true;
//                self.onFamilyHistoryAddedListener?.onFamilyMemberAdded((response.result.value?[0])!);
//                self.navigationController?.popViewController(animated: true);
//            }
//
//        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }


    let dictRelations = [
        "Father": "FATHER",
        "Mother": "MOTHER",
        "Brother": "BROTHER",
        "Sister": "SISTER",
        "Paternal Grandfather": "PGRANDFATHER",
        "Paternal Grandmother": "PGRANDMOTHER",
        "Maternal Grandfather": "MGRANDFATHER",
        "Maternal Grandmother": "MGRANDMOTHER",
        "Other": "OTHER"
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        assignPickerForFields()
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
        lRelationLabel.inputAccessoryView = toolBar
        lRelationLabel.inputView = picker
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

}

extension VCAddFamilyHistory: DropperDelegate {

    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        self.lRelationLabel.text = contents;
    }
}

extension VCAddFamilyHistory: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == lRelationLabel
        {
            currentTextField = textField
            arrPickerComponents = Array(self.dictRelations.keys);
            picker.reloadAllComponents()
        }
    }
}

extension VCAddFamilyHistory: UIPickerViewDelegate, UIPickerViewDataSource
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
