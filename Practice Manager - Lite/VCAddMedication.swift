//
// Created by Sandeep Rana on 11/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox
import DatePickerDialog
import Dropper
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import SearchTextField
import Toaster

class VCAddMedication: UIViewController {

    static let DROPPER_SCHEDULE = 1;
    static let DROPPER_TYPE = 0;
    private var dateFormatter: DateFormatter?;

    private var dropper: Dropper?;

    @IBOutlet weak var bAddMedication: UIButton!
    @IBAction func onMedicineNameChanged(_ sender: SearchTextField) {
        let str:String = sender.text!;
        if (str.count <= 0){
            self.bAddMedication.isEnabled = false;
        }else{
            self.bAddMedication.isEnabled = true;
        }
    }
    private let arrTypes = [
        "-Select-",
        "Syrup",
        "Tablet",
        "Capsule",
        "Infusion",
        "Suspension",
        "Injection",
        "Powder",
        "Gel",
        "Drop",
        "Mouth Wash/Gargle",
        "Cream",
        "Ointment",
        "Kit",
        "Shampoo",
        "Solution",
        "Lotion",
        "Soap/Bar",
        "Sachet",
        "Expectorant",
        "Rotacap",
        "Inhaler",
        "Emulsion",
        "Granules",
        "Lozenges",
        "Pessary",
        "Suppository",
        "Linctus",
        "Spray",
        "Tooth Paste",
        "Respules",
        "Pen",
        "Elixir",
        "Gum Paint",
        "Mouth Paint",
        "Aplicap",
        "Glue",
        "Gum Astringent",
        "Enema",
        "Patch",
        "Oil",
        "DROPS",
        "DROPS",
        "TAB",
        "OINT",
        "CAP",
        "SYP",
        "INJ",
        "SOAP",
        "SUSP",
        "GARGLE",
        "SOFTULES",
        "LIQUID",
        "VACCINE",
        "JELLY"
    ];

    let listSchedule = [
        "As desired",
        "As needed (S.O.S)",
        "Fixed time",
        "Meals Based",
        "Once a day",
        "Every hour",
        "Every other hour",
        "Every morning",
        "Every night",
        "Twice a day",
        "Three times a day",
        "Four times a day"
    ];


    var patientInfo: PersonInfoModel?;

    var listenerOnMedicationAdded: OnMedicationAddedListener?;

    private let realm = try? Realm();

