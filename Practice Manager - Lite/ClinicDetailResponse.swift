//
// Created by Sandeep Rana on 03/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

public class ClinicDetailResponse: Object, Mappable {
    public required convenience init?(map: Map) {
        self.init();
    }

    public func mapping(map: Map) {
        clinic <- map["clinic"];
        clinicLocation <- map["clinicLocation"];
        personInfo <- map["personInfo"];
    }

    dynamic var clinic: Clinic?;
    dynamic var clinicLocation: ClinicLocationModel?;
    dynamic var personInfo: PersonInfoModel?;


}
