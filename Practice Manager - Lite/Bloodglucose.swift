//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Bloodglucose: Object, Mappable {

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        bg_id <- map["id"];
//        high <- map["high"];
//        low <- map["low"];
        type <- map["type"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
        bloodglucose <- map["bloodglucose"];
        unit <- map["unit"];
    }

    dynamic var bg_id: String?;
    dynamic var type: String?;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var bloodglucose: Int = 0;
    dynamic var unit: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }


    func setField(
//            high: Int,
//            low: Int,
            type: String,
            measuredTime: Int64,
            visitId: String,
            personId: String,
            bloodglucose: Int,
            unit: String
    ) {
//        self.high = high;
//        self.low = low;
        self.type = type;
        self.measuredTime = measuredTime;
        self.visitId = visitId;
        self.personId = personId;
        self.bloodglucose = bloodglucose;
        self.unit = unit;
    }

    func setFields(_ item: Bloodglucose) {
        self.bg_id = item.bg_id;
        self.type = item.type;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.bloodglucose = item.bloodglucose;
        self.unit = item.unit;
//        self.isUpdated = item.isUpdated;
//        self.isDeleted = item.isDeleted;
    }

}
