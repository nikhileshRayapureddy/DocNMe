//
// Created by Sandeep Rana on 01/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper

import RealmSwift

class Record: Object, Mappable {


    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        error_description <- map["error_description"];
        id <- map["id"];
        parentId <- map["parentId"];
        doctorName <- map["doctorName"];
        issuerName <- map["issuerName"];
        personId <- map["personId"];
        name <- map["name"];
        type <- map["type"];
        isdirectory <- map["isdirectory"];
        uploadtime <- map["uploadtime"];
        dateofissue <- map["dateofissue"];
        visitId <- map["visitId"];
        notes <- map["notes"];
        mimetype <- map["mimetype"];
        content <- map["content"];
        language <- map["language"];
//        keywords <- map["keywords"];
        personPregnancyProfileId <- map["personPregnancyProfileId"];
        directoryId <- map["directoryId"];
    }

    dynamic var resultsString: String?;
    dynamic var isUpdated = false;
    dynamic var isDeleted = false;
    dynamic var error_description: String?;
    dynamic var id: String?;
    dynamic var parentId: String?;
    dynamic var doctorName: String?;
    dynamic var issuerName: String?;
    dynamic var personId: String?;
    dynamic var name: String?;
    dynamic var type: String?;
    dynamic var isdirectory: String?;
    dynamic var uploadtime: Int = 0;
    dynamic var dateofissue: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var notes: String?;
    dynamic var mimetype: String?;
    dynamic var content: String?;
    dynamic var language: String?;
    dynamic var keywords: String = "";
    dynamic var personPregnancyProfileId: String?;
    dynamic var directoryId: String?;

    func getDateOfIssue() -> Date {
        return Date(milliseconds: (self.dateofissue));
    }

    func setFields(obj: Record) {
        if obj.isUpdated != nil {
            self.isUpdated = obj.isUpdated;
        }
        if obj.isDeleted != nil {
            self.isDeleted = obj.isDeleted;
        }
        if obj.error_description != nil {
            self.error_description = obj.error_description;
        }
        if obj.id != nil {
            self.id = obj.id;
        }
        if obj.parentId != nil {
            self.parentId = obj.parentId;
        }
        if obj.doctorName != nil {
            self.doctorName = obj.doctorName;
        }
        if obj.issuerName != nil {
            self.issuerName = obj.issuerName;
        }
        if obj.personId != nil {
            self.personId = obj.personId;
        }
        if obj.name != nil {
            self.name = obj.name;
        }
        if obj.type != nil {
            self.type = obj.type;
        }
        if obj.isdirectory != nil {
            self.isdirectory = obj.isdirectory;
        }
        if obj.uploadtime != nil {
            self.uploadtime = obj.uploadtime;
        }
        if obj.dateofissue != nil {
            self.dateofissue = obj.dateofissue;
        }
        if obj.visitId != nil {
            self.visitId = obj.visitId;
        }
        if obj.notes != nil {
            self.notes = obj.notes;
        }
        if obj.mimetype != nil {
            self.mimetype = obj.mimetype;
        }
        if obj.content != nil {
            self.content = obj.content;
        }
        if obj.language != nil {
            self.language = obj.language;
        }
        if obj.keywords != nil {
            self.keywords = obj.keywords;
        }
        if obj.personPregnancyProfileId != nil {
            self.personPregnancyProfileId = obj.personPregnancyProfileId;
        }
        if obj.directoryId != nil {
            self.directoryId = obj.directoryId;
        }
    }

    func toJSONForBatchrequest() -> [String: Any] {
        var obj = self.toJSON();
        obj["isUpdated"] = nil;
        obj["isDeleted"] = nil;
        obj["resultsString"] = nil;
//        if self.id == 0 {
//            obj["id"] = nil;
//        }
        return obj;
    }
}
