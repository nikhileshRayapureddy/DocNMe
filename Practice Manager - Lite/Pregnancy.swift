//
// Created by Sandeep Rana on 31/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Pregnancy: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        id <- map["id"];
        personId <- map["personId"];
        obDate <- map["obDate"];
        obType <- map["obType"];
        comments <- map["comments"];
        creationDate <- map["creationDate"];
        updateDate <- map["updateDate"];
        createdBy <- map["createdBy"];
        updatedBy <- map["updatedBy"];
        liveBrith <- map["liveBrith"];
    }

    dynamic var id: String?;
    dynamic var personId: String?;
    dynamic var obDate: Int64 = 0;
    dynamic var obType: String?;
    dynamic var comments: String?;
    dynamic var creationDate: Int64 = 0;
    dynamic var updateDate: Int64 = 0;
    dynamic var createdBy: String?;
    dynamic var updatedBy: String?;
    dynamic var liveBrith: Bool = true;
    dynamic var isUpdated = false;
    dynamic var isDeleted = false;


    func getOBDate() -> Date? {
        return Date.init(milliseconds: obDate);
    }


    func setFields(
            id: String?,
            personId: String?,
            obDate: Int64,
            obType: String?,
            comments: String?,
            creationDate: Int64,
            updateDate: Int64,
            createdBy: String?,
            updatedBy: String?,
            liveBrith: Bool?
    ) {
        self.personId = personId;
        self.obDate = obDate;
        self.obType = obType;
        self.comments = comments;
        self.creationDate = creationDate;
        self.updateDate = updateDate;
        self.createdBy = createdBy;
        self.updatedBy = updatedBy;
        self.liveBrith = liveBrith!;
        self.isUpdated = true;
    }

    func setFields(_ item: Pregnancy, _ isUpdated: Bool) {
        self.id = item.id;
        self.personId = item.personId;
        self.obDate = item.obDate;
        self.obType = item.obType;
        self.comments = item.comments;
        self.creationDate = item.creationDate;
        self.updateDate = item.updateDate;
        self.createdBy = item.createdBy;
        self.updatedBy = item.updatedBy;
        self.liveBrith = item.liveBrith;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }

    func toJSONForBatchRequest() -> [String: Any] {
        var obj = self.toJSON();
        obj["isUpdated"] = nil;
        obj["isDeleted"] = nil;
        obj["createdDate"] = nil;
        obj["modifiedDate"] = nil;
        obj["dateFromTemp"] = nil;
        obj["dateToTemp"] = nil;
        return obj;
    }
}
