//
// Created by Sandeep Rana on 22/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Clinic: Object, Mappable {
    dynamic var id: String?;
    dynamic var name: String?;
    dynamic var phone: String?;
    dynamic var mobile: String?;
    dynamic var email: String?;
    dynamic var fax: String?;
    dynamic var website: String?;
    dynamic var createdDate: Int64 = 0;
    dynamic var modifiedDate: Int64 = 0;

    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        phone <- map["phone"];
        mobile <- map["mobile"];
        email <- map["email"];
        fax <- map["fax"];
        website <- map["website"];
        createdDate <- map["createdDate"];
        modifiedDate <- map["modifiedDate"];
    }

}
