//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class AntiMullerianHormone: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        id <- map["id"];
        antiMullerianHormone <- map["antiMullerianHormone"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }

    dynamic var id: String?;
    dynamic var antiMullerianHormone: Int = 0;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setField(
            antiMullerianHormone: Int,
            measuredTime: Int64,
            visitId: String,
            personId: String
    ) {
        self.antiMullerianHormone = antiMullerianHormone;
        self.measuredTime = measuredTime;
        self.visitId = visitId;
        self.personId = personId;
    }
}
