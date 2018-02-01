//
// Created by Sandeep Rana on 14/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog
import AlamofireObjectMapper
import Alamofire
import RealmSwift
import Toaster

class VCSpontaneousAbortion: UIViewController {
    var patientInfo: PersonInfoModel?;
    var onAddedListener: OnAddedListener?;

    @IBOutlet weak var sFollowedByEvacuation: UISwitch!
    @IBOutlet weak var eCompilations: UITextField!

    private let dateFormatter = DateFormatter();

    var obType: String?;

    @IBAction func onClickDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: Date(), minimumDate: nil, maximumDate: Date(), datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    @IBOutlet weak var eGestationalAge: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = obType
        dateFormatter.timeZone = Calendar.current.timeZone;
        dateFormatter.locale = Calendar.current.locale;
        dateFormatter.dateFormat = "dd-MM-yyyy";
        self.bDate.setTitle(dateFormatter.string(from: Date()), for: .normal);
        self.bDate?.layer.cornerRadius = 10.0
        self.bDate?.layer.borderColor = UIColor.darkGray.cgColor
        self.bDate?.layer.borderWidth = 0.5
        self.bDate?.clipsToBounds = true
    }

    @IBOutlet weak var bDate: UIButton!

    
    let realm = try? Realm();
    
    @IBAction func onClickSave(_ sender: UIButton) {

        if (self.eGestationalAge.text?.characters.count)! < 1 {
            Toast(text: "Gestational Age is required").show();
            return;
        }




        var comments = "";
        comments = "Gestational Age (In weeks):" + (self.eGestationalAge.text?.description)!;
        comments = comments + "<br> Followed By Evacuation: " + (self.sFollowedByEvacuation.isOn ? "Yes" : "No");
        comments = comments + "Comments: " + (self.eCompilations.text)!;
        let preg = Pregnancy();
        preg.setFields(
                id: nil,
                personId: self.patientInfo?.id,
                obDate: (dateFormatter.date(from: self.bDate.titleLabel!.text!)?.millisecondsSince1970)!,
                obType: self.obType,
                comments: self.eCompilations.text,
                creationDate: Date().millisecondsSince1970,
                updateDate: Date().millisecondsSince1970, createdBy: nil, updatedBy: nil,
                liveBrith: true);
        var dict = preg.toJSON();
        dict[Names.LIVE_BRITH] = 1;
        
        try? realm?.write ({
            realm?.add(preg);
        });
        if (self.onAddedListener != nil){
            self.onAddedListener?.onAddedHistory(preg);
        }
        self.navigationController?.popViewController(animated: true);

        
        
        
        
        
        
//        let url = DAMUrls.urlPatientAddPregnancyHistory();
//        let request = ApiServices.createPostRequest(urlStr: url, parameters: dict);

//        sender.setTitle("loading...", for: .normal);
//        sender.isEnabled = false;
//
//        AlamofireManager.Manager.request(request).responseString {
//            response in
//
//            sender.setTitle("Save", for: .normal);
//            sender.isEnabled = true;
//
//            if (response.response?.statusCode == 200) {
//                self.onAddedListener?.onAddedHistory(preg);
//                self.navigationController?.popViewController(animated: true);
//            }
//        }

    }
}
