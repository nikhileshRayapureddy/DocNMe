//
// Created by Sandeep Rana on 18/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiServices {

    static func decideAndRefreshToken() {

        if (!UserPrefUtil.isTokenExpiring()) {
            return;
        }


        let url = URL(string: DAMUrls.getRefreshTokenUrl())!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(
                "Basic MTA0ZWI2MDMtZjE0YS00NGExLWIyNjctZWM3MzIwOWEyNT" +
                        "A2OmUwZTk2ZWYwLTFhZGUtM2JiZS04NWMzLTBkNTdlNGViOWYwZg==",
                forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringCacheData;
        var params = [String: String]();
        params[Names.REFRESH_TOKEN] = UserPrefUtil.getRefreshToken();
        params[Names.GRANT_TYPE] = Names.REFRESH_TOKEN;

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: []);
        } catch {
            print("Error parsing paramaters in Api Services")
        }

        AlamofireManager.Manager.request(urlRequest).responseObject() {
            (response: DataResponse<LoginResponse>) in
            if (response.result.isSuccess && response.response?.statusCode == 200) {
                UserDefaults.standard.setValue(response.result.value?.toJSONString()!, forKey: Names.LOGIN_RESPONSE);
                UserDefaults.standard.synchronize();
            } else {
                if (response.response?.statusCode == 400) {
                    print("Login authorization Error");
                } else {
                    print("login error");
                }
            }
        }

    }

    static func createPostRequest(urlStr: String, parameters: Any) -> URLRequest {
        decideAndRefreshToken();
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + UserPrefUtil.getAccessToken(), forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringCacheData;
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
        } catch {
            print("Error in parameters");
        }
        return urlRequest;
    }
    
    static func createPlainPostRequest(urlStr: String, parameters: Any) -> URLRequest {
        decideAndRefreshToken();
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("Basic 572a57e0-682e-30b7-856d-00692735c1c6", forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringCacheData;
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
        } catch {
            print("Error in parameters");
        }
        return urlRequest;
    }
    static func createPlainForOTPPostRequest(urlStr: String, parameters: Any) -> URLRequest {
        decideAndRefreshToken();
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("Bearer 572a57e0-682e-30b7-856d-00692735c1c6", forHTTPHeaderField: "Authorization")
//        urlRequest.cachePolicy = .useProtocolCachePolicy;

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])

        } catch {
            print("Error in parameters");
        }
        return urlRequest;
    }

    static func createGetRequest(urlStr: String, parameters: Any) -> URLRequest {
        decideAndRefreshToken();
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + UserPrefUtil.getAccessToken(), forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData;

//        do {
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            // No-op
//        }
        return urlRequest;
    }

    class func createGetRequest(logResponse: LoginResponse, urlStr: String, parameters: Any) -> URLRequest {
        let url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(
                "Bearer " + UserPrefUtil.getAccessToken(logResponse: logResponse),
                forHTTPHeaderField: "Authorization")
        urlRequest.cachePolicy = .reloadIgnoringCacheData;

//        do {
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            // No-op
//        }
        return urlRequest;
    }
    
    class func createUploadImageRequest(urlString: String, andParameter parameters: Any) -> URLRequest
    {
        decideAndRefreshToken();
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(
            "Bearer " + UserPrefUtil.getAccessToken(),
            forHTTPHeaderField: "Authorization")

        urlRequest.cachePolicy = .reloadIgnoringCacheData;
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
        } catch {
            print("Error in parameters");
        }
        return urlRequest;
    }
}
