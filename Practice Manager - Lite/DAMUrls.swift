//
//  DAMUrls.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 03/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation

public class DAMUrls {
    struct URLs {
//        static let baseUrl = "http://139.59.42.79:8080/server/webapi/";
//        static let baseUrl = "https://api.docnme.com/server/webapi/";
//        static let baseUrl = "https://api-dev.docnme.com/server/webapi/";
        static let baseUrl = "https://api-demo.docnme.com/server/webapi/"
    }


    static func loginAndGetAuthTokenUrl() -> String {
        return URLs.baseUrl + "oauth2/token/";
    }

    /**
    params requiered personidurl
    params type diagnostic reports
    */
    class func urlInvestigations() -> String {
//        http://139.59.42.79:8080/server/webapi/records?access_token=d78bb2f0-ef13-349d-a1ac-fc291f794d45&personid=a861c138-6680-47e7-8482-55571ab4d1e5&type=diagnostic_reports
        return URLs.baseUrl + "records";
    }

    class func getTotalBalanceCreditUsable() -> String {
        return URLs.baseUrl + "subscriptions/" + (UserPrefUtil.getClinicResponse()?.clinic!.id)! + "/credits/usage";
    }

    class func urlPatientVisitsList(personInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "personvisits/id/" + personInfo.id;
    }

    class func urlValidateVoucher(couponCode: String) -> String {
        return URLs.baseUrl + "vouchers/validate/" + couponCode;
    }

    static func getSubscriptionType(clinicID: String) -> String {
        return URLs.baseUrl + "clinicattributes?clinicId=" + clinicID + "&attributeNames=subscription_type";
    }

    static func urlSubscriptionPlans() -> String {
        return URLs.baseUrl + "subscriptions/plans";
    }

//    static func getCredits() -> String {
//        return URLs.baseUrl + "subscriptions/" + clinicId + "/credits";
//    }


    class func getRefreshTokenUrl() -> String {
        return URLs.baseUrl + "oauth2/token/";
    }

    class func urlQuestionsListAll(doctorId: String) -> String {
        return URLs.baseUrl + "collab/question/fetch?doctorid=" + doctorId;
    }

    class func urlChangePassword() -> String {
        return URLs.baseUrl + "user/mobile/updatepassword";
    }

    static func urlDoctorsList() -> String {
        return URLs.baseUrl + "personinfos?type=doctor&search=";
    }


    class func urlAddPatientsList() -> String {
        return URLs.baseUrl + "clinics/clinicpatients/add";
    }

    class func urlGetAListOfAnswers(question: Question) -> String {
        return URLs.baseUrl + "collab/comment/fetch/" + question.id!;
    }

    class func urlPatientMenstrualHistory(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "personattributes/attributegroup/MenstrualProfile/?personid=" + patientInfo.id;
    }


    class func urlRequestEnterprise() -> String {
        return URLs.baseUrl + "doctors/request/enterprise";
    }

    class func urlUpgradeThings() -> String {
        return URLs.baseUrl + ""
    }

    class func urlPatientAllergyAdd() -> String {
        return URLs.baseUrl + "allergies/mobile/add";
    }

    static func urlDoctorsEvent(doctorId: String) -> String {
        return URLs.baseUrl + "appointments?id=" + doctorId + "";
    }

    static func urlRescheduleAppointment() -> String {
        return URLs.baseUrl + "appointments/reschedule/";
    }


    class func urlCancelAppointment() -> String {
        return URLs.baseUrl + "appointments/cancel";
    }


    class func urlPatientVitals(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "personvitals/?personid=" + (patientInfo.id)!;
    }

    class func urlPatientAddFamilyHistory() -> String {
        return URLs.baseUrl + "family/add";
    }

    class func urlPatientBasicProfile(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "personattributes/?personid=" + (patientInfo.id)!;
    }

    class func urlGenerateOTPForSignUP() -> String {
        return URLs.baseUrl + "doctors/signup/otp/generate";
    }

    class func urlAddRecord() -> String {
        return URLs.baseUrl + "records/file/add";
    }

    class func urlUpdatePatientBasicProfile() -> String {
        return URLs.baseUrl + "personattributes/add";
    }


    class func urlQuestionCommentAdd() -> String {
        return URLs.baseUrl + "collab/comment/add/";
    }

    class func urlPatientAddToClinic() -> String {
        return URLs.baseUrl + "clinics/clinicpatient/add?personkey=";
    }

    class func urlVerifyOTP() -> String {
        return URLs.baseUrl + "doctors/signup/otp/validate";
    }

    class func urlPatientEditToClinic(_ patient: Patient?) -> String {
        return URLs.baseUrl + "clinics/clinicpatient/update"
    }

