//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Temperature: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        temperature <- map["temperature"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }


    dynamic var id: String?;
    dynamic var temperature: Int = 0;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setFields(
            temperature: Int?,
            measuredTime: Int64?,
            visitId: String?,
            personId: String?
    ) {


        self.temperature = temperature!;
        self.measuredTime = measuredTime!;
        self.visitId = visitId;
        self.personId = personId;
        isUpdated = true;

    }

    func setFields(_ item: Temperature) {
        self.id = item.id;
        self.temperature = item.temperature;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }
}
