//
// Created by Sandeep Rana on 09/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper

class CouponResponse: Mappable {
    var description: String = "";
    var voucherType: String = "";
    var discountType: String = "";
    var voucherValue: String = "";
    var unitType: String = "";

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        description <- map["description"];
        voucherType <- map["voucherType"];
        discountType <- map["discountType"];
        voucherValue <- map["voucherValue"];
        unitType <- map["unitType"];
    }
}
