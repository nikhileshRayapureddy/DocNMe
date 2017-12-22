//
// Created by Sandeep Rana on 09/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CreditAttribute: Object, Mappable {
    var id: Int = 0;
    var clinicId: String?;
    var name:String?;
    var creditsAvailable: Int = 0;
    var createdDate: Int64 = 0;

    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        clinicId <- map["clinicId"];
        creditsAvailable <- map["creditsAvailable"];
        createdDate <- map["createdDate"];
        modifiedDate <- map["modifiedDate"];
    }

    var modifiedDate: Int64 = 0;
}
