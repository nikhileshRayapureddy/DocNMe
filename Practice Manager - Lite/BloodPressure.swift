//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class BloodPressure: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    
    func mapping(map: Map) {
        bp_id <- map["id"];
        diastolic <- map["diastolic"];
        systolic <- map["systolic"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }

    dynamic var bp_id: String?;
    dynamic var diastolic: Int = 1;
    dynamic var systolic: Int = 1;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setField(
            diastolic: Int?,
            systolic: Int?,
            measuredTime: Int64?,
            visitId: String?,
            personId: String?

    ) {
        self.diastolic = diastolic!;
        self.systolic = systolic!;
        self.measuredTime = measuredTime!;
        self.visitId = visitId;
        self.personId = personId;
        self.isUpdated = true;
    }

    func setFields(obj: BloodPressure) {
        if obj.bp_id != nil {
            self.bp_id = obj.bp_id
        };
        if obj.diastolic != nil {
            self.diastolic = obj.diastolic
        };
        if obj.systolic != nil {
            self.systolic = obj.systolic
        };
        if obj.measuredTime != nil {
            self.measuredTime = obj.measuredTime
        };
        if obj.visitId != nil {
            self.visitId = obj.visitId
        };
        if obj.personId != nil {
            self.personId = obj.personId
        };
        if obj.isUpdated != nil {
            self.isUpdated = obj.isUpdated
        };
    }

    func toJSONForBatchrequest() -> [String: Any] {
        var json = self.toJSON();
        json["isUpdated"] = nil;
        json["isDeleted"] = nil;
        return json;
    }
}
