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
        Utility.hideDropper(self.dropper);
        self.dropper = Dropper(width: 100, height: 200);
        self.dropper?.delegate = self;
        self.dropper?.items = Loaders.listResults;
        self.dropper?.show(.left, button: sender);
    }


    override func viewDidLoad() {
        super.viewDidLoad()
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
