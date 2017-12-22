//
// Created by Sandeep Rana on 18/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper


class UserPrefUtil: NSObject {

    static func getAccessToken() -> String {
        let usLog = UserDefaults.standard.value(forKey: Names.LOGIN_RESPONSE);
        if(usLog == nil){
            return "";
        }else{
            let logRes = Mapper<LoginResponse>().map(JSONString: usLog as! String)
            return (logRes?.access_token!)!;
        }
    }

    class func isTokenExpiring() -> Bool {
        if let logResp = getLoginResponse() {
            if (logResp.getExpireTime() < (Date().millisecondsSince1970 + 100)) {
                return true;
            }
        }
        return false;
    }

    static func getAccessToken(logResponse: LoginResponse) -> String {
//        let usLog = UserDefaults.standard.value(forKey: Names.LOGIN_RESPONSE);


        return (logResponse.access_token!);
    }

    static func getLoginResponse() -> LoginResponse? {
        if let usLog = UserDefaults.standard.value(forKey: Names.LOGIN_RESPONSE) {
            return Mapper<LoginResponse>().map(JSONString: usLog as! String)
        } else {
            return nil;
        }
    }

    class func getRefreshToken() -> String? {
        let usLog = UserDefaults.standard.value(forKey: Names.LOGIN_RESPONSE);
        let logRes = Mapper<LoginResponse>().map(JSONString: usLog as! String)

        return (logRes?.refresh_token!)!;
    }

    class func getScheduledTimeInSeconds() -> NSNumber? {
        return UserDefaults.standard.value(forKey: Names.TIMEINTERVAL_SYNC) as? NSNumber;
    }

    class func getPersonIdClinic() -> String? {
        if let clinicResp = UserDefaults.standard.value(forKey: Names.CLINIC_RESPONSE) {
            return Mapper<ClinicDetailResponse>().map(JSONString: clinicResp as! String)!.personInfo!.id;
        } else {
            return nil;
        }
    }

    class func getClinicResponse() -> ClinicDetailResponse? {
        if let clinicResp = UserDefaults.standard.value(forKey: Names.CLINIC_RESPONSE) {
            return Mapper<ClinicDetailResponse>().map(JSONString: clinicResp as! String)!;
        } else {
            return nil;
        }
    }

    class func setCreditAttribute(_ v: String?) {
        UserDefaults.standard.set(v, forKey: Names.CREDIT_ATTRIBUTE);
    }

    class func getCreditAttribute() -> CreditAttribute? {
        if let creditAttribObj = UserDefaults.standard.value(forKey: Names.CREDIT_ATTRIBUTE) {
            return Mapper<CreditAttribute>().map(JSONString: creditAttribObj as! String);
        } else {
            return nil;
        }
    }

    class func setSubscriptionType(_ v: BasicProfileAttributes) {
        UserDefaults.standard.set(v.toJSONString(), forKey: Names.SUBSCRIPTION_TYPE);
    }

    class func getSubscriptionType() -> BasicProfileAttributes? {
        if let subscriptionObject = UserDefaults.standard.value(forKey: Names.SUBSCRIPTION_TYPE) {
            return Mapper<BasicProfileAttributes>().map(JSONString: subscriptionObject as! String)!;
        } else {
            return nil;
        }
    }
}
