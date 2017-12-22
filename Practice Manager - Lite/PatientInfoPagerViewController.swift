//
//  PatientInfoPagerViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 28/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import SwiftHEXColors
import RealmSwift

class PatientInfoPagerViewController: ButtonBarPagerTabStripViewController {
    static let TITLE_BASIC_INFO = "Basic Info";
    static let TITLE_VITALS = "Vitals";
    static let TITLE_MEDICATION = "Current Medications";
    static let TITLE_FAMILY_HISTORY = "Family History";
    static let TITLE_PREGNANCY_HISTORY = "Pregnancy History";
    static let TITLE_ALLERGIESANDCONDITIONS = "Allergis & Conditions";

    static let TITLE_FERTILITY_PROFILE = "Fertility Profile";
    static let TITLE_FERTILITY_HISTORY = "Fertility History";

    static let TITLE_RECORDS = "Records";
    static let TITLE_GYNECHISTORY = "Gynec History";
    static let TITLE_MENSTRUALHISTORY = "Menstrual History";

    var patientInfo: PersonInfoModel?;

    override func viewDidLoad() {
        self.settings.style.selectedBarBackgroundColor = UIColor.white;
        self.settings.style.buttonBarBackgroundColor = UIColor(hexString: "#01715C");
        self.settings.style.buttonBarItemBackgroundColor = UIColor(hexString: "#01715C")
        self.automaticallyAdjustsScrollViewInsets = true;
        super.viewDidLoad();

        let realm = try? Realm();
        let patient = realm?.objects(Patient.self).filter("personId = '"+(self.patientInfo?.id!)!+"'").first;
        if patient != nil && patientInfo?.name != nil{
            self.title = (patientInfo?.name)!;
            if patient?.clinicPersonId != nil {
                self.title = (patientInfo?.name)! + " | " + (patient?.clinicPersonId)!;
            }
        }

    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let basicInfo: BasicInfoViewControllerViewController = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.BASIC_INFO) as! BasicInfoViewControllerViewController;
        basicInfo.patientInfo = patientInfo;

        let vcVitals: VCVitalsViewController = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_VITALS) as! VCVitalsViewController;
        vcVitals.patientInfo = patientInfo;

        let vcAllergiesAndConditions: VCAlergiesAndConditions = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_ALERGIESCONDITIONS) as! VCAlergiesAndConditions;
        vcAllergiesAndConditions.patientInfo = patientInfo;

        let vcMedication: VCMedication = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_MEDICATION) as! VCMedication;
        vcMedication.patientInfo = patientInfo;

        let vcFamilyHistory: VCFamilyHistoryViewController = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_FAMILYHISTORY) as! VCFamilyHistoryViewController;
        vcFamilyHistory.patientInfo = patientInfo;

        let vcPregnancyHistory: VCPregnancyHistoryViewController = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_PREGNANCYHISTORY) as! VCPregnancyHistoryViewController;
        vcPregnancyHistory.patientInfo = patientInfo;

        let vcRecords: VCRecords = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_RECORDS) as! VCRecords;
        vcRecords.patientInfo = patientInfo;

        let vcGynechistory: VCGynecHistory = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_GYNECHISTORY) as! VCGynecHistory
        vcGynechistory.patientInfo = patientInfo;

        let vcMenstrualHistory: VCMenstrualHIstory = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_MENSTRUALHISTORY) as! VCMenstrualHIstory
        vcMenstrualHistory.patientInfo = patientInfo;

        let vcFertilityProfile: VCFertilityProfileViewController = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_FERTILITYPROFILE) as! VCFertilityProfileViewController
        vcFertilityProfile.patientInfo = patientInfo;

        let vcFertilityHistory: VCFertilityHistory = self.storyboard?.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_FERTILITYHISTORY) as! VCFertilityHistory
        vcFertilityHistory.patientInfo = patientInfo;


        let vcInvestigations: VCInvestigations = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_INVESTIGATIONS) as! VCInvestigations
        vcInvestigations.patientInfo = patientInfo;

        let vcVisits: VCVisits = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_VISITS) as! VCVisits
        vcVisits.patientInfo = patientInfo;

        if (patientInfo?.gender == Names.Gender.MALE) {
            return [basicInfo,
                    vcVitals,
                    vcAllergiesAndConditions,
                    vcMedication,
                    vcFamilyHistory,
                    vcInvestigations,
//                    vcGynechistory,
//                    vcMenstrualHistory,
//                    vcPregnancyHistory,
                    vcVisits,
                    vcFertilityProfile,
                    vcFertilityHistory,
                    vcRecords
            ];

        } else if (patientInfo?.gender == Names.Gender.FEMALE) {
            return [basicInfo,
                    vcVitals,
                    vcAllergiesAndConditions,
                    vcMedication,
                    vcFamilyHistory,
                    vcInvestigations,
                    vcGynechistory,
                    vcMenstrualHistory,
                    vcPregnancyHistory,
                    vcVisits,
                    vcFertilityProfile,
                    vcFertilityHistory,
                    vcRecords
            ];

        } else {
            return [basicInfo,
                    vcVitals,
                    vcAllergiesAndConditions,
                    vcMedication,
                    vcFamilyHistory,
                    vcInvestigations,
                    vcGynechistory,
                    vcMenstrualHistory,
                    vcPregnancyHistory,
                    vcVisits,
                    vcFertilityProfile,
                    vcFertilityHistory,
                    vcRecords

            ];

        }


    }


    static let TITLE_VISITS = "Visits";

    static var TITLE_INVESTIGATIONS = "Investigations";

    override func viewDidDisappear(_ animated: Bool) {
        print("Disappeared");
    }
}
