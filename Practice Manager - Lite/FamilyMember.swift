//
// Created by Sandeep Rana on 31/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class FamilyMember: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        id <- map["id"];
        personId <- map["personId"];
        relation <- map["relation"];
        dob <- map["dob"];
        age <- map["age"];
        isalive <- map["isalive"];
        conditions <- map["conditions"];
        causeofdeath <- map["causeofdeath"];
    }

    dynamic var id: String?;
    dynamic var personId: String?;
    dynamic var relation: String?;
    dynamic var dob: String?;
    dynamic var age: String?;
    dynamic var isalive: String?;

    func setRefinedFields(obj: FamilyMember) {
        self.id = obj.id;
        self.personId = obj.personId;
        self.relation = obj.relation;
        self.dob = obj.dob;
        self.age = obj.age;
        self.isalive = obj.isalive;
        self.conditions = obj.conditions;
        self.causeofdeath = obj.causeofdeath;
    }

    dynamic var conditions: String?;
    dynamic var causeofdeath: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;


}
