//
// Created by Sandeep Rana on 10/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import Toaster

class Internet {
    class func isAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    class func toastInfoInternet() {
        if isAvailable() {

        } else {
            Toast(text: "Internet not available!").show();
        }
    }
}

