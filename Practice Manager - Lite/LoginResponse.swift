//
//  LoginResponse.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 03/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        access_token <- map["access_token"];
        refresh_token <- map["refresh_token"];
        speciality <- map["speciality"];
        role <- map["role"];
        servertime <- map["servertime"];
        userEmail <- map["userEmail"];
        userName <- map["userName"];
        expires_in <- map["expires_in"];
        error_description <- map["error_description"];
    }

    var error_description: String?;
    var access_token: String?;
    var refresh_token: String?;
    var speciality: String?;
    public var role: String?;
    var servertime: String?;
    var userEmail: String?;
    var userName: String?;
    var expires_in: Int64?;

    func getExpireTime() -> Int64 {
        return Int64(servertime!)! + expires_in!;
    }


}
