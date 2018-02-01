//
// Created by Sandeep Rana on 26/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Dropper
import Toaster

class VCAddResult: UIViewController {
    @IBOutlet weak var eName: UITextField!;
    @IBOutlet weak var switchNormal: UISwitch!;
    @IBOutlet weak var eObservations: UITextField!;

    @IBOutlet weak var bAddResult: UIButton!
    private var dropper: Dropper?;

    let picker = UIPickerView()
    var arrPickerComponents = [String]()
    var currentTextField = UITextField()

    @IBAction func onChangeTestAll(_ sender: UITextField) {
//        print(sender.text);
        let str = sender.text;
        if ((str?.characters.count)! > 0) {
            self.bAddResult.isEnabled = true;
        } else {
            self.bAddResult.isEnabled = false;
        }
    }

    public var personInfo: PersonInfoModel?;

    public var onAddedResult: OnResultAddedListener?;

    @IBAction func onClickAddButton(_ sender: UIButton) {

        if (self.eName.text?.isEmpty)! {
            Toast(text: "Name can't be empty!").show();
            return;
        }

        if (self.eObservations.text?.isEmpty)! {
            Toast(text: "Observations can't be empty!").show();
            return;
        }

        let result = Result();
        result.name = self.eName.text;
        let normalicy = self.switchNormal.isOn ? "1" : "0";
        result.results = "\(normalicy)||\(self.eObservations.text!)";
        if self.onAddedResult != nil {
            self.onAddedResult?.onAdded(result);
        }
        self.navigationController?.popViewController(animated: true);
    }

    @IBAction func onClickDropDown(_ sender: UIButton) {
        eName.becomeFirstResponder()
//        Utility.hideDropper(self.dropper);
//        self.dropper = Dropper(width: 100, height: 200);
//        self.dropper?.delegate = self;
//        self.dropper?.items = Loaders.listResults;
//        self.dropper?.show(.left, button: sender);
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Result"
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
        eName.inputAccessoryView = toolBar
        eName.inputView = picker
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

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        Utility.hideDropper(self.dropper);
//    }
}

extension VCAddResult: DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        self.eName.text = Loaders.listResults[path.row];
    }
}

extension VCAddResult: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == eName
        {
            currentTextField = textField
            arrPickerComponents = Loaders.listResults
            picker.reloadAllComponents()
        }
    }
}

extension VCAddResult: UIPickerViewDelegate, UIPickerViewDataSource
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
