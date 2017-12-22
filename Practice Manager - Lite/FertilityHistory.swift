//
// Created by Sandeep Rana on 18/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


public class FertilityHistory: Object, Mappable {


    dynamic var id: String?;
    dynamic var patientPersonId: String?;
    dynamic var treatmentType: String?;
    dynamic var numberOfCycles: Int = 0;
    dynamic var dateFrom: Int64 = 0;
    dynamic var dateTo: Int64 = 0;
    dynamic var pregnant: Int = 0; //1 or 0
    dynamic var note: String?;
    dynamic var createdDate: Int64 = 0;
    dynamic var modifiedDate: Int64 = 0;
    dynamic var createdBy: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;
    var dateFromTemp = "";
    var dateToTemp = "";


    public required convenience init?(map: Map) {
        self.init();
    }

    public func mapping(map: Map) {
        id <- map["id"];
        patientPersonId <- map["patientPersonId"];
        treatmentType <- map["treatmentType"];
        numberOfCycles <- map["numberOfCycles"];
        dateFromTemp <- map["dateFrom"];
        dateToTemp <- map["dateTo"];
        pregnant <- map["pregnant"];
        note <- map["note"];
        createdDate <- map["createdDate"];
        modifiedDate <- map["modifiedDate"];
        createdBy <- map["createdBy"];
//        if dateFromTemp.isNumeric {
            self.dateFrom <- map["dateFrom"];
//        } else {
//            self.dateFrom = 1;
//        }
//        if dateToTemp.isNumeric {
            self.dateTo <- map["dateTo"];
//        } else {
//            self.dateTo = 2;
//        }
    }

    func getDateFromInFormat() -> Date? {
        if self.dateFrom.description.isNumeric {
            return Date.init(milliseconds: self.dateFrom);
        } else {
            return nil;
        }

    }

    func getDateToInFormat() -> Date? {
        if self.dateFrom.description.isNumeric {
            return Date.init(milliseconds: self.dateTo);
        } else {
            return nil;
        }
    }

    func setFields(_ item: FertilityHistory, _ isUpdated: Bool) {
        self.id = item.id;
        self.patientPersonId = item.patientPersonId;
        self.treatmentType = item.treatmentType;
        self.numberOfCycles = item.numberOfCycles;
        self.dateFrom = item.dateFrom;
        self.dateTo = item.dateTo;
        self.pregnant = item.pregnant;
        self.note = item.note;
        self.createdDate = item.createdDate;
        self.modifiedDate = item.modifiedDate;
        self.createdBy = item.createdBy;
        self.isUpdated = isUpdated;
    }

    func toJSONForBatchRequest() -> [String: Any] {
        let dateFromT = self.dateFrom;
        let dateToT = self.dateTo;
        var json = self.toJSON();
        json["dateFrom"] = dateFromT;
        json["dateTo"] = dateToT;
        json["isUpdated"] = nil;
        json["isDeleted"] = nil;
        json["createdDate"] = nil;
        json["modifiedDate"] = nil;
        json["dateFromTemp"] = nil;
        json["dateToTemp"] = nil;
        return json;
    }
}
