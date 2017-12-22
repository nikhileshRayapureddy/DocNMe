//
// Created by Sandeep Rana on 12/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class PersonPregnancyProfile: Object, Mappable {
    public required convenience init?(map: Map) {
        self.init();
    }
    

    
    
    public func mapping(map: Map) {
        id <- map["id"];
        gravida <- map["gravida"];
        preterm <- map["preterm"];
        abortion <- map["abortion"];
        living <- map["living"];
        lmp <- map["lmp"];
        eddscan <- map["eddscan"];
        weight <- map["weight"];
        isconsanguineous <- map["isconsanguineous"];
        hasautoimmune <- map["hasautoimmune"];
        riskfactor <- map["riskfactor"];
        extra <- map["extra"];
        personId <- map["personId"];
        creationdate <- map["creationdate"];
        status <- map["status"];
        statusmessage <- map["statusmessage"];
        completionmode <- map["completionmode"];
        completiondate <- map["completiondate"];
        gestationalage <- map["gestationalage"];
        isElectiveCsection <- map["isElectiveCsection"];
        preferredDatetime <- map["preferredDatetime"];
        electiveCsectionNote <- map["electiveCsectionNote"];
        protocolInt <- map["protocolInt"];
        createdBy <- map["createdBy"];
        updatedBy <- map["updatedBy"];
    }


    dynamic var id: String?;
    dynamic var gravida: Int = 0;
    dynamic var preterm: String?;
    dynamic var abortion: Int = 0;
    dynamic var living: Int = 0;
    dynamic var lmp: Int64 = 0;
    dynamic var eddscan: Int64 = 0;
    dynamic var weight: Int = 1;
    dynamic var isconsanguineous: Bool = false;
    dynamic var hasautoimmune: Bool = false;
    dynamic var riskfactor: String?;
    dynamic var extra: String?;
    dynamic var personId: String?;
    dynamic var creationdate: Int64 = 0;
    dynamic var status: Int = 0;
    dynamic var statusmessage: String?;
    dynamic var completionmode: Int = 0;
    dynamic var completiondate: Int64 = 0;
    dynamic var gestationalage: String?;
    dynamic var isElectiveCsection: String?;
    dynamic var preferredDatetime: String?;
    dynamic var electiveCsectionNote: String?;
    dynamic var protocolInt: Int = 0;
    dynamic var createdBy: String?;
    dynamic var updatedBy: String?;

}
