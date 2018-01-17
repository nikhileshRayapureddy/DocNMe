//
// Created by Sandeep Rana on 22/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

public class AppointmentModel: Object, Mappable {
    public required convenience init?(map: Map) {
        self.init();
    }

    public func mapping(map: Map) {
        doctorInfo <- map["doctorInfo"];
        patientInfo <- map["patientInfo"];
        id <- map["id"];
        appointmentFrom <- map["appointmentFrom"];
        appointmentTo <- map["appointmentTo"];
        purpose <- map["purpose"];
        status <- map["status"];
        notes <- map["notes"];
        type <- map["type"];
        source <- map["source"];
        clinic <- map["clinic"];
        edd <- map["edd"];
        clinicPatientId <- map["clinicPatientId"];
        appointmentAudits <- map["appointmentAudits"];
        protocolStr <- map["protocolStr"];
        patientFertilityProfile <- map["patientFertilityProfile"];
        personPregnancyProfile <- map["personPregnancyProfile"];
        spouseName <- map["spouseName"];
        nePatient <- map["newPatient"];
        if doctorInfo != nil {
            self.doctorId = doctorInfo.id;
        }
        if patientInfo != nil {
            self.patientId = patientInfo.id;
        }
    }

    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;
    dynamic var patientId: String?;
    dynamic var doctorId: String?;
    var doctorInfo: PersonInfoModel!;
    var patientInfo: PersonInfoModel!;
    dynamic var id: String!;
    dynamic var appointmentFrom: Int64 = 0;
    dynamic var appointmentTo: Int64 = 0;
    dynamic var purpose: String!;
    dynamic var status: String!;
    dynamic var notes: String!;
    dynamic var type: String!;
    dynamic var source: String!;
    dynamic var clinic: String!;
    dynamic var edd: Int64 = 0;
    dynamic var clinicPatientId: String!;
    dynamic var appointmentAudits: String!;
    dynamic var protocolStr: String!;
    dynamic var patientFertilityProfile: String!;
    dynamic var personPregnancyProfile: String!;
    dynamic var spouseName: String!;
    dynamic var nePatient: Bool = false;

//    public static func initFromJsonData(data: [String: Any]) -> AppointmentModel {
//        let model: AppointmentModel = AppointmentModel();
//        model.id = data[Names.ID];
//        model.appointmentFrom = data[Names.APPOINTMENTFROM];
//        model.appointmentTo = data[Names.APPOINTMENTTO];
//        model.purpose = data[Names.PURPOSE];
//        model.status = data[Names.STATUS];
//        model.notes = data[Names.NOTES];
//        model.type = data[Names.TYPE];
//        model.source = data[Names.SOURCE];
//        model.clinic = data[Names.CLINIC];
//        model.edd = data[Names.EDD];
//        model.clinicPatientId = data[Names.CLINICPATIENTID];
//        model.appointmentAudits = data[Names.APPOINTMENTAUDITS];
//        model.protocolStr = data[Names.PROTOCOLSTR];
//        model.patientFertilityProfile = data[Names.PATIENTFERTILITYPROFILE];
//        model.personPregnancyProfile = data[Names.PERSONPREGNANCYPROFILE];
//        model.spouseName = data[Names.SPOUSENAME];
//        model.newPatient = data[Names.NEWPATIENT];
//
//        let doctorInfoJSON = data[Names.DOCTORINFO] as! [String: Any];
//        model.doctorInfo = DoctorInfoModel.initFromJson(data: doctorInfoJSON);
//
//
//        let patientInfoModel = data[Names.PATIENTINFO] as! [String: Any];
//        model.patientInfo = PatientInfoModel.initFromJsonData(data: patientInfoModel);
//
//        return model;
//    }

    public static func getAppointmentsListFromArray(data: [AppointmentModel]) -> [String: [AppointmentModel]] {
        var arrOfAppointments = [String: [AppointmentModel]]();
        let dat = DateFormatter();
        dat.locale = Calendar.current.locale
        dat.timeZone = Calendar.current.timeZone
        dat.dateFormat = "ddMMyyyy";


        for appoint in data {
//            let appont = AppointmentModel.initFromJsonData(data: appointment as! [String: Any]);
            let date = Date.init(milliseconds: appoint.appointmentFrom);
            let dateString = dat.string(from: date);

            if arrOfAppointments[dateString] != nil {
                arrOfAppointments[dateString]?.append(appoint);
            } else {
                arrOfAppointments[dateString] = [appoint];
            }
        }
        return arrOfAppointments;
    }

    func getJSONforBatchRequest(_ item: AppointmentModel) -> [String: Any] {
        self.id = nil;
        self.appointmentFrom = item.appointmentFrom;
        self.appointmentTo = item.appointmentTo;
        self.purpose = item.purpose;
        
        
        var js = self.toJSON();
        js["mobileAppointmentID"] = item.id;
        js["patientPersonId"] = item.patientId;
        js["doctorPersonId"] = item.doctorId;
        js["edd"] = nil;
        js["nePatient"] = nil;
        js["newPatient"] = nil;
        js["isUpdated"] = nil;
        js["isDeleted"] = nil;
        return js;
    }
    
    func getJSONforBatchRequestWithId(_ item: AppointmentModel) -> [String: Any] {
//        self.id = nil;
        self.appointmentFrom = item.appointmentFrom;
        self.appointmentTo = item.appointmentTo;
        self.purpose = item.purpose;
        
        
        var js = self.toJSON();
        js["patientPersonId"] = item.patientId;
        js["doctorPersonId"] = item.doctorId;
        js["mobileAppointmentID"] = item.id;
        js["edd"] = nil;
        js["nePatient"] = nil;
        js["newPatient"] = nil;
        js["isUpdated"] = nil;
        js["isDeleted"] = nil;
        return js;
    }
    class func fromAppointmentModel(_ item: AppointmentModel) -> AppointmentModel {
        let app = AppointmentModel();
        app.isUpdated = item.isUpdated;
        app.isDeleted = item.isDeleted;
        app.patientId = item.patientId;
        app.doctorId = item.doctorId;
        app.doctorInfo = item.doctorInfo;
        app.patientInfo = item.patientInfo;
        app.id = item.id;
        app.appointmentFrom = item.appointmentFrom;
        app.appointmentTo = item.appointmentTo;
        app.purpose = item.purpose;
        app.status = item.status;
        app.notes = item.notes;
        app.type = item.type;
        app.source = item.source;
        app.clinic = item.clinic;
        app.edd = item.edd;
        app.clinicPatientId = item.clinicPatientId;
        app.appointmentAudits = item.appointmentAudits;
        app.protocolStr = item.protocolStr;
        app.patientFertilityProfile = item.patientFertilityProfile;
        app.personPregnancyProfile = item.personPregnancyProfile;
        app.spouseName = item.spouseName;
        app.nePatient = item.nePatient;
        return app;
    }
}
