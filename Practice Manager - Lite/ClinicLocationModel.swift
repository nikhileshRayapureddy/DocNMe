//
// Created by Sandeep Rana on 22/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class ClinicLocationModel: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        clinicId <- map["clinicId"];
        name <- map["name"];
        address1 <- map["address"];
        phone <- map["phone"];
        address2 <- map["address2"];
        area <- map["area"];
        city <- map["city"];
        state <- map["state"];
        postalCode <- map["postalCode"];
        email <- map["email"];
        createdDate <- map["createdDate"];
        modifiedDate <- map["modifiedDate"];
        country <- map["country"];
        latitude <- map["latitude"];
        longitude <- map["longitude"];
        type <- map["type"];
        status <- map["status"];
    }

    dynamic var id: Int = 0;
    dynamic var clinicId: String?;
    dynamic var name: String?;
    dynamic var address1: String?;
    dynamic var phone: String?;
    dynamic var address2: String?;
    dynamic var area: String?;
    dynamic var city: String?;
    dynamic var state: String?;
    dynamic var postalCode: String?;
    dynamic var email: String?;
    dynamic var createdDate: Int64 = 0;
    dynamic var modifiedDate: Int64 = 0;
    dynamic var country: String?;
    dynamic var latitude: String?;
    dynamic var longitude: String?;
    dynamic var type: String?;
    dynamic var status: String?;
}
