//
// Created by Sandeep Rana on 12/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Visit: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        doctorInfo <- map["doctorInfo"];
        patientInfo <- map["patientInfo"];
        visitTime <- map["visitTime"];
        status <- map["status"];
        purpose <- map["purpose"];
        observations <- map["observations"];
        prescription <- map["prescription"];
        notes <- map["notes"];
        pregnancyProfileId <- map["pregnancyProfileId"];
        visitType <- map["visitType"];
        appointmentId <- map["appointmentId"];
        if doctorInfo != nil {
            doctorId = self.doctorInfo?.id;
        }

        if patientInfo != nil {
            personId = self.patientInfo?.id;
        }
    }

    dynamic var id: String?;
    var doctorInfo: PersonInfoModel?;
    var patientInfo: PersonInfoModel?;

    dynamic var doctorId: String?;
    dynamic var personId: String?;
    dynamic var visitTime: Int64 = 0;
    dynamic var status: String?;
    dynamic var purpose: String?;
    dynamic var observations: String?;
    dynamic var prescription: String?;
    dynamic var notes: String?;
    dynamic var pregnancyProfileId: String?;
    dynamic var visitType: String?;
    dynamic var appointmentId: String?;
}
