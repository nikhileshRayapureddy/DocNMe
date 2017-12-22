//
//  VCVitalsViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 29/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Dropper
import XLPagerTabStrip
import DatePickerDialog
import Dropper
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class VCVitalsViewController: UIViewController, IndicatorInfoProvider {


    var dropper: Dropper?;

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Utility.hideDropper(self.dropper);
    }

    var data: ResponseVitals?;
    var dateFormatter: DateFormatter?;
    let realm = try? Realm();

    let dictBloodTypes = [
        "RBS",
        "FBS",
        "PLBS",
        "HBA1C"
    ];

    let dictBloodUnit = [
        "mg/dL",
        "mmol/L"
    ]

    @IBOutlet weak var bSave: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var eBloodGlucose: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!


    @IBAction func onClickSaveButtonOffline(_ sender: UIButton) {
//        if (data != nil) {
//            Height
        if (isValidField(view: self.eHeight)) {
            let obj = realm?.objects(Height.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let heightDict: Height = Height();
                    heightDict.height = Int64(self.eHeight.text!)!;
                    heightDict.personId = patientInfo?.id;
                    heightDict.measuredTime = (self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                    heightDict.visitId = "";
                    heightDict.isUpdated = true;
                    realm?.add(heightDict);
                } else {
                    obj!.height = Int64(self.eHeight.text!)!;
                    obj?.personId = patientInfo?.id;
                    obj?.isUpdated = true;
                    obj?.measuredTime = (self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                }
            })
        }
//            Weight
        if (isValidField(view: self.eWeight)) {
            let obj = realm?.objects(Weight.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let weightDict: Weight = Weight();
                    weightDict.weight = Int(self.eWeight.text!)!;
                    weightDict.personId = patientInfo?.id;
                    weightDict.measuredTime = (self.dateFormatter?.date(from: (bWeightDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                    weightDict.visitId = "";
                    weightDict.isUpdated = true;
                    realm?.add(weightDict);
                } else {
                    obj?.weight = Int(self.eWeight.text!)!;
                    obj?.personId = patientInfo?.id;
                    obj?.isUpdated = true;
                    obj?.measuredTime = (self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                }
            })
        }
//          Temperature
        if (isValidField(view: self.eTemperature)) {
            let obj = realm?.objects(Temperature.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let tempDict:
                            Temperature = Temperature();
                    tempDict.setFields(temperature: Int(self.eTemperature.text!), measuredTime: dateFormatter?.date(from: (bTemperatureDate.titleLabel?.text)!)?.millisecondsSince1970, visitId: "", personId: self.patientInfo?.id);
                    realm?.add(tempDict);
                } else {

                    obj?.temperature = Int(self.eTemperature.text!)!;
                    obj?.measuredTime = (dateFormatter?.date(from: (bTemperatureDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                    obj?.visitId = self.data?.temperature?.visitId;
                    obj?.isUpdated = true;
                    obj?.personId = self.patientInfo?.id;

                }

            })
        }
//          PulseRate

        if (isValidField(view: self.ePulseRate)) {
            let obj = realm?.objects(Pulserate.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let pulseRate: Pulserate = Pulserate();
                    pulseRate.setFields(pulserate: Int(self.ePulseRate.text!), measuredTime: self.dateFormatter?.date(from: (self.bPulseRateDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: self.patientInfo?.id)
//                        self.data?.pulserate = pulseRate;
                    realm?.add(pulseRate);
                } else {
                    obj?.pulserate = Int(self.ePulseRate.text!)!;
                    obj?.measuredTime = (self.dateFormatter?.date(from: (self.bPulseRateDate.titleLabel?.text!)!)?.millisecondsSince1970)!;
                    obj?.visitId = self.data?.pulserate?.visitId;
                    obj?.isUpdated = true;
                    obj?.personId = self.patientInfo?.id;
                }
            })
        }

//            BloodPressure
        if (isValidField(view: self.eBPUpperDenominator) && isValidField(view: eBPUpperDenominator)) {
            let obj = realm?.objects(BloodPressure.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let bloodPressuer = BloodPressure();
                    bloodPressuer.setField(diastolic: Int(self.eBPUpperDenominator.text!), systolic: Int(self.eBPRightNumrator.text!), measuredTime: self.dateFormatter?.date(from: (bBloodPressureDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: patientInfo?.id);
                    realm?.add(bloodPressuer)
                } else {
                    obj?.setField(diastolic: Int(self.eBPUpperDenominator.text!), systolic: Int(self.eBPRightNumrator.text!), measuredTime: self.dateFormatter?.date(from: (bBloodPressureDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: patientInfo?.id);
                    obj?.isUpdated = true;
                }
            });

        } else {
//                In case of invalid entry
        }

//            LastMenstrualPeriod (LMP)
        if (self.bLMPDate.titleLabel?.text != "Date" && isValidButton(view: self.bLMPDate)) {
            let obj = realm?.objects(LastMenstrualPeriod.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let lmp = LastMenstrualPeriod();
                    let time = self.dateFormatter?.date(from: (self.bLMPDate.titleLabel?.text!)!)?.millisecondsSince1970;
                    lmp.setField(lmp: time!,
                            measuredTime: time!,
                            visitId: "",
                            personId: (self.patientInfo?.id)!
                    );
                    lmp.isUpdated = true;
                    realm?.add(lmp);
                } else {
                    let time = self.dateFormatter?.date(from: (self.bLMPDate.titleLabel?.text!)!)?.millisecondsSince1970;
                    obj?.setField(lmp: time!,
                            measuredTime: time!,
                            visitId: "",
                            personId: (self.patientInfo?.id)!
                    );
                    obj?.isUpdated = true;
                }
            });
        }
//            Blood Glucose

        if (isValidField(view: self.eBloodGlucose)) {
            let obj = realm?.objects(Bloodglucose.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let bloodGlucose = Bloodglucose();
                    bloodGlucose.setField(type: lTypeBloodGlucose.text!, measuredTime:
                    (dateFormatter?.date(from: (self.bBloodGlucoseDate.titleLabel?.text!)!)?.millisecondsSince1970)!,
                            visitId: "", personId: (self.patientInfo?.id)!,
                            bloodglucose: Int(eBloodGlucose.text!)!,
                            unit: lUnitBloodGlucose.text!);
                    bloodGlucose.isUpdated = true;
                    realm?.add(bloodGlucose);
                } else {
                    obj?.setField(type: lTypeBloodGlucose.text!,
                            measuredTime: (dateFormatter?.date(
                                    from: (self.bBloodGlucoseDate.titleLabel?.text)!)?.millisecondsSince1970)!,
                            visitId: "",
                            personId: (self.patientInfo?.id)!,
                            bloodglucose: Int(eBloodGlucose.text!)!,
                            unit: lUnitBloodGlucose.text!);
                    obj?.isUpdated = true;
                }
            })
        }

//            AMH
        if (isValidField(view: eAmh)) {
            let obj = realm?.objects(AntiMullerianHormone.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let amh = AntiMullerianHormone();
                    amh.setField(
                            antiMullerianHormone: Int(self.eAmh.text!)!,
                            measuredTime: (self.dateFormatter!.date(
                                    from: self.bAMSDate.titleLabel!.text!)?.millisecondsSince1970)!,
                            visitId: "",
                            personId: (self.patientInfo?.id)!);
                    amh.isUpdated = true;
                    realm?.add(amh);
                } else {
                    obj?.setField(
                            antiMullerianHormone: Int(self.eAmh.text!)!,
                            measuredTime: (self.dateFormatter!.date(
                                    from: self.bAMSDate.titleLabel!.text!)?.millisecondsSince1970)!,
                            visitId: "",
                            personId: (self.patientInfo?.id)!);
                    obj?.isUpdated = true;
                }
            })
        }

