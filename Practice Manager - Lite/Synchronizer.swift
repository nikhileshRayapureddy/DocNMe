//
// Created by Sandeep Rana on 15/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import AlamofireObjectMapper
import Alamofire

class Synchronizer {

    /**Reg ex to match the patients id. Pretty fast isn't it?
    */
    static let regEx = "?????????????";

    class func syncData(_ delegate: OnSynchronizerStateChanged) {
        //Don't sync anything untill patients are not synchronized
//        Otherwise you will be fucked up with the id - id mess
        syncPatientWithServer();
    }


///MARK - BasicProfileAttributes

    private class func syncPatientWithServer() {
        var requestJson = [Any]();
        let realm = try? Realm();
        let patients = realm?.objects(Patient.self).filter("isDeleted = false && isUpdated = true && personId LIKE '\(regEx)'");
        if patients != nil && (patients?.count)! > 0 {

            for pat in patients! {
                let person = PatientsWrapperForBatchRequest();

                let patient = Patient();
                patient.refererId = pat.refererId;
                patient.refererName = pat.refererName;
                patient.clinicId = pat.clinicId;

                let personInfoRes = realm?.objects(PersonInfoModel.self).filter("id = '\(pat.personId)'").first;
                if personInfoRes != nil {
                    let perInfoModel = PersonInfoModel();
                    perInfoModel.setFields(personInfoRes!);
                    perInfoModel.id = nil;
                    patient.personInfo = perInfoModel;
                }

                let pregInfoRes = realm?.objects(PregnancyInfo.self).filter("id = '\(pat.personId)'").first;
                if pregInfoRes != nil {
                    let perInfoModel = PregnancyInfo();
                    perInfoModel.copyFromObject(pregInfoRes!);
                    perInfoModel.id = nil;
                    patient.personPregnancyInfo = perInfoModel;
                }

                person.clinicId = pat.clinicId;
                person.patient = patient;
                person.mobilePersonId = pat.personId;

                requestJson.append(person.toJSONForBatchRequest());


            }
            let urlAddPatientsAndSync = DAMUrls.urlAddPatientsList();
            let request = ApiServices.createPostRequest(urlStr: urlAddPatientsAndSync, parameters: requestJson);

            AlamofireManager.Manager.request(request).responseData {
                (response) in

                if (response.response?.statusCode == 200) {
//                     JSONSerialization.jsonObject(data:response.result.value,options:JSONSerialization.ReadingOptions);
                    let jsonData = try? JSONSerialization.jsonObject(with: response.result.value!, options: []);
//                    print(response.result.value);
                    if (jsonData != nil) {
                        updateShortIdswithLong(jsonData as! [[String: Any]]);
                    }
                }
            }


        } else {
            syncRemainingThingsHere();
        }


    }

