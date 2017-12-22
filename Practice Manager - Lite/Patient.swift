//
// Created by Sandeep Rana on 19/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class Patient: Object, Mappable {




    required convenience init?(map: Map) {
        self.init();
    }


    func mapping(map: Map) {
        personInfo <- map["personInfo"];
        personPregnancyInfo <- map["personPregnancyInfo"];
        refererId <- map["refererId"];
        refererName <- map["refererName"];
        clinicPersonId <- map["clinicPersonId"];
        clinicId <- map["clinicId"];
        if (personPregnancyInfo != nil && personPregnancyInfo?.id != nil) {
            personId = (personPregnancyInfo?.id!)!;
        }
    }

    var personInfo: PersonInfoModel?;
    var personPregnancyInfo: PregnancyInfo?;

    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;
    dynamic var id = -1;
    dynamic var personId = "";
    dynamic var refererId: String?;
    dynamic var refererName: String?;
    dynamic var clinicPersonId: String?;
    dynamic var clinicId: String?;


    func copyFromObject(_ item: Patient) -> Patient {

        if item.personPregnancyInfo != nil {
            self.personPregnancyInfo = item.personPregnancyInfo;
        }

        self.personId = item.personId;

        if item.refererName != nil {
            self.refererName = item.refererName;
        }

        self.clinicId = item.clinicId;

        self.isDeleted = item.isDeleted;

        self.clinicPersonId = item.clinicPersonId;

        if item.id != nil {
            self.id = item.id;
        }

        self.isUpdated = item.isUpdated;

        if item.refererId != nil {
            self.refererId = item.refererId;
        }

        if item.personInfo != nil {
            self.personInfo = item.personInfo;
        }
        return self;
    }
    
    func toJSONForBatchRequest() -> [String: Any]? {
        var map = self.toJSON();
        map["id"] = nil;
        map["isUpdated"] = nil;
        map["isDeleted"] = nil;
        map["personId"] = nil;
        return map;
    }
}
