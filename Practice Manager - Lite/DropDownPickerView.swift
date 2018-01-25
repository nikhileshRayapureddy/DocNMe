//
//  DropDownPickerView.swift
//  Practice Manager - Lite
//
//  Created by Kiran Kumar on 23/01/18.
//  Copyright © 2018 DocNMe. All rights reserved.
//

import UIKit

class DropDownPickerView: UIPickerView {

    var arrPickerComponents = [String]()
    

}

extension DropDownPickerView: UIPickerViewDelegate, UIPickerViewDataSource
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