    private class func updateShortIdswithLong(_ dataArr: [[String: Any]]) {
        let realm = try? Realm();
        try? realm?.write({
            for athor in dataArr {

                //#MARK THE MOST UGLY CODE
                let item = athor.keys.first!;
                let obj = athor[item] as! [String: Any];
                let replId = obj["id"] as! String;


//                let replId = (athor as! [String:Any])["id"] as! String;
                let respo = realm?.objects(Patient.self).filter("personId = '\(item)'").first;
                if respo != nil {
                    respo?.personId = replId
                    respo?.isUpdated = false
                }

                let respoPersonInfo = realm?.objects(PersonInfoModel.self).filter("id = '\(item)'").first;
                if respoPersonInfo != nil {
                    respoPersonInfo?.id = replId
                }

                let respoPregInfo = realm?.objects(PregnancyInfo.self).filter("id = '\(item)'").first;
                if respoPregInfo != nil {
                    respoPregInfo?.id = replId
                }


                let respoAllergies = realm?.objects(Allergies.self).filter("personId = '\(item)'");
                if respoAllergies != nil {
                    for inte in respoAllergies! {
                        inte.personId = replId
                    }
                }


                let respoAntiMullerianH = realm?.objects(AntiMullerianHormone.self).filter("personId = '\(item)'");
                if respoAntiMullerianH != nil {
                    for inte in respoAntiMullerianH! {
                        inte.personId = replId
                    }
                }


                let respoAppointmentModel = realm?.objects(AppointmentModel.self).filter("patientId = '\(item)'");
                if respoAppointmentModel != nil {
                    for inte in respoAppointmentModel! {
                        inte.patientId = replId
                    }
                }


                let resBasicProfileAttr = realm?.objects(BasicProfileAttributes.self).filter("personId = '\(item)'");
                if resBasicProfileAttr != nil {
                    for inte in resBasicProfileAttr! {
                        inte.personId = replId
                    }
                }


                let resBloodPressure = realm?.objects(BloodPressure.self).filter("personId = '\(item)'");
                if resBloodPressure != nil {
                    for inte in resBloodPressure! {
                        inte.personId = replId
                    }
                }

                let resBloodGlucose = realm?.objects(Bloodglucose.self).filter("personId = '\(item)'");
                if resBloodGlucose != nil {
                    for inte in resBloodGlucose! {
                        inte.personId = replId
                    }
                }


                let resCondition = realm?.objects(Condition.self).filter("personId = '\(item)'");
                if resCondition != nil {
                    for inte in resCondition! {
                        inte.personId = replId
                    }
                }


                let resFamMem = realm?.objects(FamilyMember.self).filter("personId = '\(item)'");
                if resFamMem != nil {
                    for inte in resFamMem! {
                        inte.personId = replId
                    }
                }


                let resFerHistory = realm?.objects(FertilityHistory.self).filter("patientPersonId = '\(item)'");
                if resFerHistory != nil {
                    for inte in resFerHistory! {
                        inte.patientPersonId = replId
                    }
                }


                let resHeight = realm?.objects(Height.self).filter("personId = '\(item)'");
                if resHeight != nil {
                    for inte in resHeight! {
                        inte.personId = replId
                    }
                }


                let resLastMensPeriod = realm?.objects(LastMenstrualPeriod.self).filter("personId = '\(item)'");
                if resLastMensPeriod != nil {
                    for inte in resLastMensPeriod! {
                        inte.personId = replId
                    }
                }


                let resMedication = realm?.objects(Medication.self).filter("personId = '\(item)'");
                if resMedication != nil {
                    for inte in resMedication! {
                        inte.personId = replId
                    }
                }


                let resPregnancy = realm?.objects(Pregnancy.self).filter("personId = '\(item)'");
                if resPregnancy != nil {
                    for inte in resPregnancy! {
                        inte.personId = replId
                    }
                }

                let resPulserate = realm?.objects(Pulserate.self).filter("personId = '\(item)'");
                if resPulserate != nil {
                    for inte in resPulserate! {
                        inte.personId = replId
                    }
                }


                let resQeustion = realm?.objects(Question.self).filter("patientPersonId = '\(item)'");
                if resQeustion != nil {
                    for inte in resQeustion! {
                        inte.patientPersonId = replId
                    }
                }


                let resQeustionResp = realm?.objects(QuestionResponse.self).filter("personId = '\(item)'");
                if resQeustionResp != nil {
                    for inte in resQeustionResp! {
                        inte.personId = replId
                    }
                }


                let resRecord = realm?.objects(Record.self).filter("personId = '\(item)'");
                if resRecord != nil {
                    for inte in resRecord! {
                        inte.personId = replId
                    }
                }


                let resTemperature = realm?.objects(Temperature.self).filter("personId = '\(item)'");
                if resTemperature != nil {
                    for inte in resTemperature! {
                        inte.personId = replId
                    }
                }


                let resThyroidStimulatingHormore = realm?.objects(ThyroidStimulatingHormone.self).filter("personId = '\(item)'");
                if resThyroidStimulatingHormore != nil {
                    for inte in resThyroidStimulatingHormore! {
                        inte.personId = replId
                    }
                }


                let resVisits = realm?.objects(Visit.self).filter("personId = '\(item)'");
                if resVisits != nil {
                    for inte in resVisits! {
                        inte.personId = replId
                    }
                }


                let resWeight = realm?.objects(Weight.self).filter("personId = '\(item)'");
                if resWeight != nil {
                    for inte in resWeight! {
                        inte.personId = replId
                    }
                }


            }
        });


