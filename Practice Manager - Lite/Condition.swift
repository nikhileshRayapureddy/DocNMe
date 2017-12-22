//
// Created by Sandeep Rana on 30/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Condition: Object, Mappable {
    dynamic var id: Int = 0;
    dynamic var medicalname: String?;
    dynamic var personId: String?;
    dynamic var since: Int64 = 0;
    dynamic var isUpdated = false;
    dynamic var isDeleted = false;


    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {

        id <- map["id"];
        medicalname <- map["medicalname"];
        personId <- map["personId"];
        since <- map["since"];

    }

    func setFields(_ item: Condition, isUpdated: Bool) {
        self.id = item.id;
        self.medicalname = item.medicalname;
        self.personId = item.personId;
        self.since = item.since;
        self.isUpdated = isUpdated;
        self.isDeleted = item.isDeleted;
    }

    func toJSONForBatchRequest() -> [String: Any] {
        var json = self.toJSON();
        json["isUpdated"] = nil;
        json["isDeleted"] = nil;
        json["createdDate"] = nil;
        json["modifiedDate"] = nil;
        json["dateFromTemp"] = nil;
        json["dateToTemp"] = nil;
        return json;
    }
}
