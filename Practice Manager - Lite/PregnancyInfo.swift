import Foundation
import RealmSwift
import ObjectMapper

class PregnancyInfo: Object, Mappable {
    dynamic var id: String?;
//    dynamic var personId: String?;
    dynamic var name: String?;
    dynamic var email: String?;
    dynamic var icon: String?;
    dynamic var gender: Int = -1;
    dynamic var mstatus: Int = -1;
    dynamic var dob: String?;
    dynamic var bloodgroup: String?;
    dynamic var donor: Int = -1;
    dynamic var vip: Int = -1;
    dynamic var address: String?;
    dynamic var city: String?;
    dynamic var state: String?;
    dynamic var country: String?;
    dynamic var pincode: String?;
    dynamic var phonenumber: String?;
    dynamic var changepassword: Int = -1;
    dynamic var pregnant: NSInteger = -1;
    dynamic var highrisk: Int = -1;
    dynamic var edd: Int64 = 0;
    dynamic var isUpdated: Bool = false;

    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        id <- map["id"];
//        personId <- map["personId"];
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
        city <- map["city"];
        state <- map["state"];
        country <- map["country"];
        pincode <- map["pincode"];
        phonenumber <- map["phonenumber"];
        changepassword <- map["changepassword"];
        pregnant <- map["pregnant"];
        highrisk <- map["highrisk"];
        edd <- map["edd"];
    }

    func copyFromObject(_ info: PregnancyInfo) {
        self.id = info.id;
        self.name = info.name;
        self.email = info.email;
        self.icon = info.icon;
        self.gender = info.gender;
        self.mstatus = info.mstatus;
        self.dob = info.dob;
        self.bloodgroup = info.bloodgroup;
        self.donor = info.donor;
        self.vip = info.vip;
        self.address = info.address;
        self.city = info.city;
        self.state = info.state;
        self.country = info.country;
        self.pincode = info.pincode;
        self.phonenumber = info.phonenumber;
        self.changepassword = info.changepassword;
        self.pregnant = info.pregnant;
        self.highrisk = info.highrisk;
        self.edd = info.edd;
        self.isUpdated = info.isUpdated;
    }

    func toJSONForBatchRequest() -> [String: Any]? {
        var map = self.toJSON();
        map["id"] = nil;
        map["isUpdated"] = nil;
        map["isDeleted"] = nil;
        return map;
    }

    func setFields(_ info: PersonInfoModel) {
        if info.id != nil {
            self.id = info.id
        };
        if info.name != nil {
            self.name = info.name
        };
        if info.email != nil {
            self.email = info.email
        };
        if info.icon != nil {
            self.icon = info.icon
        };
        if info.gender != nil {
            self.gender = info.gender
        };
        if info.mstatus != nil {
            self.mstatus = info.mstatus
        };
        if info.dob != nil {
            self.dob = info.dob.description
        };
        if info.bloodgroup != nil {
            self.bloodgroup = info.bloodgroup
        };
        if info.donor != nil {
            self.donor = info.donor
        };
        if info.vip != nil {
            self.vip = info.vip
        };
        if info.address != nil {
            self.address = info.address
        };
        if info.city != nil {
            self.city = info.city
        };
        if info.state != nil {
            self.state = info.state
        };
        if info.country != nil {
            self.country = info.country
        };
        if info.pincode != nil {
            self.pincode = info.pincode
        };
        if info.phonenumber != nil {
            self.phonenumber = info.phonenumber
        };
        if info.changepassword != nil {
            self.changepassword = info.changepassword
        };
//        if info.pregnant != nil {
//            self.pregnant = info.pregnant
//        };
//        if info.highrisk != nil {
//            self.highrisk = info.highrisk
//        };
//        if info.edd != nil {
//            self.edd = info.edd
//        };
        if info.isUpdated != nil {
            self.isUpdated = info.isUpdated
        };
    }
}