        syncRemainingThingsHere();

    }

    private class func syncRemainingThingsHere() {

        syncPatientsRemaining();
        syncAppointments();
        syncBasicAttributes();
        syncFamilyHistory();
        syncMedications();
        syncAllergies()
        syncConditions();
        syncRecords();
        syncVitals();
        syncFertilityHistory();
        syncPregnancy();
//        syncMenstrualHistory();
//        syncVisit();
//        syncHistory();
    }


    private class func syncPatientsRemaining() {
        var requestJson = [Any]();
        let realm = try? Realm();
        let patients = realm?.objects(Patient.self).filter("isDeleted = false && isUpdated = true");
        if patients != nil && (patients?.count)! > 0 {

            for pat in patients! {
                let person = PatientsWrapperForBatchRequest();

                let patient = Patient();
                patient.refererId = pat.refererId;
                patient.refererName = pat.refererName;
                patient.clinicId = pat.clinicId;

                let personInfoRes = realm?.objects(PersonInfoModel.self).filter("id = '\(pat.personId)'").first;
                if personInfoRes != nil {
                    let perInfoModel = PersonInfoModel();
                    perInfoModel.setFields(personInfoRes!);
                    perInfoModel.id = nil;
                    patient.personInfo = perInfoModel;
                }

                let pregInfoRes = realm?.objects(PregnancyInfo.self).filter("id = '\(pat.personId)'").first;
                if pregInfoRes != nil {
                    let perInfoModel = PregnancyInfo();
                    perInfoModel.copyFromObject(pregInfoRes!);
                    perInfoModel.id = nil;
                    patient.personPregnancyInfo = perInfoModel;
                }

                person.clinicId = pat.clinicId;
                person.patient = patient;
                person.mobilePersonId = pat.personId;

                requestJson.append(person.toJSONForBatchRequest());


            }
            let urlAddPatientsAndSync = DAMUrls.urlAddPatientsList();
            let request = ApiServices.createPostRequest(urlStr: urlAddPatientsAndSync, parameters: requestJson);

            AlamofireManager.Manager.request(request).responseData {
                (response) in

                if (response.response?.statusCode == 200) {
//                     JSONSerialization.jsonObject(data:response.result.value,options:JSONSerialization.ReadingOptions);
                    let jsonData = try? JSONSerialization.jsonObject(with: response.result.value!, options: []);
//                    print(response.result.value);
                    if (jsonData != nil) {
                        updateShortIdswithLong(jsonData as! [[String: Any]]);
                    }
                }
            }


        }
    }

    private class func syncPregnancy() {
        let url = DAMUrls.urlPatientAddPregnancyHistory();
        let realm = try? Realm();
        let resPregnancy = realm?.objects(Pregnancy.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if (resPregnancy != nil && ((resPregnancy?.count)! > 0)) {
            for item in resPregnancy! {
                let fertHist = Pregnancy();
                fertHist.setFields(item, true);
                let request = ApiServices.createPostRequest(urlStr: url, parameters: fertHist.toJSONForBatchRequest());
                AlamofireManager.Manager.request(request).responseObject {
                    //                    response in
                    //                    print(response.result.value);
                    (response: DataResponse<Pregnancy>) in
                    try? realm?.write({
                        if response.response?.statusCode == 200 {
                            if let fertHist = response.result.value {
                                realm?.add(fertHist);
                            }
                        } else {
                            realm?.add(fertHist);
                        }
                    });
                }
            }
            try? realm?.write({
                realm?.delete(resPregnancy!);
            });
        }
    }

    private class func syncFertilityHistory() {
        let url = DAMUrls.urlPatientFertilityHistoryAdd();
        let realm = try? Realm();
        let resFertilityHistory = realm?.objects(FertilityHistory.self).filter("(isDeleted = false && isUpdated = true) && !(patientPersonId LIKE '?????????????')");