//            TSH
        if (isValidField(view: self.eTSH)) {
            let obj = realm?.objects(ThyroidStimulatingHormone.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let tsh = ThyroidStimulatingHormone();
                    tsh.setfield(
                            thyroidStimulatingHormone: Int(self.eTSH.text!),
                            measuredTime: self.dateFormatter?.date(
                                    from: (self.bTSHDate.titleLabel?.text!)!)?.millisecondsSince1970,
                            visitId: "",
                            personId: self.patientInfo?.id!);
                    tsh.isUpdated = true;
                    realm?.add(tsh);
                } else {
                    obj?.setfield(
                            thyroidStimulatingHormone: Int(self.eTSH.text!),
                            measuredTime: self.dateFormatter?.date(
                                    from: (self.bTSHDate.titleLabel?.text!)!)?.millisecondsSince1970,
                            visitId: "",
                            personId: self.patientInfo?.id!);
                    obj?.isUpdated = true;
                }
            });
        }

//            HB
        if (isValidField(view: self.eHb)) {
            let obj = realm?.objects(Hemoglobin.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
            try? realm?.write({
                if (obj == nil) {
                    let hb = Hemoglobin();
                    hb.setField(hemoglobin: Int(eHb.text!),
                            measuredTime: self.dateFormatter?.date(from: (self.bHBDate.titleLabel?.text!)!)?
                                    .millisecondsSince1970, visitId: "",
                            personId: self.patientInfo?.id!)
                    hb.isUpdated = true;
                    realm?.add(hb);
                } else {
                    obj?.setField(hemoglobin: Int(eHb.text!),
                            measuredTime: self.dateFormatter?.date(from: (self.bHBDate.titleLabel?.text!)!)?
                                    .millisecondsSince1970, visitId: "",
                            personId: self.patientInfo?.id!)
                    obj?.isUpdated = true;
                }
            });
        }
//        }
    }

    @IBAction func onClickSaveButton(_ sender: UIButton) {
        self.onClickSaveButtonOffline(sender);


//        if (data != nil ) {
////            Height
//            if (isValidField(view: self.eHeight)) {
//                if (data?.height == nil) {
//                    let heightDict: Height = Height();
//                    heightDict.height = Int64(self.eHeight.text!);
//                    heightDict.personId = patientInfo?.id;
//                    heightDict.measuredTime = self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                    heightDict.visitId = "";
//                    self.data?.height = heightDict;
//                } else {
//                    data?.height?.height = Int64(self.eHeight.text!);
//                    data?.height?.personId = patientInfo?.id;
//                    data?.height?.measuredTime = self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                }
//            }
////            Weight
//            if (isValidField(view: self.eWeight)) {
//                if (self.data?.weight == nil) {
//                    let weightDict: Weight = Weight();
//                    weightDict.weight = Int(self.eWeight.text!);
//                    weightDict.personId = patientInfo?.id;
//                    weightDict.measuredTime = self.dateFormatter?.date(from: (bWeightDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                    weightDict.visitId = "";
//                    self.data?.weight = weightDict;
//                } else {
//                    data?.weight?.weight = Int(self.eWeight.text!);
//                    data?.weight?.personId = patientInfo?.id;
//                    data?.weight?.measuredTime = self.dateFormatter?.date(from: (bHeightDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                }
//            }
////          Temperature
//            if (isValidField(view: self.eTemperature)) {
//                if (self.data?.temperature == nil) {
//                    let tempDict:
//                            Temperature = Temperature();
//                    tempDict.setFields(temperature: Int(self.eTemperature.text!), measuredTime: dateFormatter?.date(from: (bTemperatureDate.titleLabel?.text)!)?.millisecondsSince1970, visitId: "", personId: self.patientInfo?.id);
//                    self.data?.temperature = tempDict;
//                } else {
//                    data?.temperature?.setFields(temperature: Int(self.eTemperature.text!), measuredTime: dateFormatter?.date(from: (bTemperatureDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: self.data?.temperature?.visitId, personId: self.patientInfo?.id);
//                }
//            }
////          PulseRate
//
//            if (isValidField(view: self.ePulseRate)) {
//                if (self.data?.pulserate == nil) {
//                    let pulseRate: Pulserate = Pulserate();
//                    pulseRate.setFields(pulserate: Int(self.ePulseRate.text!), measuredTime: self.dateFormatter?.date(from: (self.bPulseRateDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: self.patientInfo?.id)
//                    self.data?.pulserate = pulseRate;
//                } else {
//                    self.data?.pulserate?.setFields(pulserate: Int(self.ePulseRate.text!), measuredTime: self.dateFormatter?.date(from: (self.bPulseRateDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: self.data?.pulserate?.visitId, personId: self.patientInfo?.id)
//                }
//            }
////            BloodPressure
//            if (isValidField(view: self.eBPUpperDenominator) && isValidField(view: eBPUpperDenominator)) {
//                if (self.data?.bloodPressure == nil) {
//                    let bloodPressuer = BloodPressure();
//                    bloodPressuer.setField(diastolic: Int(self.eBPUpperDenominator.text!), systolic: Int(self.eBPRightNumrator.text!), measuredTime: self.dateFormatter?.date(from: (bBloodPressureDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: patientInfo?.id);
//                    self.data?.bloodPressure = bloodPressuer;
//                } else {
//                    self.data?.bloodPressure?.setField(diastolic: Int(self.eBPUpperDenominator.text!), systolic: Int(self.eBPRightNumrator.text!), measuredTime: self.dateFormatter?.date(from: (bBloodPressureDate.titleLabel?.text!)!)?.millisecondsSince1970, visitId: "", personId: patientInfo?.id);
//                }
//            } else {
////                In case of invalid entry
//            }
//
////            LastMenstrualPeriod (LMP)
//            if (self.bLMPDate.titleLabel?.text != "Date" && isValidButton(view: self.bLMPDate)) {
//                if (self.data?.lastMenstrualPeriod == nil) {
//                    let lmp = LastMenstrualPeriod();
//                    let time = self.dateFormatter?.date(from: (self.bLMPDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                    lmp.setField(lmp: time!,
//                            measuredTime: time!,
//                            visitId: "",
//                            personId: (self.patientInfo?.id)!
//                    );
//                    self.data?.lastMenstrualPeriod = lmp;
//                } else {
//                    let time = self.dateFormatter?.date(from: (self.bLMPDate.titleLabel?.text!)!)?.millisecondsSince1970;
//                    self.data?.lastMenstrualPeriod?.setField(lmp: time!,
//                            measuredTime: time!,
//                            visitId: "",
//                            personId: (self.patientInfo?.id)!
//                    );
//                }
//            }
////            Blood Glucose
//
//            if (isValidField(view: self.eBloodGlucose)) {
//                if (self.data?.bloodglucose == nil) {
//                    let bloodGlucose = Bloodglucose();
//                    bloodGlucose.setField(type: lTypeBloodGlucose.text!, measuredTime:
//                    (dateFormatter?.date(from: (self.bBloodGlucoseDate.titleLabel?.text!)!)?.millisecondsSince1970)!,
//                            visitId: "", personId: (self.patientInfo?.id)!,
//                            bloodglucose: Int(eBloodGlucose.text!)!,
//                            unit: lUnitBloodGlucose.text!);
//                    self.data?.bloodglucose = bloodGlucose;
//                } else {
//                    self.data?.bloodglucose?.setField(type: lTypeBloodGlucose.text!,
//                            measuredTime: (dateFormatter?.date(
//                                    from: (self.bBloodGlucoseDate.titleLabel?.text)!)?.millisecondsSince1970)!,
//                            visitId: "",
//                            personId: (self.patientInfo?.id)!,
//                            bloodglucose: Int(eBloodGlucose.text!)!,
//                            unit: lUnitBloodGlucose.text!);
//                }
//            }
//
////            AMH
//            if (isValidField(view: eAmh)) {
//                if (self.data?.antiMullerianHormone == nil) {
//                    let amh = AntiMullerianHormone();
//                    amh.setField(
//                            antiMullerianHormone: Int(self.eAmh.text!)!,
//                            measuredTime: (self.dateFormatter!.date(
//                                    from: self.bAMSDate.titleLabel!.text!)?.millisecondsSince1970)!,
//                            visitId: "",
//                            personId: (self.patientInfo?.id)!);
//                    self.data?.antiMullerianHormone = amh;
//                } else {
//                    self.data?.antiMullerianHormone?.setField(
//                            antiMullerianHormone: Int(self.eAmh.text!)!,
//                            measuredTime: (self.dateFormatter!.date(
//                                    from: self.bAMSDate.titleLabel!.text!)?.millisecondsSince1970)!,
//                            visitId: "",
//                            personId: (self.patientInfo?.id)!);
//                }
//            }
//
////            TSH
//            if (isValidField(view: self.eTSH)) {
//                if (self.data?.thyroidStimulatingHormone == nil) {
//                    let tsh = ThyroidStimulatingHormone();
//                    tsh.setfield(
//                            thyroidStimulatingHormone: Int(self.eTSH.text!),
//                            measuredTime: self.dateFormatter?.date(
//                                    from: (self.bTSHDate.titleLabel?.text!)!)?.millisecondsSince1970,
//                            visitId: "",
//                            personId: self.patientInfo?.id!);
//                    self.data?.thyroidStimulatingHormone = tsh;
//                } else {
//                    self.data?.thyroidStimulatingHormone?.setfield(
//                            thyroidStimulatingHormone: Int(self.eTSH.text!),
//                            measuredTime: self.dateFormatter?.date(
//                                    from: (self.bTSHDate.titleLabel?.text!)!)?.millisecondsSince1970,
//                            visitId: "",
//                            personId: self.patientInfo?.id!);
//                }
//            }
//
////            HB
//            if (isValidField(view: self.eHb)) {
//                if ((self.data?.hemoglobin) != nil) {
//                    let hb = Hemoglobin();
//                    hb.setField(hemoglobin: Int(eHb.text!),
//                            measuredTime: self.dateFormatter?.date(from: (self.bHBDate.titleLabel?.text!)!)?
//                                    .millisecondsSince1970, visitId: "",
//                            personId: self.patientInfo?.id!)
//                    self.data?.hemoglobin = hb;
//                } else {
//                    self.data?.hemoglobin?.setField(hemoglobin: Int(eHb.text!),
//                            measuredTime: self.dateFormatter?.date(from: (self.bHBDate.titleLabel?.text!)!)?
//                                    .millisecondsSince1970, visitId: "",
//                            personId: self.patientInfo?.id!)
//                }
//            }
//
//
//            let dict = self.data?.toJSON();
////            dict?[Names.PERSONID] = self.patientInfo?.id;
//
//            self.bSave.isEnabled = false;
//            self.bSave.setTitle("Saving...", for: .normal);
//            let url = DAMUrls.urlPatientVitalsUpdate();
//
////            URLCache.shared.removeAllCachedResponses()
//            let request = ApiServices.createPostRequest(urlStr: url, parameters: dict);
//            AlamofireManager.Manager.request(request).responseString {
//                response in
//                self.bSave.isEnabled = true;
//                self.bSave.setTitle("Save", for: .normal);
//
//                print(response.result.value)
//            }
//        }
    }

    @IBOutlet weak var eHeight: UITextField!

    @IBOutlet weak var lUnitBloodGlucose: UILabel!
    @IBOutlet weak var lTypeBloodGlucose: UILabel!
    @IBOutlet weak var bLMPDate: UIButton!
    @IBOutlet weak var eBPRightNumrator: UITextField!
    @IBOutlet weak var eBPUpperDenominator: UITextField!
    @IBOutlet weak var eHb: UITextField!
    @IBOutlet weak var eTSH: UITextField!
    @IBOutlet weak var eAmh: UITextField!
    @IBOutlet weak var ePulseRate: UITextField!
    @IBOutlet weak var eTemperature: UITextField!
    @IBOutlet weak var eBmi: UITextField!
    @IBOutlet weak var eWeight: UITextField!


    @IBOutlet weak var bHeightDate: UIButton!;
    @IBOutlet weak var bWeightDate: UIButton!;
    @IBOutlet weak var bBMIDate: UIButton!;
    @IBOutlet weak var bTemperatureDate: UIButton!;
    @IBOutlet weak var bPulseRateDate: UIButton!;
    @IBOutlet weak var bAMSDate: UIButton!;
    @IBOutlet weak var bTSHDate: UIButton!;
    @IBOutlet weak var bHBDate: UIButton!;
    @IBOutlet weak var bBloodPressureDate: UIButton!;
    @IBOutlet weak var bBloodGlucoseDate: UIButton!;

    static let TYPE_UNIT = 0;
    static let TYPE_TYPE = 1;

    var tag: Int = VCVitalsViewController.TYPE_UNIT;

    @IBAction func onClickUnitDialogButton(_ sender: UIButton) {
        Utility.hideDropper(self.dropper);
        self.dropper = Dropper(width: 80, height: 200)
        tag = VCVitalsViewController.TYPE_UNIT;
        self.dropper?.items = dictBloodUnit;
        self.dropper?.delegate = self;
        self.dropper?.show(.center, button: sender);
    }

    @IBAction func onClickTypeDialogButton(_ sender: UIButton) {
        Utility.hideDropper(self.dropper);
        self.dropper = Dropper(width: 80, height: 200)
        tag = VCVitalsViewController.TYPE_TYPE;
        self.dropper?.items = dictBloodTypes;
        self.dropper?.delegate = self;
        self.dropper?.show(.center, button: sender);
    }

    @IBAction func onChangeHeightWeight(_ sender: UITextField) {
        let height = self.eHeight.text;
        let weight = self.eWeight.text;
        if (!(height?.isEmpty)! && !(weight?.isEmpty)!) {
            
            let bmi:Double = self.calculateBMI(massInKilograms: Double(height!) ?? 1, heightInCentimeters: Double(weight!) ?? 1);
            self.eBmi.text = bmi.rounded(toPlaces: 2).description;
        }else {
            self.eBmi.text = "";
        }
    }


    func calculateBMI(massInKilograms mass: Double, heightInCentimeters height: Double) -> Double {
        return mass / ((height * height) / 10000)
    }


    @IBAction func onClickHeightDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickWeightDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickBMIDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickTemperatureDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickPulseRateDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickAMSDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickTSHDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickHBDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickBloodPressureDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickBloodGlucoseDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    func onTouchScrollView(_ gesture: UITapGestureRecognizer) {
        Utility.hideDropper(self.dropper);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let recogN = UITapGestureRecognizer(target: self, action: #selector(onTouchScrollView(_:)));
        recogN.cancelsTouchesInView = false;
        scrollView.addGestureRecognizer(recogN);

        Utility.showProgressForIndicator(self.indicator, false);
        dateFormatter = DateFormatter();
        dateFormatter?.dateFormat = "dd/MM/yyyy";
        dateFormatter?.timeZone = Calendar.current.timeZone;
        dateFormatter?.locale = Calendar.current.locale;

        let date = Date();
        bHeightDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bWeightDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bBMIDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bTemperatureDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bPulseRateDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bAMSDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bTSHDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bHBDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bBloodPressureDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);
        bBloodGlucoseDate?.setTitle(self.dateFormatter?.string(from: date), for: .normal);


        self.callApiVitals(patientInfo: self.patientInfo!);
        let data = ResponseVitals();
        data.bloodglucose = realm?.objects(Bloodglucose.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.bloodPressure = realm?.objects(BloodPressure.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.height = realm?.objects(Height.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.weight = realm?.objects(Weight.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
//        data.oxygenstaturation = realm?.objects(Oxygenstaturation.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
//        data.respirationrate = realm?.objects(Respirationrate.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.pulserate = realm?.objects(Pulserate.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.temperature = realm?.objects(Temperature.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.hemoglobin = realm?.objects(Hemoglobin.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.thyroidStimulatingHormone = realm?.objects(ThyroidStimulatingHormone.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.antiMullerianHormone = realm?.objects(AntiMullerianHormone.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;
        data.lastMenstrualPeriod = realm?.objects(LastMenstrualPeriod.self).filter("personId = '" + (self.patientInfo?.id)! + "'").first;


        self.populateData(data: data)
    }


    var patientInfo: PersonInfoModel?;

    private func callApiVitals(patientInfo: PersonInfoModel) {

        let url = DAMUrls.urlPatientVitals(patientInfo: patientInfo);
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
//        URLCache.shared.removeAllCachedResponses()
        Utility.showProgressForIndicator(self.indicator, true);
    
//        AlamofireManager.Manager.request(request).responseString {
//            response in
//            print(response.result.value);
//        }
            AlamofireManager.Manager.request(request).responseObject { (response: DataResponse<ResponseVitals>) in
//            print(response.result.value?.height?.id);
            Utility.showProgressForIndicator(self.indicator, false);
            if response.response?.statusCode == 200 {
                    self.populateData(data: response.result.value!);
            
            }

        }
    }

    func populateData(data: ResponseVitals?) {
        self.data = data;
        try? self.realm?.write{
            
        if let vitals = data {
            if let height = vitals.height {
                
                    let res = realm?.objects(Height.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((height.personId)!)'").first
                    if res != nil {
                        res?.height = height.height;
                        res?.id = height.id;
                    } else {
                        realm?.add(height);
                    }
                
                
                self.eHeight.text = height.height.description;
                self.bHeightDate.setTitle(dateFormatter?.string(from: height.getDate()!), for: .normal);
            }


            if let weight = vitals.weight {
                
                
                let res = realm?.objects(Weight.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((weight.personId)!)'").first
                if res != nil {
                    res?.weight = weight.weight;
                    res?.id = weight.id;
                } else {
                    realm?.add(weight);
                }
                
                
                self.eWeight.text = weight.weight.description;
                self.bWeightDate.setTitle(dateFormatter?.string(from: weight.getDate()), for: .normal);
            }


//            if let eBmi = vitals.b{
//                self.eBmi.text = eBmi.height?.description;
//                self.bBMIDate.setTitle(dateFormatter?.string(from: eBmi.getDate()!), for: .normal);
//            }

            if let temperature = vitals.temperature {
               
                let res = realm?.objects(Temperature.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((temperature.personId)!)'").first
                if res != nil {
                    res?.temperature = temperature.temperature;
                    res?.id = temperature.id;
                } else {
                    realm?.add(temperature);
                }
                
                
                self.eTemperature.text = temperature.temperature.description;
                self.bTemperatureDate.setTitle(dateFormatter?.string(from: temperature.getDate()), for: .normal);
            }

            if let pulserate = vitals.pulserate {
                
                let res = realm?.objects(Pulserate.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((pulserate.personId)!)'").first
                if res != nil {
                    res?.pulserate = pulserate.pulserate;
                    res?.id = pulserate.id;
                } else {
                    realm?.add(pulserate);
                }
                
                
                self.ePulseRate.text = pulserate.pulserate.description;
                self.bPulseRateDate.setTitle(dateFormatter?.string(from: pulserate.getDate()), for: .normal);
            }

            if let amh = vitals.antiMullerianHormone {


                let res = realm?.objects(AntiMullerianHormone.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((amh.personId)!)'").first
                if res != nil {
                    res?.antiMullerianHormone = amh.antiMullerianHormone;
                    res?.id = amh.id;
                } else {
                    realm?.add(amh);
                }


                self.eAmh.text = amh.antiMullerianHormone.description;
                self.bAMSDate.setTitle(dateFormatter?.string(from: amh.getDate()), for: .normal);
            }


            if let TSH = vitals.thyroidStimulatingHormone {

                let res = realm?.objects(ThyroidStimulatingHormone.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((TSH.personId)!)'").first
                if res != nil {
                    res?.thyroidStimulatingHormone = TSH.thyroidStimulatingHormone;
                    res?.id = TSH.id;
                } else {
                    realm?.add(TSH);
                }



                self.eTSH.text = TSH.thyroidStimulatingHormone.description;
                self.bTSHDate.setTitle(dateFormatter?.string(from: TSH.getDate()), for: .normal);
            }

            if let HB = vitals.hemoglobin {



                let res = realm?.objects(Hemoglobin.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((HB.personId)!)'").first
                if res != nil {
                    res?.hemoglobin = HB.hemoglobin;
                    res?.id = HB.id;
                } else {
                    realm?.add(HB);
                }


                self.eHb.text = HB.hemoglobin.description;
                self.bHBDate.setTitle(dateFormatter?.string(from: HB.getDate()), for: .normal);
            }

            if let bp = vitals.bloodPressure {

                let res = realm?.objects(BloodPressure.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((bp.personId)!)'").first
                if res != nil {
                    res?.diastolic = bp.diastolic;
                    res?.systolic = bp.systolic;
                    res?.measuredTime = bp.measuredTime;
                    res?.bp_id = bp.bp_id;
                } else {
                    realm?.add(bp);
                }


                self.eBPRightNumrator.text = bp.diastolic.description;
                self.eBPUpperDenominator.text = bp.systolic.description;
                self.bBloodPressureDate.setTitle(dateFormatter?.string(from: bp.getDate()), for: .normal);
            }


            if let bloodGlucose = vitals.bloodglucose {
                
                
                let res = realm?.objects(Bloodglucose.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((bloodGlucose.personId)!)'").first
                if res != nil {
                    res?.bloodglucose = bloodGlucose.bloodglucose;
                    res?.type = bloodGlucose.type;
                    res?.measuredTime = bloodGlucose.measuredTime;
                    res?.unit = bloodGlucose.unit;
                    res?.visitId = bloodGlucose.visitId;
                } else {
                    realm?.add(bloodGlucose);
                }

                

                self.lTypeBloodGlucose.text = bloodGlucose.type!;
                self.lUnitBloodGlucose.text = bloodGlucose.unit!;
                self.bBloodGlucoseDate.setTitle(dateFormatter?.string(from: bloodGlucose.getDate()), for: .normal);
                self.eBloodGlucose.text = bloodGlucose.bloodglucose.description;
            }

            if let lmp = vitals.lastMenstrualPeriod {
                
                let res = realm?.objects(LastMenstrualPeriod.self).filter("(isDeleted = false && isUpdated = false) && personId = '\((lmp.personId)!)'").first
                if res != nil {
                    res?.lmp = lmp.lmp;
                    res?.id = lmp.id;
                    res?.measuredTime = lmp.measuredTime;
                } else {
                    realm?.add(lmp);
                }
                

                
                
                self.bLMPDate.setTitle(
                        self.dateFormatter?.string(from: Date.init(milliseconds: lmp.measuredTime)), for: .normal);
            }
            };
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: PatientInfoPagerViewController.TITLE_VITALS);
    }

}

extension VCVitalsViewController: DropperDelegate {

    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        print("printe it");
        switch self.tag {
        case VCVitalsViewController.TYPE_TYPE:
            lTypeBloodGlucose.text = contents;
            break;
        default:
            lUnitBloodGlucose.text = contents;
            break;
        }
    }

}
