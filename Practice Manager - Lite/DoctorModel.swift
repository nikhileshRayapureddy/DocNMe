//
//  DoctorModel.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 21/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class DoctorModel: Object, Mappable {
    dynamic var id: String!;
    dynamic var name: String!;
    dynamic var email: String!;
    dynamic var gender: Int = 0;
    dynamic var country: String!;
    dynamic var phonenumber: String!;
    dynamic var changepassword: Int = 0;
    dynamic var role: String!;

    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
        name <- map["name"];
        email <- map["email"];
        gender <- map["gender"];
        country <- map["country"];
        phonenumber <- map["phonenumber"];
        changepassword <- map["changepassword"];
        role <- map["role"];
    }

//    static func initWithJSON(data: [String: Any]) -> DoctorModel {
//        let doctor = DoctorModel();
//        doctor.id = (data[Names.ID] as? String)!;
//        doctor.name = (data[Names.NAME] as? String)!;
//        doctor.email = (data[Names.EMAIL] as? String)!;
//        doctor.gender = (data[Names.GENDER] as? Int)!;
//        doctor.country = (data[Names.COUNTRY] as? String)!;
//        doctor.phonenumber = (data[Names.PHONENUMBER] as? String)!;
//        doctor.changepassword = (data[Names.CHANGEPASSWORD] as? Int)!;
//        doctor.role = (data[Names.ROLE] as? String)!;
//        return doctor;
//    }

    func setFields(_ item: DoctorModel) {
        self.id = item.id;
        self.name = item.name;
        self.email = item.email;
        self.gender = item.gender;
        self.country = item.country;
        self.phonenumber = item.phonenumber;
        self.changepassword = item.changepassword;
        self.role = item.role;
    }
}
