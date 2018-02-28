//
// Created by Sandeep Rana on 18/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import Dropper
import DatePickerDialog
import RealmSwift
import Toaster

class VCAddFertilityHistory: UIViewController {
    var dateFormatter = DateFormatter()
    let picker = UIPickerView()
    var arrPickerComponents = [String]()
    var currentTextField = UITextField()



    let arrOfTypes = [
        "IUI",
        "Clomiphene citrate with timed Intercourse",
        "CC+ insemination",
        "Daily fertility drug inj. With Insemination",
        "IVF",
        "ICSI"
    ];


    var patientInfo: PersonInfoModel?;

    var onFertilityHistoryAddedListener: OnFertilityHistoryAddedListener?;

    private var dropper: Dropper?;

    @IBOutlet weak var btnDateFrom: UIButton!
    
    @IBOutlet weak var btnDateTo: UIButton!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }

    @IBAction func onClickDateTo(_ sender: UIButton) {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    @IBOutlet weak var bDateTo: UIButton!
    @IBOutlet weak var bDateFrom: UIButton!


    let realm = try? Realm();


    @IBAction func onClickAddButton(_ sender: UIButton) {
        let history = FertilityHistory();
        
        if !((self.eNoofcycles.text?.isEmpty)!) {
        history.pregnant = self.sResultedInPregnancy.isOn ? 1 : 0;
            
            if self.eNoofcycles.text! == "" {
                history.numberOfCycles = 0;
            }else {
                history.numberOfCycles = Int((self.eNoofcycles.text?.description)!)!;
            }
        
        history.treatmentType = self.lTreatmentName.text;
            let dateToInt64:Int64 = (self.dateFormatter.date(from: (bDateTo.titleLabel?.text)!)?.millisecondsSince1970)!;
        history.dateTo = dateToInt64 ;
            let dateFromInt64:Int64 = (self.dateFormatter.date(from: (bDateFrom.titleLabel?.text)!)?.millisecondsSince1970)!;
        history.dateFrom = dateFromInt64;
        history.note = self.eNote.text;
        history.patientPersonId = self.patientInfo?.id;


        try? realm?.write({
            history.isUpdated = true;
            realm?.add(history);
            if onFertilityHistoryAddedListener != nil {
//                self.onFertilityHistoryAddedListener?.onFertilityAdded(history);
            }
            self.navigationController?.popViewController(animated: true);

        })
        }else{
                Toast(text: "No of Cycles can't be Empty!").show();
                return;
        }

//        let url = DAMUrls.urlPatientFertilityHistoryAdd();
//        sender.isEnabled = false;
//        sender.setTitle("Loading...", for: .normal);
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: history.toJSON());
//        AlamofireManager.Manager.request(request).responseObject {
//            (response: DataResponse<FertilityHistory>) in
//
//            sender.isEnabled = true;
//            sender.setTitle("Add", for: .normal);
//
//            if (response.response?.statusCode == 200) {
//                self.onFertilityHistoryAddedListener?.onFertilityAdded(response.result.value);
//                self.navigationController?.popViewController(animated: true);
//            }
//        }
    }

    @IBOutlet weak var sResultedInPregnancy: UISwitch!
    @IBOutlet weak var eNote: UITextField!
    @IBOutlet weak var eNoofcycles: UITextField!
    @IBOutlet weak var lTreatmentName: UITextField!

    @IBAction func onclickTreatmentName(_ sender: UIButton) {
lTreatmentName.becomeFirstResponder()
//        if self.dropper != nil && self.dropper?.status != Dropper.Status.hidden {
//            dropper?.hide();
//        }
//
//        self.dropper = Dropper(width: 200, height: 220)
//
//        self.dropper?.items = self.arrOfTypes;
//        self.dropper?.delegate = self;
//        self.dropper?.show(.left, button: sender);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd-MM-yyyy");
//        let date = Date();
//        self.bDateFrom.setTitle(dateFormatter?.string(from: date), for: .normal);
//        self.bDateTo.setTitle(dateFormatter?.string(from: date), for: .normal);
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self.dateFormatter.dateFormat = "dd/MM/yyyy"

        btnDateFrom.setTitle(self.dateFormatter.string(from: Date()), for: .normal);
        btnDateTo.setTitle(self.dateFormatter.string(from: Date()), for: .normal);
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
        lTreatmentName.inputAccessoryView = toolBar
        
        lTreatmentName.inputView = picker
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


extension VCAddFertilityHistory: DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        self.lTreatmentName.text = contents;
    }
}

extension VCAddFertilityHistory: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == lTreatmentName
        {
            currentTextField = textField
            arrPickerComponents = self.arrOfTypes
            picker.reloadAllComponents()
        }
    }
}

extension VCAddFertilityHistory: UIPickerViewDelegate, UIPickerViewDataSource
{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrOfTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrOfTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
