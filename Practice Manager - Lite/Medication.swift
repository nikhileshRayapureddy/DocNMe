//
// Created by Sandeep Rana on 31/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Medication: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {

        id <- map["id"];
        personId <- map["personId"];
        name <- map["name"];
        strength <- map["strength"];
        dosage <- map["dosage"];
        duration <- map["duration"];
        schedule <- map["schedule"];
        notes <- map["notes"];
        createdBy <- map["createdBy"];
        createdDate <- map["createdDate"];
    }

    dynamic var id: String?;
    dynamic var personId: String?;
    dynamic var name: String?;
    dynamic var strength: String?;

    func setRefinedFields(obj: Medication) {
        self.dosage = obj.dosage;
        self.createdBy = obj.createdBy;
        self.personId = obj.personId;
        self.strength = obj.strength;
        self.duration = obj.duration;
        self.id = obj.id;
        self.schedule = obj.schedule;
        self.notes = obj.notes;
        self.name = obj.name;
        self.createdDate = obj.createdDate;
    }

    dynamic var dosage: String?;
    dynamic var duration: String?;
    dynamic var schedule: String?;
    dynamic var notes: String?;
    dynamic var createdBy: String?;
    dynamic var createdDate: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    
}
