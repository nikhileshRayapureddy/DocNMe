//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Weight: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {

        id <- map["id"];
        weight <- map["weight"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];

    }

    dynamic var id: String?;
    dynamic var weight: Int = 1;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated = false;
    dynamic var isDeleted = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setFields(_ item: Weight) {
        self.id = item.id;
        self.weight = item.weight;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }
}
