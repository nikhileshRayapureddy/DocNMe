//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ThyroidStimulatingHormone: Object, Mappable {

    dynamic var id: String?;
    dynamic var thyroidStimulatingHormone: Int = 0;
    dynamic var measuredTime: Int64 = 0;
    dynamic var visitId: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;


    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        thyroidStimulatingHormone <- map["thyroidStimulatingHormone"];
        measuredTime <- map["measuredTime"];
        visitId <- map["visitId"];
        personId <- map["personId"];
    }

    func getDate() -> Date {
        return Date.init(milliseconds: self.measuredTime);
    }

    func setfield(thyroidStimulatingHormone: Int?,
                  measuredTime: Int64?,
                  visitId: String?,
                  personId: String?
    ) {
        self.thyroidStimulatingHormone = thyroidStimulatingHormone!;
        self.measuredTime = measuredTime!;
        self.visitId = visitId;
        self.personId = personId;
    }

    func setFields(_ item: ThyroidStimulatingHormone) {
        self.id = item.id;
        self.thyroidStimulatingHormone = item.thyroidStimulatingHormone;
        self.measuredTime = item.measuredTime;
        self.visitId = item.visitId;
        self.personId = item.personId;
        self.isUpdated = item.isUpdated;
        self.isDeleted = item.isDeleted;
    }
}