    class func urlPatientAllergies(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "allergies/?personid=" + (patientInfo.id)!;
    }

    class func urlPatientConditions(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "conditions/?personid=" + (patientInfo.id)!;
    }

    class func urlPatientCurrentMedications(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "currentmeds/id/" + (patientInfo.id)!;
    }

    class func urlCurrentMedicationsAddArray() -> String {
        return URLs.baseUrl + "currentmeds/add";
    }

    class func urlPatientFamilyHistory(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "family/id/" + (patientInfo.id)!;
    }

    class func urlPatientPregnancyHistory(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "obstetrics?=&personid=" + (patientInfo.id)!;
    }

    class func urlClinicDetails() -> String {
        return URLs.baseUrl + "clinics";
    }

    class func urlAllPatientsListWithPagination(fromOffset: Int, andLimit limit: Int) -> String {
        return URLs.baseUrl + String(format: "network/mobile/patients/gynec/search?offset=%d&limit=%d", fromOffset,limit)
    }

    class func urlAllPatientsList() -> String {
        return URLs.baseUrl + "network/mobile/patients/gynec/search";
    }

    class func urlAllPatientsList(from: String) -> String {
        return URLs.baseUrl + "network/mobile/patients/gynec/search?fromTime=\(from)";
    }

    class func urlUpdateClinicLocations() -> String {
        return URLs.baseUrl + "clinics/location/update?\(Names.ACCESS_TOKEN)=\(UserPrefUtil.getAccessToken())";
    }

    class func urlUpdateClinicDoctorAttributes() -> String {
        return URLs.baseUrl + "personattributes/add?\(Names.ACCESS_TOKEN)=\(UserPrefUtil.getAccessToken())";
    }

    class func urlPatientRecords(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "records?personid=" + (patientInfo.id)!;
    }

    class func urlForImage(imageID: String) -> String {
        return URLs.baseUrl + "records/" + imageID + "/data";
    }

    class func urlPatientGynecHistory(patientInfo: PersonInfoModel) -> String {
        return URLs.baseUrl + "personattributes/attributegroup/GynecProfile/?personid=" + patientInfo.id;
    }

    class func urlPatientVitalsUpdate() -> String {
        return URLs.baseUrl + "personvitals/mobile/add";
    }

    class func urlPatientConditionsAdd() -> String {
        return URLs.baseUrl + "conditions/mobile/add";
    }

    class func urlPatientMedicineAdd() -> String {
        return URLs.baseUrl + "currentmeds/add";
    }

    class func urlPatientGynecHistoryUpdate(patientInfo: PersonInfoModel?) -> String {
        return URLs.baseUrl + "personattributes/add";
    }

    class func urlPatientMenstrualHistoryAdd() -> String {
        return URLs.baseUrl + "personattributes/add";
    }

    class func urlPatientAddPregnancyHistory() -> String {
        return URLs.baseUrl + "obstetrics/mobile/add";
    }

    class func urlPatientFertilityProfile(patientInfo: PersonInfoModel?) -> String {
        return URLs.baseUrl + "personattributes/attributegroup/Fertility/?personid=" + patientInfo!.id;
    }

    class func urlPatientUpdateProfile() -> String {
        return URLs.baseUrl + "personattributes/add";
    }

    class func urlPatientFertilityHistoryGet(patientInfo: PersonInfoModel) -> String {
//        http://139.59.42.79:8080/server/webapi/fertility/history/
        return URLs.baseUrl + "fertility/history/" + patientInfo.id!;
    }

    class func urlPatientFertilityHistoryAdd() -> String {
        return URLs.baseUrl + "fertility/history/add";

    }

    class func urlSignUPCompletion() -> String {
        return URLs.baseUrl + "doctors/signup";
    }

    class func urlAddAppointmentsList() -> String {
        return URLs.baseUrl + "appointments/addlist"
        //        urlDeleteAppointmentsList
    }

    class func urlDeleteAppointmentsList() -> String {
        return URLs.baseUrl + "appointments/cancel"
        //        urlDeleteAppointmentsList
    }

    class func urlCurrentAllergiesAddArray() -> String {
        return URLs.baseUrl + "pregnancyancs/manageAncs"
    }

//    class func urlAddListBloodPressure() -> String {
//        return URLs.baseUrl + ""
//    }

    class func urlAddVitals() -> String {
        return URLs.baseUrl + "personvitals/mobile/add";
    }
    
    class func urlUploadImage() -> String
    {
        return URLs.baseUrl + "person/mobile/uploadimage";
    }
    
    class func urlGetAppointments() -> String
    {
        return URLs.baseUrl + "appointments/clinic/" + (UserPrefUtil.getClinicResponse()?.clinic!.id)!
    }
}













