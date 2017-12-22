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
        if (self.dropper != nil) {
            self.dropper?.hide();
        }
        self.dropper = Dropper.init(width: 140, height: 200);
        self.dropper?.items = Array(self.dictRelations.keys);
        self.dropper?.delegate = self;
        self.dropper?.show(.left, button: sender);
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

    @IBOutlet weak var eConditions: UITextField!
    @IBOutlet weak var eAge: UITextField!
    @IBOutlet weak var lRelationLabel: UILabel!

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
    }
}

extension VCAddFamilyHistory: DropperDelegate {

    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        self.lRelationLabel.text = contents;
    }
}
