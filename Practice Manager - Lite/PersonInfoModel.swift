//
// Created by Sandeep Rana on 22/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper
import RealmSwift

public class PersonInfoModel: Object, Mappable {


    public required convenience init?(map: Map) {
        self.init();
    }

    public func mapping(map: Map) {

        id <- map["id"];
        prefixStr <- map["prefix"];
        name <- map["name"];
        email <- map["email"];
        icon <- map["icon"];
        gender <- map["gender"];
        mstatus <- map["mstatus"];
        dob <- map["dob"];
        bloodgroup <- map["bloodgroup"];
        donor <- map["donor"];
        vip <- map["vip"];
        address <- map["address"];
        address2 <- map["address2"];
        city <- map["city"];
        state <- map["state"];
        country <- map["country"];
        pincode <- map["pincode"];
        latitude <- map["latitude"];
        longitude <- map["longitude"];
        phonenumber <- map["phonenumber"];
        landline <- map["landline"];
        changepassword <- map["changepassword"];
        role <- map["role"];

    }

    func setFields(from: Patient) {
        self.id = from.personPregnancyInfo?.id;
//        self.prefixStr = from.personPregnancyInfo.prefixStr;
        self.name = from.personPregnancyInfo?.name;
        self.email = from.personPregnancyInfo?.email;
        self.icon = from.personPregnancyInfo?.icon;
        if from.personPregnancyInfo?.gender != nil {
            self.gender = (from.personPregnancyInfo?.gender)!;
        }
        self.mstatus = (from.personPregnancyInfo?.mstatus)!;

//        self.dob = from.personPregnancyInfo!.dob;
        self.bloodgroup = from.personPregnancyInfo?.bloodgroup;
//        self.donor = from.personPregnancyInfo!.donor;
        self.vip = from.personPregnancyInfo!.vip;
        self.address = from.personPregnancyInfo?.address;
        self.address2 = from.personPregnancyInfo?.address;
        self.city = from.personPregnancyInfo?.city;
        self.state = from.personPregnancyInfo?.state;
        self.country = from.personPregnancyInfo?.country;
        self.pincode = from.personPregnancyInfo?.pincode;
//        self.latitude = from.personPregnancyInfo.latitude;
//        self.longitude = from.personPregnancyInfo.longitude;
        self.phonenumber = from.personPregnancyInfo?.phonenumber;
//        self.landline = from.personPregnancyInfo.landline;
        self.changepassword = (from.personPregnancyInfo?.changepassword)!;
//        self.role = from.personPregnancyInfo.role;

    }

    dynamic var id: String!;
    dynamic var prefixStr: String!;
    dynamic var name: String!;
    dynamic var email: String!;
    dynamic var icon: String!;
    dynamic var gender: Int = 0;
    dynamic var mstatus: Int = 0;
    dynamic var dob: Int64 = 0;
    dynamic var bloodgroup: String!;
    dynamic var donor: Int = 0;
    dynamic var vip: Int = 0;
    dynamic var address: String!;
    dynamic var address2: String!;
    dynamic var city: String!;
    dynamic var state: String!;
    dynamic var country: String!;
    dynamic var pincode: String!;
    dynamic var latitude: String!;
    dynamic var longitude: String!;
    dynamic var phonenumber: String!;
    dynamic var landline: String!;
    dynamic var changepassword: Int = 0;
    dynamic var role: String!;
    dynamic var isUpdated: Bool = false;
    dynamic var isDeleted: Bool = false;


    func setFields(_ res: PersonInfoModel) {

        self.id = res.id;
        self.prefixStr = res.prefixStr;
        self.name = res.name;
        self.email = res.email;
        self.icon = res.icon;
        self.gender = res.gender;
        self.mstatus = res.mstatus;
        self.dob = res.dob;
        self.bloodgroup = res.bloodgroup;
        self.donor = res.donor;
        self.vip = res.vip;
        self.address = res.address;
        self.address2 = res.address2;
        self.city = res.city;
        self.state = res.state;
        self.country = res.country;
        self.pincode = res.pincode;
        self.latitude = res.latitude;
        self.longitude = res.longitude;
        self.phonenumber = res.phonenumber;
        self.landline = res.landline;
        self.changepassword = res.changepassword;
        self.role = res.role;
        self.isUpdated = res.isUpdated;
        self.isDeleted = res.isDeleted;


    }


    func copyFromPregnancy(_ res: PregnancyInfo) {
        if res.id != nil {
            self.id = res.id;
        }
//        if res.prefixStr != nil {
//            self.prefixStr = res.prefixStr;
//        }
        if res.name != nil {
            self.name = res.name;
        }
        if res.email != nil {
            self.email = res.email;
        }
        if res.icon != nil {
            self.icon = res.icon;
        }
        self.gender = res.gender;
        self.mstatus = res.mstatus;

//        if res.dob != nil {
//            self.dob = res.dob;
//        }
        if res.bloodgroup != nil {
            self.bloodgroup = res.bloodgroup;
        }
        self.donor = res.donor;
        self.vip = res.vip;
        if res.address != nil {
            self.address = res.address;
        }
//        if res.address2 != nil {
//            self.address2 = res.address2;
//        }
        if res.city != nil {
            self.city = res.city;
        }
        if res.state != nil {
            self.state = res.state;
        }
        if res.country != nil {
            self.country = res.country;
        }
        if res.pincode != nil {
            self.pincode = res.pincode;
        }
//        if res.latitude != nil {
//            self.latitude = res.latitude;
//        }
//        if res.longitude != nil {
//            self.longitude = res.longitude;
//        }
        if res.phonenumber != nil {
            self.phonenumber = res.phonenumber;
        }
//        if res.landline != nil {
//            self.landline = res.landline;
//        }
//        if res.changepassword != nil {
        self.changepassword = res.changepassword;
//        }
//        if res.role != nil {
//            self.role = res.role;
//        }
//        if res.isUpdated != nil {
        self.isUpdated = res.isUpdated;
//        }
//        if res.isDeleted != nil {
//            self.isDeleted = res.isDeleted;
//        }
    }

    func toJSONForBatchRequest() -> [String: Any]? {
        var map = self.toJSON();
        map["id"] = nil;
        map["isUpdated"] = nil;
        map["isDeleted"] = nil;
        return map;
    }

    class func fromDocInfo(_ info: DoctorModel?) -> PersonInfoModel? {

        if info != nil {
            let pers = PersonInfoModel();
            pers.id = info?.id;
//            pers.prefixStr = info?.prefixStr;
            pers.name = info?.name;
            pers.email = info?.email;
//            pers.icon = info?.icon;
            pers.gender = (info?.gender)!;
//            pers.mstatus = info?.mstatus;
//            pers.dob = info?.dob;
//            pers.bloodgroup = info?.bloodgroup;
//            pers.donor = info?.donor;
//            pers.vip = info?.vip;
//            pers.address = info?.address;
//            pers.address2 = info?.address2;
//            pers.city = info?.city;
//            pers.state = info?.state;
            pers.country = info?.country;
//            pers.pincode = info?.pincode;
//            pers.latitude = info?.latitude;
//            pers.longitude = info?.longitude;
            pers.phonenumber = info?.phonenumber;
//            pers.landline = info?.landline;
            pers.changepassword = (info?.changepassword)!;
            pers.role = info?.role;
//            pers.isUpdated = info?.isUpdated;
//            pers.isDeleted = info?.isDeleted;
            return pers;
        } else {
            return nil;
        }
    }
}
















