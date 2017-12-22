//
// Created by Sandeep Rana on 30/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Allergies: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {

        id <- map["id"];
        hereditary <- map["hereditary"];
        isseasonal <- map["isseasonal"];
        medicalname <- map["medicalname"];
        symptoms <- map["symptoms"];
        personId <- map["personId"];
        since <- map["since"];
    }

    dynamic var id: Int = 0;
    dynamic var hereditary: Bool = false;
    dynamic var isseasonal: Bool = false;
    dynamic var medicalname: String?;
    dynamic var symptoms: String?;
    dynamic var personId: String?;
    dynamic var since: Int64 = 0;
    dynamic var isUpdated = false;
    dynamic var isDeleted = false;

    func setFields(hereditary: Bool,
                   isseasonal: Bool,
                   medicalname: String,
                   symptoms: String,
                   personId: String,
                   since: Int64
    ) {
        self.hereditary = hereditary;
        self.isseasonal = isseasonal;
        self.medicalname = medicalname;
        self.symptoms = symptoms;
        self.personId = personId;
        self.since = since;
        self.isUpdated = true;
    }


    func toJSONForBatchrequest() -> [String: Any] {
        var obj = self.toJSON();
        obj["isUpdated"] = nil;
        obj["isDeleted"] = nil;
        if self.id == 0 {
            obj["id"] = nil;
        }
        return obj;
    }

    func setRefinedFields(obj: Allergies) {
        if obj.id != nil {
            self.id = obj.id;
        }
        if obj.hereditary != nil {
            self.hereditary = obj.hereditary;
        }
        if obj.isseasonal != nil {
            self.isseasonal = obj.isseasonal;
        }
        if obj.medicalname != nil {
            self.medicalname = obj.medicalname;
        }
        if obj.symptoms != nil {
            self.symptoms = obj.symptoms;
        }
        if obj.personId != nil {
            self.personId = obj.personId;
        }
        if obj.since != nil {
            self.since = obj.since;
        }
        if obj.isUpdated != nil {
            self.isUpdated = obj.isUpdated;
        }
        if obj.isDeleted != nil {
            self.isDeleted = obj.isDeleted;
        }
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
