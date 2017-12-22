//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Hemoglobin: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        id <- map["id"];
        hemoglobin <- map["hemoglobin"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }

    dynamic var id: String?;
    dynamic var hemoglobin: Int = -1;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setField(
            hemoglobin: Int?,
            measuredTime: Int64?,
            visitId: String?,
            personId: String?
    ) {
        self.hemoglobin = hemoglobin!;
        self.measuredTime = measuredTime!;
        self.visitId = visitId;
        self.personId = personId;
    }

    func setFields(_ item: Hemoglobin) {
        self.id = item.id;
        self.hemoglobin = item.hemoglobin;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }
}
