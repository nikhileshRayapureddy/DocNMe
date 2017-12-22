//
// Created by Sandeep Rana on 26/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Result: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        self.id <- map["id"];
        self.order <- map["order"];
        self.name <- map["name"];
        self.results <- map["results"];
        self.filedetailId <- map["filedetailId"];
        self.testDate <- map["testDate"];
    }

    var id: String?;
    var order: String?;
    var name: String?;
    var results: String?;
    var filedetailId: String?;
    var testDate: Int64 = 0;
}
