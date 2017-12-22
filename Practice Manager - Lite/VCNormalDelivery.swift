//
//  VCNormalDelivery.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 13/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import DatePickerDialog
import RealmSwift
import Toaster


class VCNormalDelivery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var arr = [Childs]();


    let dateFormatter = DateFormatter();

    var patientInfo: PersonInfoModel?;
    var onAddedListener: OnAddedListener?;

    @IBOutlet weak var bGestationalDate: UIButton?;

    public var pregnancyType: String?;

    private let realm = try? Realm();

    func onDeleteRow(_ sender: UIButton) {
        self.arr.remove(at: sender.tag);
        self.collectionView.reloadData();
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arr.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellDeliveryChildscellCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Names.VContIdentifiers.CELL_CHILDS, for: indexPath)

        as! CellDeliveryChildscellCollectionViewCell;
        let child = self.arr[indexPath.row];

        cell.sIsAlive.isOn = child.isAlive;
        cell.sIsAlive.tag = indexPath.row;
        cell.sIsAlive.addTarget(self, action: #selector(self.onSwitchChanged(_:)), for: UIControlEvents.valueChanged);

        cell.svGender.selectedSegmentIndex = child.gender;
        cell.svGender.tag = indexPath.row;
        cell.svGender.addTarget(self, action: #selector(self.onSegmentValueChanged(_:)), for: UIControlEvents.valueChanged);

        cell.bDelete.tag = indexPath.row;
        cell.bDelete.addTarget(self, action: #selector(self.onDeleteRow(_:)), for: UIControlEvents.touchUpInside);

        if (indexPath.row == 0) {
            cell.bDelete.isHidden = true;
        } else {
            cell.bDelete.isHidden = false;
        }

        return cell;
    }

    func onSwitchChanged(_ sender: UISwitch) {
        self.arr[sender.tag].isAlive = sender.isOn;
    }

    func onSegmentValueChanged(_ sender: UISegmentedControl) {
        self.arr[sender.tag].gender = sender.selectedSegmentIndex;
    }

    @IBOutlet weak var bGestationalAge: UITextField!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sDeliveryAtHospital: UISwitch!

    @IBAction func onClickAddMorechilds(_ sender: UIButton) {
        self.arr.append(Childs());
        self.collectionView.reloadData();
    }

    @IBAction func onSaveButtonClicked(_ sender: UIButton) {
        
        if (bGestationalAge.text?.characters.count)! < 1 {
            Toast(text: "Gestational Age is mandatory field!").show();
            return;
        }
        
        
        if (self.onAddedListener != nil) {

            let pregnancy = Pregnancy();

            var strComm = "Gestational Age:" + (self.bGestationalAge.text?.description)!;
            var male = 0;
            var maleDead = 0;
            var female = 0;
            var femaleDead = 0;
            var other = 0;
            var otherDead = 0;


            for ea in arr {
                switch ea.gender {
                case 0:
                    male = male + 1;
                    if (!ea.isAlive) {
                        maleDead = maleDead + 1;
                    }
                    break;
                case 1:
                    female = female + 1;
                    if (!ea.isAlive) {
                        femaleDead = femaleDead + 1;
                    }
                    break;
                case 2:
                    otherDead = otherDead + 1;
                    if (!ea.isAlive) {
                        otherDead = otherDead + 1;
                    }
                    break;
                default:
                    break;
                }


            }


            strComm = strComm + "<br>Delivered at Hospital:" + (self.sDeliveryAtHospital.isOn ? "YES" : "NO");


            strComm = strComm + "<br>Result:";

            if (male > 0) {
                strComm = strComm + "<br> Male : " + male.description;
                if (maleDead > 0) {
                    strComm = strComm + " (Dead): " + maleDead.description;
                }
            }

            if (female > 0) {
                strComm = strComm + ", Female : " + female.description;
                if (femaleDead > 0) {
                    strComm = strComm + " (Dead): " + femaleDead.description;
                }
            }

            if (other > 0) {
                strComm = strComm + ", Other : " + other.description;
                if (otherDead > 0) {
                    strComm = strComm + " (Dead): " + otherDead.description;
                }
            }


            pregnancy.setFields(id: nil,
                    personId: self.patientInfo?.id,
                    obDate: (self.dateFormatter.date(from: (self.bGestationalDate?.titleLabel?.text!)!)?.millisecondsSince1970)!,
                    obType: self.pregnancyType,
                    comments: strComm,
                    creationDate: Date().millisecondsSince1970,
                    updateDate: Date().millisecondsSince1970,
                    createdBy: nil,
                    updatedBy: nil,
                    liveBrith: true);
            var dictParams = pregnancy.toJSON();
            dictParams[Names.LIVE_BRITH] = 1;

            sender.isEnabled = false;
            sender.setTitle("Loading...", for: .normal);

            try? self.realm?.write({
                self.realm?.add(pregnancy);
                if onAddedListener != nil {
                    self.onAddedListener?.onAddedHistory(pregnancy);
                    self.navigationController?.popViewController(animated: true);
                }
            })

//            let url = DAMUrls.urlPatientAddPregnancyHistory();
//            let request = ApiServices.createPostRequest(urlStr: url, parameters: dictParams);
//
//            AlamofireManager.Manager.request(request).responseString{
////                (response: DataResponse<Pregnancy>) in
//                response in
//                if(response.response?.statusCode==200){
//                    self.onAddedListener?.onAddedHistory(pregnancy);
//                    self.navigationController?.popViewController(animated: true);
//                }
//
//                sender.isEnabled = true;
//                sender.setTitle("Save", for: .normal);
//            }
        }
    }


    @IBAction func onClickDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    @IBOutlet weak var eComplications: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.dateFormatter.timeZone = Calendar.current.timeZone;
        self.dateFormatter.locale = Calendar.current.locale;
        self.dateFormatter.dateFormat = "dd-MM-yyyy";
        self.arr.append(Childs());

        self.bGestationalDate?.setTitle(self.dateFormatter.string(from: Date()), for: .normal);
    }


}
