//
// Created by Sandeep Rana on 14/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Toaster

class VCSignupShort: UIViewController {
    @IBOutlet weak var eName: UITextField!;
    @IBOutlet weak var eEmail: UITextField!;
    @IBOutlet weak var ePhone: UITextField!;
    @IBOutlet weak var eCountryCode: UITextField!;

    @IBAction func onClickCancelButton(_sender: UIButton) {
        self.dismiss(animated: true);
    }

    @IBAction func onClickSignup(_ sender: UIButton) {
        let strName = eName.text;
        let strEmail = eEmail.text;
        let strPhone = ePhone.text;
        var strPhonePrefix = self.eCountryCode.text;

        if strPhonePrefix == "" {
            strPhonePrefix = "+91";
        }

        if (strName?.isEmpty)! || (strEmail?.isEmpty)! || (strPhone?.isEmpty)! {
            var error: String = "";
            if (strName?.isEmpty)! {
                error = "\(error.description) Name,";
            }
            if (strEmail?.isEmpty)! {
                error = "\(error.description) Email,";
            }

            if (strPhone?.isEmpty)! {
                error = "\(error.description) Phone,";
            }

            Toast(text: "\(error)").show();
            return;
        }

        //Mark  Generating OTP
        Utility.buttonVisibilityAndShow(sender, title: "loading...", isEnabled: false);
        var params = [String: String]();
        params[Names.NAME] = strName;
        params[Names.PHONE] = "\(strPhonePrefix!)\(strPhone!)";

        let url = DAMUrls.urlGenerateOTPForSignUP();

        let request = ApiServices.createPlainForOTPPostRequest(urlStr: url, parameters: params);
        sender.isEnabled = false;
        AlamofireManager.Manager.request(request).responseJSON {
            (response: DataResponse<Any>) in
            Utility.buttonVisibilityAndShow(sender, title: "Sign Up", isEnabled: true);
            if response.response?.statusCode == 200 {
                Toast(text: "OTP has been sent to the registered mobile number").show();

                var textFieldUpper: UITextField?;
                let alert = UIAlertController(title: "Verify OTP", message: "OTP has been sent to the registered mobile number", preferredStyle: UIAlertControllerStyle.alert)

                alert.addAction(UIAlertAction(title: "Verify", style: UIAlertActionStyle.default, handler: {
                    senderInside in
                    senderInside.isEnabled = false;

                    let urlVerifyOtp = DAMUrls.urlVerifyOTP();
                    var paramsDown = [String: String]();
                    paramsDown[Names.OTP] = textFieldUpper?.text;
                    paramsDown[Names.PHONE] = "\(strPhonePrefix!)\(strPhone!)";


                    let request = ApiServices.createPlainForOTPPostRequest(urlStr: urlVerifyOtp, parameters: paramsDown);

                    AlamofireManager.Manager.request(request).responseString {
                        response in
                        if (response.response?.statusCode == 200) {
//                            Utility.buttonVisibilityAndShow(sender, title: "Sign Up", isEnabled: true);
                            Toast(text: "OTP verified successfully!").show();
                            var paramDoctorInfo = [String: Any]();
                            paramDoctorInfo[Names.NAME] = strName;
                            paramDoctorInfo[Names.EMAIL] = strEmail;
                            paramDoctorInfo["phonenumber"] = strPhone;
                            paramDoctorInfo[Names.ROLE] = "assistant";


                            var docAttr = [String: Any]();
                            docAttr["doctorSpeciality"] = ""  // .eSpeciality.text;
                            docAttr["doctorEducationDetails"] = "" // .eEducationalDetails.text;
                            docAttr["doctorTotalExperience"] = "" // .eTotalExperience.text;
                            docAttr["doctorExpertize"] = "" // .eExpertise.text;
                            docAttr["doctorRegistrationNumber"] = "" // .eRegistration.text;
                            docAttr["doctorLicenceValidity"] = "" // .bValidity.titleLabel?.text;

                            var clinic = [String: Any]();
                            clinic["name"] = "" // .eClinicName.text;
                            clinic["phone"] = "" // .ePhone.text;
                            clinic["mobile"] = "" // .ePhone.text;
                            clinic["email"] = "" // .eEmail.text;

                            var clinicLocation = [String: Any]();
                            clinicLocation["name"] = "primary";
                            clinicLocation["address1"] = "" // .eClinicAddress.text;
                            clinicLocation["phone"] = "" // .ePhone.text;
                            clinicLocation["area"] = "" // .eClinicArea.text;
                            clinicLocation["city"] = "" // .eCity.text;
                            clinicLocation["postalCode"] = "" // .ePostalCode.text;
                            clinicLocation["state"] = "" // .eState.text;
                            clinicLocation["email"] = "" // .eEmail.text;
                            clinicLocation["latitude"] = "" // .locationManager?.location?.coordinate.latitude.description;
                            clinicLocation["longitude"] = "" // .locationManager?.location?.coordinate.longitude.description;
                            clinicLocation["country"] = "" // .eCountry.text;

                            var mainObj = [String: Any]();
                            mainObj["doctorInfo"] = paramDoctorInfo;
                            mainObj["doctorAttributes"] = docAttr;
                            mainObj["clinic"] = clinic;
                            mainObj["clinicLocation"] = clinicLocation;

                            self.apiCallSignUPCompletiong(mainObj)

                        } else {
                            senderInside.isEnabled = true;
                            self.present(alert, animated: true);
                            sender.isEnabled = true;
                            Toast(text: "Error verifying OTP!").show();
                        }
                    }


                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                    sender in
                }))
                alert.addTextField(configurationHandler: { (textField: UITextField!) in
                    Utility.buttonVisibilityAndShow(sender, title: "Sign Up", isEnabled: true);
                    textField.keyboardType = .numberPad;
                    textField.placeholder = "OTP here"
                    textField.isSecureTextEntry = true // for password input
                    textFieldUpper = textField;
                })
                self.present(alert, animated: true, completion: nil)

            } else {
                Utility.buttonVisibilityAndShow(sender, title: "Sign Up", isEnabled: true);
                var descript: String = "";
                if (response.result.value != nil) {
                    descript = (response.result.value as! [String: String])["description"]!;
                }
                Toast(text: "Error in generating OTP \(descript)").show();
                sender.isEnabled = true;
            }
        }


    }

    private func apiCallSignUPCompletiong(_ mainObj: [String: Any]) {
        let url = DAMUrls.urlSignUPCompletion();
        let request = ApiServices.createPlainPostRequest(urlStr: url, parameters: mainObj);

        AlamofireManager.Manager.request(request).responseString {
            response in
            if (response.response?.statusCode == 200) {
                Toast(text: "Please check your SMS for login credentials !").show();
                self.dismiss(animated: true);
            } else {
                Toast(text: "Error occurred while signing up! Error Code: \(response.response?.statusCode.description)").show();
            }
        }


    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
