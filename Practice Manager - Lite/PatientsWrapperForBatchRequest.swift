//
// Created by Sandeep Rana on 17/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper

class PatientsWrapperForBatchRequest: Mappable {
    var patient: Patient?;
    var personkey: String?;
    var mobilePersonId: String?;
    var clinicId: String?;
    var doctorId: String?;

    required init?(map: Map) {

    }

    init() {
    }

    func mapping(map: Map) {
        patient <- map["patient"];
        personkey <- map["personkey"];
        mobilePersonId <- map["mobilePersonId"];
        clinicId <- map["clinicId"];
        doctorId <- map["doctorId"];
    }

    func toJSONForBatchRequest() -> [String: Any]? {
        var map = self.toJSON();
        map["personkey"] = nil;
        return map;
    }


}
