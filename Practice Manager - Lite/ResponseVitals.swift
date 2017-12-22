//
// Created by Sandeep Rana on 29/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseVitals: Mappable {
    required init?(map: Map) {

    }

    init() {
    }

    func toJSON() -> [String: Any] {
        var json = Mapper().toJSON(self);
        json["bloodGlucose"] = json["bloodglucose"];
        json.removeValue(forKey: "bloodglucose");
        return json;
    }

    func mapping(map: Map) {
        bloodglucose <- map["bloodglucose"];
        bloodPressure <- map["bloodPressure"];
        height <- map["height"];
        weight <- map["weight"];
        oxygenstaturation <- map["oxygenstaturation"];
        respirationrate <- map["respirationrate"];
        pulserate <- map["pulserate"];
        temperature <- map["temperature"];
        hemoglobin <- map["hemoglobin"];
        thyroidStimulatingHormone <- map["thyroidStimulatingHormone"];
        antiMullerianHormone <- map["antiMullerianHormone"];
        lastMenstrualPeriod <- map["lastMenstrualPeriod"];
        if (bloodglucose == nil) {
            bloodglucose <- map["bloodGlucose"];
        }
    }

    var bloodglucose: Bloodglucose?;
    var bloodPressure: BloodPressure?;
    var height: Height?;
    var weight: Weight?;
    var oxygenstaturation: Oxygenstaturation?;
    var respirationrate: Respirationrate?;
    var pulserate: Pulserate?;
    var temperature: Temperature?;
    var hemoglobin: Hemoglobin?;
    var thyroidStimulatingHormone: ThyroidStimulatingHormone?;
    var antiMullerianHormone: AntiMullerianHormone?;
    var lastMenstrualPeriod: LastMenstrualPeriod?;


}
