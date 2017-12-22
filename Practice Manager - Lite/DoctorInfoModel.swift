//
// Created by Sandeep Rana on 22/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class DoctorInfoModel {
    var id: String!;
    var prefixl: String!;
    var name: String!;
    var email: String!;
    var icon: String!;
    var gender: Int = 0;
    var mstatus: Int = 0;
    var dob: Int64!;
    var bloodgroup: String!;
    var donor: Int = 0;
    var vip: Int = 0;
    var address: String!;
    var address2: String!;
    var city: String!;
    var state: String!;
    var country: String!;
    var pincode: String!;
    var latitude: String!;
    var longitude: String!;
    var phonenumber: String!;
    var landline: String!;
    var changepassword: Int = 0;
    var role: String!;

    public func mapping(map: Map) {
        id <- map[Names.ID];
        prefixl <- map[Names.PREFIX];
        name <- map[Names.NAME];
        email <- map[Names.EMAIL];
        icon <- map[Names.ICON];
        gender <- map[Names.GENDER];
        mstatus <- map[Names.MSTATUS];
        dob <- map[Names.DOB];
        bloodgroup <- map[Names.BLOODGROUP];
        donor <- map[Names.DONOR];
        vip <- map[Names.VIP];
        address <- map[Names.ADDRESS];
        address2 <- map[Names.ADDRESS2];
        city <- map[Names.CITY];
        state <- map[Names.STATE];
        country <- map[Names.COUNTRY];
        pincode <- map[Names.PINCODE];
        latitude <- map[Names.LATITUDE];
        longitude <- map[Names.LONGITUDE];
        phonenumber <- map[Names.PHONENUMBER];
        landline <- map[Names.LANDLINE];
        changepassword <- map[Names.CHANGEPASSWORD];
        role <- map[Names.ROLE];

    }

}
