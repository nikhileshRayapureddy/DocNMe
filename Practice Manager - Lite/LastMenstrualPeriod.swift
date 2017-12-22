//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class LastMenstrualPeriod: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        lmp <- map["lmp"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }

    dynamic var id: String?;
    dynamic var lmp: Int64 = 0;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func setField(
            lmp: Int64,
            measuredTime: Int64,
            visitId: String,
            personId: String
    ) {
        self.lmp = lmp;
        self.measuredTime = measuredTime;
        self.visitId = visitId;
        self.personId = personId;
    }

    func setFields(_ item: LastMenstrualPeriod) {
        self.id = item.id;
        self.lmp = item.lmp;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }
}
