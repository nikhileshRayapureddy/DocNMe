//
// Created by Sandeep Rana on 22/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class QuestionComment: Object, Mappable {
    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        questionId <- map["questionId"];
        comment <- map["comment"];
        commentby <- map["commentby"];
        commentdate <- map["commentdate"];
        fileDetailId <- map["fileDetailId"];
        imageId <- map["imageId"];
        content <- map["content"];
        expirationTime <- map["expirationTime"];
    }

    dynamic var id: Int64 = 0;
    dynamic var questionId: String?;
    dynamic var comment: String?;
    dynamic var commentby: String?;
    dynamic var commentdate: Int64 = 0;
    dynamic var fileDetailId: String?;
    dynamic var imageId: String?;
    dynamic var content: String?;
    dynamic var expirationTime: Int64 = 0;

}
