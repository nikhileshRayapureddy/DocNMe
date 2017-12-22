//
// Created by Sandeep Rana on 08/11/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import Alamofire

public class AlamofireManager {
    public static var Manager: Alamofire.SessionManager = {

        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "api.docnme.com": .disableEvaluation
        ]

        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.httpShouldUsePipelining = true;
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData;

//        configuration.timeoutIntervalForRequest = 10;
//        configuration.timeoutIntervalForResource = 10;
        let manager = Alamofire.SessionManager(
                configuration: URLSessionConfiguration.default,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )

        return manager
    }()
}
