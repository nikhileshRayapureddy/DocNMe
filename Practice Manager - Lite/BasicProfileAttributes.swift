//
// Created by Sandeep Rana on 04/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class BasicProfileAttributes: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        value <- map["value"];
        personId <- map["personId"];
    }


    dynamic var id: Int = 0;
    dynamic var name: String?;
    dynamic var value: String?;
    dynamic var personId: String?;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;

    func setFields(
            name: String?,
            value: String?,
            personId: String?
    ) -> [String: Any] {
        self.name = name;
        self.value = value;
        self.personId = personId;
        self.isUpdated = true;
        return self.toJSON();
    }

    func setFieldsAndGetSelf(
            name: String?,
            value: String?,
            personId: String?
    ) -> BasicProfileAttributes {
        self.name = name;
        self.value = value;
        self.personId = personId;
        self.isUpdated = true;
        return self;
    }


    func setFields(attribute: BasicProfileAttributes) {
        self.id = attribute.id;
        self.name = attribute.name;
        self.value = attribute.value;
        self.personId = attribute.personId;
        self.isUpdated = attribute.isUpdated;
        self.isDeleted = attribute.isDeleted;
    }

    func setRefinedFields(attribute: BasicProfileAttributes) {
        self.id = attribute.id;
        self.name = attribute.name;
        self.value = attribute.value;
        self.personId = attribute.personId;
    }

    public func toPureSelf() -> BasicProfileAttributes {
        let json = BasicProfileAttributes();
        json.setRefinedFields(attribute: self);
        return json;
    }


}