    @IBAction func onClickDateExactTime(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) {
            (date) -> Void in
            if (date != nil) {
                
                sender.setTitle(Utility.getDateFormatter(dateFormat: "hh:mm aa").string(from: date!), for: .normal);
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }

    @IBOutlet weak var bDateExactTime: UIButton!
    @IBOutlet weak var viewWrapper: UIView!

    @IBOutlet weak var sDinner: UISwitch!
    @IBOutlet weak var sLunch: UISwitch!
    @IBOutlet weak var sBreakfast: UISwitch!


    @IBOutlet weak var bemDinner: BEMCheckBox!
    @IBOutlet weak var bemLunch: BEMCheckBox!
    @IBOutlet weak var bemBreakfast: BEMCheckBox!
    @IBOutlet weak var scrollView: UIScrollView!

    var type = 0;

    @IBAction func onClickSelectSchedule(_ sender: UIButton) {
        Utility.hideDropper(dropper);
        self.type = VCAddMedication.DROPPER_SCHEDULE;
        self.dropper = Dropper(width: 200, height: 220)
        self.dropper?.items = self.listSchedule;
        self.dropper?.delegate = self;
        self.dropper?.show(.center, button: sender);

    }

    @IBAction func onSearchStringChanged(_ sender: UITextField) {
        print(sender.text);
        let predicate = NSPredicate(format: "name BEGINSWITH[c] %@", sender.text!);
        let results = realm?.objects(MedicineModel.self).filter(predicate);
        if results != nil {
            if (results?.count)! > 0 {
                var fieldsArray = [SearchTextFieldItem]();
//                for item in DBUtils.getStringAllergies() {
                for item in results! {
                    fieldsArray.append(SearchTextFieldItem(title: item.name!));
                }
                self.eMedicineName.filterItems(fieldsArray);
            }
        }
    }


    @IBOutlet weak var lSelectedSchedule: UILabel!
    @IBOutlet weak var eDuration: UITextField!
    @IBOutlet weak var eDosage: UITextField!

    @IBAction func onClickSelectType(_ sender: UIButton) {
        Utility.hideDropper(dropper);
        self.type = VCAddMedication.DROPPER_TYPE;
        self.dropper = Dropper(width: 200, height: 220)
        self.dropper?.items = self.arrTypes;
        self.dropper?.delegate = self;
        self.dropper?.show(.center, button: sender);
    }


    @IBOutlet weak var eMedicineName: SearchTextField!
    @IBOutlet weak var lSelectedType: UILabel!

    @IBAction func onClickAddMedication(_ sender: UIButton) {
        var medication: Medication = Medication();
        if (isValidField(view: self.eMedicineName)) {
            medication.name = self.eMedicineName.text!;
            medication.personId = self.patientInfo?.id;
            if self.lSelectedType.text?.contains("Select") == true
            {
                medication.notes = ""
            }
            else
            {
                medication.notes = self.lSelectedType.text;
            }
            medication.duration = self.eDuration.text;
            medication.dosage = self.eDosage.text;
            medication.isUpdated = true;

            var strSchedule: String?;
            strSchedule = "";
            if (lSelectedSchedule.text! == "Meals Based") {
                if (bemBreakfast.on) {
                    if (sBreakfast.isOn) {
                        strSchedule = "After: breakfast ";
                    } else {
                        strSchedule = "Before: breakfast ";
                    }
                }

                if (bemDinner.on) {
                    if (sDinner.isOn) {
                        strSchedule = strSchedule!+" After: dinner ";
                    } else {
                        strSchedule = strSchedule!+" Before: dinner ";
                    }
                }

                if (bemLunch.on) {
                    if (sLunch.isOn) {
                        strSchedule = strSchedule! + " After: lunch ";
                    } else {
                        strSchedule = strSchedule! + " Before: lunch ";
                    }
                }
            } else if (lSelectedSchedule.text == "Fixed time") {
                medication.schedule = lSelectedSchedule.text?.description;
            }
            else
            {
                strSchedule = lSelectedSchedule.text
            }
            if (strSchedule != nil) {
                medication.schedule = strSchedule;
            } else {
                medication.schedule = self.lSelectedSchedule.text;
            }

            try? self.realm?.write({
                realm?.add(medication);
            })


            self.listenerOnMedicationAdded?.onMedicineAdded(medication);
            self.navigationController?.popViewController(animated: true);


//            let url = DAMUrls.urlPatientMedicineAdd();
//            let request = ApiServices.createPostRequest(
//                urlStr: url,
//                parameters: [medication.toJSON()]);
//
//            sender.setTitle("adding...", for: .normal);
//            sender.isEnabled = false;
//
//            AlamofireManager.Manager.request(request).responseObject {
//                (response: DataResponse<Medication>) in
//
//                sender.setTitle("Add Medication", for: .normal);
//                sender.isEnabled = true;
//                if (response.response?.statusCode == 200) {
//                    self.listenerOnMedicationAdded?.onMedicineAdded(response.result.value);
//                    self.navigationController?.popViewController(animated: true);
//                }
//            }
        } else {
            print("TextField empty error");
            Toast(text: "Medicine name can't be empty!").show();
        }

    }

    func onTouchScrollView(_ gesture: UITapGestureRecognizer) {
        Utility.hideDropper(self.dropper);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Medication"

        let recogN = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)));
        recogN.cancelsTouchesInView = false;
        scrollView.addGestureRecognizer(recogN);


        self.dateFormatter = DateFormatter();
        self.dateFormatter?.timeZone = Calendar.current.timeZone;
        self.dateFormatter?.locale = Calendar.current.locale;
        self.dateFormatter?.dateFormat = "dd-MM-yyyy";

        self.bemLunch.delegate = self;
        self.bemBreakfast.delegate = self;
        self.bemDinner.delegate = self;
    }

}

extension VCAddMedication: DropperDelegate, BEMCheckBoxDelegate {
    internal func didTap(_ checkBox: BEMCheckBox) {
        switch (checkBox.tag) {
        case 0:
            if (checkBox.on) {
                sBreakfast.isEnabled = true;
            } else {
                sBreakfast.isEnabled = false;
            }
            break;
        case 1:
            if (checkBox.on) {
                sLunch.isEnabled = true;
            } else {
                sLunch.isEnabled = false;
            }
            break;
        case 2:

            if (checkBox.on) {
                sDinner.isEnabled = true;
            } else {
                sDinner.isEnabled = false;
            }
            break;
        default:
            break;
        }
    }
    
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        if (self.type == VCAddMedication.DROPPER_TYPE) {
            self.lSelectedType.text = contents;
        } else {
            self.lSelectedSchedule.text = contents;
            switch contents {
            case "Meals Based":
                viewWrapper.isHidden = false;
                bDateExactTime.isHidden = true;
                break;
            case "Fixed time":
                bDateExactTime.isHidden = false;
                viewWrapper.isHidden = true;
                break;
            default:
                viewWrapper.isHidden = true;
                bDateExactTime.isHidden = true;
                break
                
            }
        }
    }

//    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
//    }
}
