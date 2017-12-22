//
//  LoginViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 02/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire;

import RealmSwift

import AlamofireObjectMapper

class LoginViewController: UIViewController {
    @IBOutlet weak var t_username: UITextField!
    @IBOutlet weak var t_password: UITextField!
    @IBOutlet weak var b_Login: UIButton!

    @IBAction func b_login(_ sender: Any) {
        print("Called BLogin");
        if validated() {
            print("Successfully Validated!");
//            Utility.buttonVisibilityAndShow(sender as! UIButton, title: "Loading...", isEnabled: false);
            app_delegate.showLoader(message: "Authenticating...")
            self.callLoginUserAndProceed(username: t_username.text!, password: t_password.text!);
        } else {
            print("NotValide");
            return;
        }
    }

    @IBAction func onClickSignUP(_ sender: Any) {
        print("Called Sign UP");
        let vc = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VC_SIGNUPSHORT)
        self.present(vc, animated: true);
    }


// MARK: - Logging in is here
    public func callLoginUserAndProceed(username: String, password: String) {

        let url = URL(string: DAMUrls.loginAndGetAuthTokenUrl())!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let parameters = [Names.GRANT_TYPE: Names.PASSWORD,
                          Names.USERNAME: username,
                          Names.PASSWORD: password];

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Basic MTA0ZWI2MDMtZjE0YS00NGExLWIyNjctZWM3MzIwOWEyNTA2OmUwZTk2ZWYwLTFhZGUtM2JiZS04NWMzLTBkNTdlNGViOWYwZg==", forHTTPHeaderField: "Authorization")


        AlamofireManager.Manager.request(urlRequest).responseObject {
            (response: DataResponse<LoginResponse>) in
            DispatchQueue.main.async {
                if (response.result.isSuccess && response.response?.statusCode == 200) {
                    app_delegate.removeloder()
                    self.getClinicDetails(logResponse: response.result.value);
                } else {
                    app_delegate.removeloder()
                    if (response.response?.statusCode == 400) {
                        self.showCustomAlert(title: "Login Failed!", message: "Plese check your username and password");
                    } else {
                        self.showCustomAlert(title: "Error!", message: (response.error?.localizedDescription)!);
                    }
                }
            }
        }

    }


// MARK: - Clinic details
    private func getClinicDetails(logResponse: LoginResponse?) {
        if (logResponse != nil) {
            let url = DAMUrls.urlClinicDetails();
            let request = ApiServices.createGetRequest(logResponse: logResponse!, urlStr: url, parameters: []);
            Alamofire.request(request).responseObject { (response: DataResponse<ClinicDetailResponse>) in
                var urlRequest = URLRequest(url: URL(string: url)!)
                urlRequest.httpMethod = "GET"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue(
                    "Bearer " + UserPrefUtil.getAccessToken(logResponse: logResponse!),
                    forHTTPHeaderField: "Authorization")
                Alamofire.request(urlRequest).responseObject {                (response: DataResponse<ClinicDetailResponse>) in
                    DispatchQueue.main.async {
                        app_delegate.removeloder()
                        if response.response?.statusCode == 200 {
                            //                    Saving login details
                            UserDefaults.standard.setValue(logResponse?.toJSONString()!, forKey: Names.LOGIN_RESPONSE);
                            UserDefaults.standard.synchronize();
                            print("Access Token is : " + UserPrefUtil.getAccessToken() + (logResponse?.userEmail!)!);
                            //                  Saving clinic details
                            
                            let clin: ClinicDetailResponse = response.result.value!;
                            UserDefaults.standard.setValue(response.result.value?.toJSONString(), forKey: Names.CLINIC_RESPONSE);
                            
                            if (Utility.needToOpenFill(clin)) {
                                let alert = UIAlertController(title: "Your profile is Incomplete. Do you want to fill it now?"
                                    , message: nil, preferredStyle: UIAlertControllerStyle.alert)
                                
                                // add the actions (buttons)
                                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                                    action in
                                    DispatchQueue.main.async {
                                        let vc: VCSignUP = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_SIGNUP) as! VCSignUP;
                                        self.present(vc, animated: true, completion: nil);

                                    }
                                }))
                                
                                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {
                                    action in
                                    DispatchQueue.main.async {
                                        self.openHomeNavigationControllViewer(logResponse: logResponse);

                                    }
                                }))
                                
                                
                                // show the alert
                                self.present(alert, animated: true, completion: nil)

                            }
                            self.openHomeNavigationControllViewer(logResponse: logResponse);
                        }
                        else
                        {
                            app_delegate.removeloder()
                            self.showCustomAlert(title: "Error!", message: (response.error?.localizedDescription)!);
                        }
                    }
                }
            }
        }
    }

    func openHomeNavigationControllViewer(logResponse: LoginResponse?) {
        print("Open next controller");
        performSegue(withIdentifier: Names.VContIdentifiers.AFTER_LOGIN, sender: self);
    }


    func validated() -> Bool {
        var valid: Bool = true
        if ((t_username.text?.isEmpty))! {
            // change placeholder color to red color for textfield email-id
            t_username.attributedPlaceholder = NSAttributedString(string: "Please enter username", attributes: [NSForegroundColorAttributeName: UIColor.red]);
            valid = false
        }
        if ((t_password.text?.isEmpty))! {
            // change placeholder color to red for textfield username
            t_password.attributedPlaceholder = NSAttributedString(string: "Please enter password", attributes: [NSForegroundColorAttributeName: UIColor.red]);
            valid = false
        }

        return valid
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View Controller");
        ApiServices.decideAndRefreshToken();
        let realm = try? Realm();
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print(realm?.configuration.fileURL?.description);
        Internet.toastInfoInternet();
    }

    override func viewDidAppear(_ animated: Bool) {
        if let logResponse = UserPrefUtil.getLoginResponse() {
            self.openHomeNavigationControllViewer(logResponse: logResponse);
//            checkIfTokenIsValid()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

}