        if (resFertilityHistory != nil && ((resFertilityHistory?.count)! > 0)) {
            for item in resFertilityHistory! {
                let dateFrom = item.dateFrom;
                let dateTo = item.dateTo;
                let fertHist = FertilityHistory();
                fertHist.setFields(item, true);
                var drama = fertHist.toJSONForBatchRequest();
                drama["dateTo"] = dateTo;
                drama["dateFrom"] = dateFrom;
                let request = ApiServices.createPostRequest(urlStr: url, parameters: drama);
                AlamofireManager.Manager.request(request).responseObject {
//                    response in
//                    print(response.result.value);
                    (response: DataResponse<FertilityHistory>) in
                    try? realm?.write({
                        if response.response?.statusCode == 200 {
                            if let fertHist = response.result.value {
                                realm?.add(fertHist);
                            }
                        } else {
                            realm?.add(fertHist);
                        }
                    });
                }
            }
            try? realm?.write({
                realm?.delete(resFertilityHistory!);
            });
        }

    }

    private class func syncVitals() {
        let url = DAMUrls.urlAddVitals();
        let realm = try? Realm();
        let resBloodPress = realm?.objects(BloodPressure.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")
        if (resBloodPress != nil && ((resBloodPress?.count)! > 0)) {
            for item in resBloodPress! {
                let vitals = ResponseVitals();
                let bp = BloodPressure();
                bp.setFields(obj: item);
                vitals.bloodPressure = bp;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.bloodPressure {
                                let res = realm?.objects(BloodPressure.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.bloodPressure?.personId)!)'").first
                                if res != nil {
                                    res?.bp_id = bp.bp_id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }

        let resGlucose = realm?.objects(Bloodglucose.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")
        if (resGlucose != nil && ((resGlucose?.count)! > 0)) {
            for item in resGlucose! {
                let vitals = ResponseVitals();
                let bg = Bloodglucose();
                bg.setFields(item);
                vitals.bloodglucose = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.bloodglucose {
                                let res = realm?.objects(Bloodglucose.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.bloodglucose?.personId)!)'").first
                                if res != nil {
                                    res?.bg_id = bp.bg_id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }
        let resWeight = realm?.objects(Weight.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")
        if (resWeight != nil && ((resWeight?.count)! > 0)) {
            for item in resWeight! {
                let vitals = ResponseVitals();
                let bg = Weight();
                bg.setFields(item);
                vitals.weight = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.weight {
                                let res = realm?.objects(Weight.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.weight?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }
        let resHeight = realm?.objects(Height.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")
        if (resHeight != nil && ((resHeight?.count)! > 0)) {
            for item in resHeight! {
                let vitals = ResponseVitals();
                let bg = Height();
                bg.setFields(item);
                vitals.height = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.height {
                                let res = realm?.objects(Height.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.height?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }
        let resHemoglobin = realm?.objects(Hemoglobin.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")

        if (resHemoglobin != nil && ((resHemoglobin?.count)! > 0)) {
            for item in resHemoglobin! {
                let vitals = ResponseVitals();
                let bg = Hemoglobin();
                bg.setFields(item);
                vitals.hemoglobin = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.hemoglobin {
                                let res = realm?.objects(Hemoglobin.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.hemoglobin?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }


        let resLastMenstrualPeriod = realm?.objects(LastMenstrualPeriod.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")

        if (resLastMenstrualPeriod != nil && ((resLastMenstrualPeriod?.count)! > 0)) {
            for item in resLastMenstrualPeriod! {
                let vitals = ResponseVitals();
                let bg = LastMenstrualPeriod();
                bg.setFields(item);
                vitals.lastMenstrualPeriod = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.lastMenstrualPeriod {
                                let res = realm?.objects(LastMenstrualPeriod.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.lastMenstrualPeriod?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }


        let resPulseRate = realm?.objects(Pulserate.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")

        if (resPulseRate != nil && ((resPulseRate?.count)! > 0)) {
            for item in resPulseRate! {
                let vitals = ResponseVitals();
                let bg = Pulserate();
                bg.setFields(item);
                vitals.pulserate = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.pulserate {
                                let res = realm?.objects(Pulserate.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.pulserate?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }

        let resTemperature = realm?.objects(Temperature.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")

        if (resTemperature != nil && ((resTemperature?.count)! > 0)) {
            for item in resTemperature! {
                let vitals = ResponseVitals();
                let bg = Temperature();
                bg.setFields(item);
                vitals.temperature = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.temperature {
                                let res = realm?.objects(Temperature.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.temperature?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }


        let resThyroidStiHor = realm?.objects(ThyroidStimulatingHormone.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')")
        if (resThyroidStiHor != nil && ((resThyroidStiHor?.count)! > 0)) {
            for item in resThyroidStiHor! {
                let vitals = ResponseVitals();
                let bg = ThyroidStimulatingHormone();
                bg.setFields(item);
                vitals.thyroidStimulatingHormone = bg;

                let request = ApiServices.createPostRequest(urlStr: url, parameters: vitals.toJSON());
                AlamofireManager.Manager.request(request).responseObject {
                    (response: DataResponse<ResponseVitals>) in
                    if response.response?.statusCode == 200 {
                        print("vitals \(response.result.value?.toJSONString())");
                        try? realm?.write {
                            if let bp = response.result.value?.thyroidStimulatingHormone {
                                let res = realm?.objects(ThyroidStimulatingHormone.self).filter("(isDeleted = false && isUpdated = true) && personId = '\((response.result.value?.thyroidStimulatingHormone?.personId)!)'").first
                                if res != nil {
                                    res?.id = bp.id!;
                                    res?.isUpdated = false;
                                } else {
                                    realm?.add(bp);
                                }
                            }
                        }
                    }
                }

            }
        }


    }

    private class func syncRecords() {
//        records/file/add
        let realm = try? Realm();
        let results = realm?.objects(Record.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if results != nil && (results?.count)! > 0 {
            var arrOfObjects = [[String: Any]]();
            for obj in results! {
                let basic = Record();
                basic.setFields(obj: obj);
                arrOfObjects.append(basic.toJSONForBatchrequest());
            }
            let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
            DAMUrls.urlAddRecord(), parameters: arrOfObjects);
            AlamofireManager.Manager.request(requestUpdateBasicInfo).responseArray {
//                response in
//                print(response.result.value ?? ":");
                (response: DataResponse<[Record]>) in
//                print(response.result.value)
                if response.response?.statusCode == 200 {
                    if response.result.value != nil {
                        if let arr = response.result.value {
                            saveRecords(arr);
                        }
                    }
                } else {
                    print("Some Error Occured allergies");
                    print(response.result.error?.localizedDescription);
                }

            };
        }

    }

    private class func saveRecords(_ arr: [Record]) {
        let realm = try? Realm();
        try? realm?.write({
//            if let arr = family {
            let result = realm?.objects(Record.self)
                    .filter("isUpdated = true AND isDeleted = false")
            if result != nil {
                realm?.delete(result!);
            }

            for item in arr {
                realm?.add(item);
                item.isUpdated = false;
            }
        });
    }

    private class func syncConditions() {
        let url = DAMUrls.urlPatientConditionsAdd();
        let realm = try? Realm();
        let resPregnancy = realm?.objects(Condition.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if (resPregnancy != nil && ((resPregnancy?.count)! > 0)) {
            for item in resPregnancy! {
                let fertHist = Condition();
                fertHist.setFields(item, isUpdated: true);
                let request = ApiServices.createPostRequest(urlStr: url, parameters: fertHist.toJSONForBatchRequest());
                AlamofireManager.Manager.request(request).responseObject {
                    //                    response in
                    //                    print(response.result.value);
                    (response: DataResponse<Condition>) in
                    try? realm?.write({
                        if response.response?.statusCode == 200 {
                            if let fertHist = response.result.value {
                                realm?.add(fertHist);
                            }
                        } else {
                            realm?.add(fertHist);
                        }
                    });
                }
            }
            try? realm?.write({
                realm?.delete(resPregnancy!);
            });
        }
    }

    private class func syncAllergies() {
        let url = DAMUrls.urlPatientAllergyAdd();
        let realm = try? Realm();
        let resPregnancy = realm?.objects(Allergies.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if (resPregnancy != nil && ((resPregnancy?.count)! > 0)) {
            for item in resPregnancy! {
                let fertHist = Allergies();
                fertHist.setRefinedFields(obj: item);
                fertHist.isUpdated = true;
                let request = ApiServices.createPostRequest(urlStr: url, parameters: fertHist.toJSONForBatchRequest());
                AlamofireManager.Manager.request(request).responseObject {
                    //                    response in
                    //                    print(response.result.value);
                    (response: DataResponse<Allergies>) in
                    try? realm?.write({
                        if response.response?.statusCode == 200 {
                            if let fertHist = response.result.value {
                                realm?.add(fertHist);
                            }
                        } else {
                            realm?.add(fertHist);
                        }
                    });
                }
            }
            try? realm?.write({
                realm?.delete(resPregnancy!);
            });
        }
    }


    private class func syncAppointments() {
        let realm = try? Realm();
       if true {
            let apntRes = realm?.objects(AppointmentModel.self).filter("isDeleted = false && isUpdated = true");
            var listAppointments = [[String: Any]]();
            if apntRes != nil {
                for item in apntRes! {
                    let appoint = AppointmentModel();
                    let jsonA = appoint.getJSONforBatchRequestWithId(item);
                    listAppointments.append(jsonA)
                }
                if listAppointments.count > 0
                {
                    let url = DAMUrls.urlAddAppointmentsList();
                    let request = ApiServices.createPostRequest(urlStr: url, parameters: listAppointments);
                    AlamofireManager.Manager.request(request).responseData {
                        response in
                        if (response.response?.statusCode == 200) {
                            let jsonData = try? JSONSerialization.jsonObject(with: response.result.value!, options: []);
                            if (jsonData != nil) {
                                self.updateAppoinmentStatus(strResponse: jsonData as! [String : AnyObject])
                            }
                        }
                    }
                }

            }
        }
//        AppointmentDelete
        let localDelete = realm?.objects(AppointmentModel.self).filter("id LIKE '\(regEx)' AND isDeleted = true");
        try? realm?.write {
            realm?.delete(localDelete!);
        }
    

        if true {
            let apntRes = realm?.objects(AppointmentModel.self).filter("!(id LIKE '\(regEx)') AND isDeleted = true");


            var listAppointments = [[String: Any]]();
            if apntRes != nil {
                for item in apntRes! {
                    let appoint = AppointmentModel();
                    let jsonA = appoint.getJSONforBatchRequest(item);
                    listAppointments.append(jsonA)
                }
                if listAppointments.count > 0
                {
                    let url = DAMUrls.urlDeleteAppointmentsList();
                    let request = ApiServices.createPostRequest(urlStr: url, parameters: listAppointments);
                    AlamofireManager.Manager.request(request).responseData {
                        response in
                        if (response.response?.statusCode == 200) {
                            realm?.delete(apntRes!);
                            let jsonData = try? JSONSerialization.jsonObject(with: response.result.value!, options: []);
                            if (jsonData != nil) {
                            }
                        }
                    }
                }
            }
        }

    }
    private class func updateAppoinmentStatus(strResponse:[String:AnyObject])
    {
        
        for key in strResponse.keys
        {
            let realm = try? Realm();
            let apntRes = realm?.objects(AppointmentModel.self).filter("id = '\(key)'");
            if apntRes != nil {
                for item in apntRes! {
                    do {
                        try realm?.write {
                            item.isUpdated = false
                            item.id = strResponse[key] as! String
                        }
                    } catch {
                        //handle error
                        print(error)
                    }
                    
                }
            }
        }
    }
    private class func updateShortIdswithLongForAppointments(_ dataArr: [[String: Any]]) {

        let realm = try? Realm();
        try? realm?.write({
            for athor in dataArr {

                //#MARK THE MOST UGLY CODE
                let item = athor.keys.first!;
                let obj = athor[item]!;
                let replId = obj;


//                let replId = (athor as! [String:Any])["id"] as! String;
                let respo = realm?.objects(AppointmentModel.self).filter("id = '\(item)'").first;
                if respo != nil {
                    respo?.id = replId as! String
                }

            }

        });
    }

    private class func syncMedications() {
        let realm = try? Realm();
        let results = realm?.objects(Medication.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if results != nil && (results?.count)! > 0 {
            var arrOfObjects = [[String: Any]]();
            for obj in results! {
                let basic = Medication();
                basic.setRefinedFields(obj: obj);
                arrOfObjects.append(basic.toJSON());
            }
            let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
            DAMUrls.urlCurrentMedicationsAddArray(), parameters: arrOfObjects);
            AlamofireManager.Manager.request(requestUpdateBasicInfo).responseArray {
                (response: DataResponse<[Medication]>) in
//                print(response.result.value)
                if response.response?.statusCode == 200 {
                    if response.result.value != nil {
                        if let arr = response.result.value {
                            saveMedications(arr);
                        }
                    }
                } else {
                    print("Some Error Occured");
                }

            };
        }
    }

    private class func saveMedications(_ arr: [Medication]) {
        let realm = try? Realm();
        try? realm?.write({
//            if let arr = family {
            let result = realm?.objects(Medication.self)
                    .filter("isUpdated = true AND isDeleted = false")
            if result != nil {
                realm?.delete(result!);
            }

            for item in arr {
                realm?.add(item);
                item.isUpdated = false;
            }
        });
    }

    private class func syncFamilyHistory() {
        let realm = try? Realm();
        let results = realm?.objects(FamilyMember.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if results != nil && (results?.count)! > 0 {
            var arrOfObjects = [[String: Any]]();
            for obj in results! {
                let basic = FamilyMember();
                basic.setRefinedFields(obj: obj);
                arrOfObjects.append(basic.toJSON());
            }
            let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
            DAMUrls.urlPatientAddFamilyHistory(), parameters: arrOfObjects);
            AlamofireManager.Manager.request(requestUpdateBasicInfo).responseArray {
                (response: DataResponse<[FamilyMember]>) in
                if response.response?.statusCode == 200 {
                    if response.result.value != nil {
                        if let arrFamily = response.result.value {
                            saveFamilyHistory(arrFamily);
                        }
                    }
                } else {
                    print("Some Error Occured");
                }

            };
        }
    }

    private class func saveFamilyHistory(_ family: [FamilyMember]) {
        let realm = try? Realm();
        try? realm?.write({
//            if let arr = family {
            let result = realm?.objects(FamilyMember.self)
                    .filter("isUpdated = true AND isDeleted = false")
            if result != nil {
                realm?.delete(result!);
            }

            for item in family {
                item.isUpdated = false;
                realm?.add(item);
            }
        });
    }

    private class func syncBasicAttributes() {
        let realm = try? Realm();
        let results = realm?.objects(BasicProfileAttributes.self).filter("(isDeleted = false && isUpdated = true) && !(personId LIKE '?????????????')");

        if results != nil && (results?.count)! > 0 {
            var arrOfObjects = [[String: Any]]();
            for obj in results! {
                let basic = BasicProfileAttributes();
                basic.setRefinedFields(attribute: obj);
                arrOfObjects.append(basic.toJSON());
            }
            let requestUpdateBasicInfo = ApiServices.createPostRequest(urlStr:
            DAMUrls.urlUpdatePatientBasicProfile(), parameters: [Names.PERSON_ATTRIBUTES: arrOfObjects]);
            AlamofireManager.Manager.request(requestUpdateBasicInfo).responseObject {
                (response: DataResponse<ResponseBasicAttributesSync>) in
                if response.response?.statusCode == 200 {
                    if response.result.value != nil {
                        if let attrArray = response.result.value {
                            saveBasicAttrToDB(attrArray.personAttributes);
                        }
                    }
                } else {
                    print("Some Error Occured");
                }

            };
        }
    }

    private class func saveBasicAttrToDB(_ attributes: [BasicProfileAttributes]?) {
        let realm = try? Realm();
        try? realm?.write({
            if let arr = attributes {
                for item in arr {
                    if let result = realm?.objects(BasicProfileAttributes.self)
                            .filter("personId = '\((item.personId!))' AND name = '\(item.name!)'").first {
                        result.id = item.id;
                        result.isUpdated = false;
                    } else {
                        print(item)
                    }
                }

            }
        });
    }

}
