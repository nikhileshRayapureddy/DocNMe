//
// Created by Sandeep Rana on 21/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Question: Object, Mappable {
    dynamic var id: String?;
    dynamic var title: String?;
    dynamic var content: String?;
    dynamic var patientPersonId: String?;
    dynamic var doctorPersonId: String?;
    dynamic var createdDate: Int64 = 0;
    dynamic var fileDetailId: String?;
    dynamic var imageId: String?;
    dynamic var status: String?;
    dynamic var paymentRequestId: String?;
    dynamic var paymentStatus: String?;
    dynamic var category: String?;
    dynamic var expirationTime: Int64 = 0;
    dynamic var clinicId: String?;
    dynamic var isDeleted:Bool = false;
    dynamic var isUpdated:Bool = false;

    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        title <- map["title"];
        content <- map["content"];
        patientPersonId <- map["patientPersonId"];
        doctorPersonId <- map["doctorPersonId"];
        createdDate <- map["createdDate"];
        fileDetailId <- map["fileDetailId"];
        imageId <- map["imageId"];
        status <- map["status"];
        paymentRequestId <- map["paymentRequestId"];
        paymentStatus <- map["paymentStatus"];
        category <- map["category"];
        expirationTime <- map["expirationTime"];
        clinicId <- map["clinicId"];
    }
}
