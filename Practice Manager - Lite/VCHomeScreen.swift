//
//  HomeScreen.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 21/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import SideMenuController


class VCHomeScreen: UIViewController {

    @IBAction func onClickQuestions(_ sender: Any) {

    }

    @IBAction func onClickPatients(_ sender: Any) {
//        performSegue(withIdentifier: Names.Segues.DOCTORS_LIST, sender: self);
//        let vc = self.storyboard?.instantiateViewController(
//                withIdentifier: Names.VContIdentifiers.VC_PATIENTSLIST) as! VCDoctorsListofClinicCollectionView;
//        vc.onDoctorClickedDelegate = self;
//        self.navigationController?.pushViewController(vc, animated: true);

    }

    @IBAction func onClickAppointment(_ sender: Any) {
//        performSegue(withIdentifier: Names.Segues.DOCTORS_LIST, sender: self);
        let vc = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_DOCTORSLISTCOLLECTIONVIEW) as! VCDoctorsListofClinicCollectionView;
        vc.onDoctorClickedDelegate = self;
        self.navigationController?.pushViewController(vc, animated: true);


    }

    override func viewDidLoad() {
        super.viewDidLoad();
        if UserPrefUtil.getClinicResponse() != nil {
        self.title = (UserPrefUtil.getClinicResponse()?.clinic?.name!)! + " | " + (UserPrefUtil.getClinicResponse()?.personInfo?.name!)!;
        }
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12
        
        let btnMenu = UIButton(type: UIButtonType.custom)
        btnMenu.frame = CGRect(x: 0, y: 0  , width: 44 , height: 44)
        btnMenu.setImage(#imageLiteral(resourceName: "menu"), for: UIControlState.normal)
        btnMenu.contentMode = .scaleAspectFit
        btnMenu.addTarget(self, action: #selector(self.btnMenuClicked(sender:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: btnMenu)
        self.navigationItem.leftBarButtonItems = [negativeSpacer,leftBarButtonItem]

    
    }
    @objc func btnMenuClicked(sender:UIButton)
    {
        self.sideMenuController?.toggle();

    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier! {
//        case Names.Segues.DOCTORS_LIST:
//            (segue.destination as! VCDoctorsListofClinic).onDoctorClickedDelegate = self;
//            break;
//        default:
//            break;
//        }
//    }

}

/**
 We are implementing the interface here to listen to the onClickDoctor listener in VCDoctorsListOfClinic view controller
 This makes the code modular
 */
extension VCHomeScreen: OnDoctorClickedDelegate {
    func onClickDoctor(doctor: DoctorModel) {
        print("called previous controller \(doctor.name)");
        let calViewController: VCDoctorsEventCalendar = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.CALENDAR_VIEW) as! VCDoctorsEventCalendar;
        calViewController.doctor = doctor;
        self.navigationController?.pushViewController(calViewController, animated: true);

    }

}
