//
//  SideBarViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 01/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import RealmSwift


class SideBarViewController: UIViewController {

    @IBOutlet weak var lHospitalName: UILabel!
    @IBOutlet weak var lHospitalEmail: UILabel!
    @IBOutlet weak var iImageHospitalAvatar: UIImageView!


    @IBAction func onClickSideButton(_ sender: Any) {
        print("Clicked Side Button");
        self.replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.HOME);
    }

    private func replaceNavig(viewControllerIdentifier: String) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier);
        if let navcont = self.sideMenuController?.centerViewController as? UINavigationController {
            navcont.popToRootViewController(animated: false);
            print(navcont.viewControllers.count);
            if navcont.viewControllers.count > 0 {
                navcont.viewControllers.remove(at: 0);
            }
            navcont.pushViewController(controller!, animated: false);
        }
        self.sideMenuController?.toggle();
    }

    private func pushViewController(storyBoard: String, viewControllerIdentifier: String) {
        let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(
                withIdentifier: viewControllerIdentifier);
        if let navcont = self.sideMenuController?.centerViewController as? UINavigationController {
//            navcont.popToRootViewController(animated: false);
            print(navcont.viewControllers.count);
//            if navcont.viewControllers.count > 0 {
//                navcont.viewControllers.remove(at: 0);
//            }
            navcont.pushViewController(controller, animated: false);
        }
        self.sideMenuController?.toggle();
    }

    @IBAction func onclickLogout(_ sender: UIButton) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        dismiss(animated: false, completion: {
            if self.presentedViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        })

//        let realm = try? Realm();
//        try? realm?.write {
//            realm?.deleteAll();
//        }
//        let vcLogin = self.storyboard?.instantiateInitialViewController();
//        present(vcLogin!, animated: true, completion: nil);
//        exit(0);
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count);
    }

//    @IBOutlet weak var onClickLogout: UIButton!
    @IBAction func onClickSideDoctors(_ sender: Any) {

        self.replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.VC_DOCTORSLISTCOLLECTIONVIEW);
    }

    @IBAction func onClickSideChangePassword(_ sender: Any) {
        self.pushViewController(storyBoard: Names.STORYBOARD.PERSON_INFO, viewControllerIdentifier: Names.VContIdentifiers.VC_CHANGEPASSWORD);
    }

    @IBAction func onClickSidePatients(_ sender: Any) {
        self.replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.VC_PATIENTSLIST);
    }

    @IBAction func onClickSideMySubscriptions(_ sender: Any) {
        self.pushViewController(storyBoard: Names.STORYBOARD.PERSON_INFO, viewControllerIdentifier: Names.VContIdentifiers.VC_SUBSCRIPTIONS);
//        self.replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.VC_SUBSCRIPTIONS);
    }

    @IBAction func onClickSideHealthRecords(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_PATIENTSLIST);
        if let navcont = self.sideMenuController?.centerViewController as? UINavigationController {
            navcont.popToRootViewController(animated: false);
            print(navcont.viewControllers.count);
            if navcont.viewControllers.count > 0 {
                navcont.viewControllers.remove(at: 0);
            }

            (controller as! VCPatientsList).onPatientClickedListener = self;

            navcont.pushViewController(controller!, animated: true);
        }
        self.sideMenuController?.toggle();
    }

    @IBAction func onClickSideSettings(_ sender: Any) {
        self.pushViewController(storyBoard: Names.STORYBOARD.PERSON_INFO, viewControllerIdentifier: Names.VContIdentifiers.VC_SYNCSETTINGS);
    }
    @IBAction func onClickSideQuestions(_ sender: Any) {
        self.replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.VC_QUESTIONSLIST);
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        replaceNavig(viewControllerIdentifier: Names.VContIdentifiers.HOME)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.HOME);
        if let navcont = self.sideMenuController?.centerViewController as? UINavigationController {
            navcont.popToRootViewController(animated: false);
            print(navcont.viewControllers.count);
            if navcont.viewControllers.count > 0 {
                navcont.viewControllers.remove(at: 0);
            }
            navcont.pushViewController(controller!, animated: false);
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserPrefUtil.getClinicResponse() != nil) {
            let clinic = UserPrefUtil.getClinicResponse()?.clinic;
            self.lHospitalName.text = clinic?.name;
            self.lHospitalEmail.text = clinic?.email;
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

}

extension SideBarViewController: OnPatientClickedListener {
    func onPatientClicked(_ patient: Patient, _ path: IndexPath) {
        let recordController = self.storyboard?.instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_RECORDS);
        if let navcont = self.sideMenuController?.centerViewController as? UINavigationController {

            let infoModel: PersonInfoModel = PersonInfoModel();
            infoModel.setFields(from: patient);

            (recordController as! VCRecords).patientInfo = infoModel;
            navcont.pushViewController(recordController!, animated: true);
        }
    }
}
