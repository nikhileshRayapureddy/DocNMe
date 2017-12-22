//
// Created by Sandeep Rana on 15/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper

class ResponseBasicAttributesSync: Mappable {
    var personAttributes: [BasicProfileAttributes]?;

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        personAttributes <- map[Names.PERSON_ATTRIBUTES];
    }
}
