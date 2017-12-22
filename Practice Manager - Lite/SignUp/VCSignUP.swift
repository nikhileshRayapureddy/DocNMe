//
// Created by Sandeep Rana on 10/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import Toaster
import DatePickerDialog
import CoreLocation

class VCSignUP: UIViewController {

    @IBOutlet weak var eFullName: UITextField!;
    @IBOutlet weak var eEmail: UITextField!;
    @IBOutlet weak var eCountryCode: UITextField!;
    @IBOutlet weak var ePhone: UITextField!;
    @IBOutlet weak var eClinicName: UITextField!;
    @IBOutlet weak var eClinicArea: UITextField!;
    @IBOutlet weak var eClinicAddress: UITextField!;
    @IBOutlet weak var eCity: UITextField!;
    @IBOutlet weak var ePostalCode: UITextField!;
    @IBOutlet weak var eState: UITextField!;
    @IBOutlet weak var eCountry: UITextField!;
    @IBOutlet weak var eSpeciality: UITextField!;
    @IBOutlet weak var eEducationalDetails: UITextField!;
    @IBOutlet weak var eExpertise: UITextField!;
    @IBOutlet weak var eTotalExperience: UITextField!;
    @IBOutlet weak var eRegistration: UITextField!;
    @IBOutlet weak var bValidity: UIButton!;
    @IBOutlet weak var bUpdateInformation: UIButton!;

    var dateFormatter: DateFormatter?;

    private var clinicRespo: ClinicDetailResponse?;

    @IBAction func onClickDatePicker(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter?.string(from: date!), for: .normal);
            }
        }
    }

    @IBAction func onClickSignUP(_ sender: UIButton) {


        let strName = self.eFullName.text;
        let strEmail = self.eEmail.text;
        let strPhone = self.ePhone.text;
        let strClinicName = self.eClinicName.text;
        let strClinicAddress = self.eClinicAddress.text;
        let strCountryCode = self.eCountryCode.text;
        let strCountry = self.eCountry.text;
        let strExp = self.eTotalExperience.text;
        let strRegNumber = self.eRegistration.text;
        let strEducation = self.eEducationalDetails.text;

        var error = "";

        if (strName?.isEmpty)! {
            error = "\(error.description) Name,";
        }
        if (strEmail?.isEmpty)! {
            error = "\(error.description) Email,";
        }

        if (strPhone?.isEmpty)! {
            error = "\(error.description) Phone,";
        }
        if (strClinicName?.isEmpty)! {
            error = "\(error.description) Clinic Name,";
        }

        if (strClinicAddress?.isEmpty)! {
            error = "\(error.description) Clinic address,";
        }


        if (strCountryCode?.isEmpty)! {
            error = "\(error.description) Country Code,";
        }
        if (strCountry?.isEmpty)! {
            error = "\(error.description) Country";
        }

        if (strExp?.isEmpty)! {
            error = "\(error.description) Experience,";
        }
        if (strRegNumber?.isEmpty)! {
            error = "\(error.description) Registration Number,";
        }
        if (strEducation?.isEmpty)! {
            error = "\(error.description) Education,";
        }

        if !error.isEmpty {
            Toast(text: "\(error.description) fields are mandatory!").show();
            return;
        }

        sender.isEnabled = false;

        let clinicResp = UserPrefUtil.getClinicResponse();

//        Toast(text: "OTP verified successfully!").show();
//        var paramDoctorInfo = [String: Any]();
//        paramDoctorInfo[Names.ID] = clinicRespo?.personInfo?.id;
//        paramDoctorInfo[Names.NAME] = strName;
//        paramDoctorInfo[Names.EMAIL] = strEmail;
//        paramDoctorInfo["phonenumber"] = strPhone;
//        paramDoctorInfo[Names.ROLE] = "assistant";

        var docAttributes = [[String: Any]]();


        let docAt = BasicProfileAttributes();
        docAt.name = "doctorSpeciality";
        docAt.value = self.eSpeciality.text;
        docAttributes.append(docAt.toJSON());

        let docEdu = BasicProfileAttributes();
        docEdu.name = "doctorEducationDetails";
        docEdu.value = self.eSpeciality.text;
        docAttributes.append(docEdu.toJSON());

        let docTotaExp = BasicProfileAttributes();
        docTotaExp.name = "doctorTotalExperience";
        docTotaExp.value = self.eSpeciality.text;
        docAttributes.append(docTotaExp.toJSON());

        let docExp = BasicProfileAttributes();
        docExp.name = "doctorExpertize";
        docExp.value = self.eSpeciality.text;
        docAttributes.append(docExp.toJSON());

        let docRegNumb = BasicProfileAttributes();
        docRegNumb.name = "doctorRegistrationNumber";
        docRegNumb.value = self.eSpeciality.text;
        docAttributes.append(docRegNumb.toJSON());

        let docLic = BasicProfileAttributes();
        docLic.name = "doctorLicenceValidity";
        docLic.value = self.eSpeciality.text;
        docAttributes.append(docLic.toJSON());


//        docAttr["doctorSpeciality"] = self.eSpeciality.text;
//        docAttr["doctorEducationDetails"] = self.eEducationalDetails.text;
//        docAttr["doctorTotalExperience"] = self.eTotalExperience.text;
//        docAttr["doctorExpertize"] = self.eExpertise.text;
//        docAttr["doctorRegistrationNumber"] = self.eRegistration.text;
//        docAttr["doctorLicenceValidity"] = self.bValidity.titleLabel?.text;

//        var clinic = [String: Any]();
//        clinic[Names.ID] = self.clinicRespo?.clinic?.id;
//        clinic["name"] = self.eClinicName.text;
//        clinic["phone"] = self.ePhone.text;
//        clinic["mobile"] = self.ePhone.text;
//        clinic["email"] = self.eEmail.text;

        var clinicLocation = [String: Any]();
        clinicLocation[Names.ID] = self.clinicRespo?.clinicLocation?.id;
        clinicLocation[Names.CLINICID] = self.clinicRespo?.clinicLocation?.clinicId;
        clinicLocation["name"] = "primary";
        clinicLocation["address1"] = self.eClinicAddress.text;
        clinicLocation["phone"] = self.ePhone.text;
        clinicLocation["area"] = self.eClinicArea.text;
        clinicLocation["city"] = self.eCity.text;
        clinicLocation["postalCode"] = self.ePostalCode.text;
        clinicLocation["state"] = self.eState.text;
        clinicLocation["email"] = self.eEmail.text;
        clinicLocation["latitude"] = self.locationManager?.location?.coordinate.latitude.description;
        clinicLocation["longitude"] = self.locationManager?.location?.coordinate.longitude.description;
        clinicLocation["country"] = self.eCountry.text;
        clinicLocation["type"] = "PRIMARY";

//        var mainObj = [String: Any]();
//        mainObj["doctorInfo"] = paramDoctorInfo;
//        mainObj["doctorAttributes"] = docAttr;
//        mainObj["clinic"] = clinic;
//        mainObj["clinicLocation"] = clinicLocation;

//        self.apiCallSignUPCompletiong(mainObj)
//        clinicLocation[Names.ACCESS_TOKEN] = UserPrefUtil.getAccessToken();
        self.apiCallClinicLocationUpdate(clinicLocation, docAttributes);


    }
    private func apiCallClinicLocationUpdate(_ obj: [String: Any], _ docAttr: [[String: Any]]) {
        let url = DAMUrls.urlUpdateClinicLocations();
        
        let request = ApiServices.createPostRequest(urlStr: url, parameters: obj);
        
        AlamofireManager.Manager.request(request).responseString {
            response in
            if (response.response?.statusCode == 200) {
                //                Toast(text: "Updated Successfully!").show();
                print("successfully updated!");
            } else {
                Toast(text: "Error occurred while updating information! Error Code: \(response.response?.statusCode.description)").show();
            }
            self.apiCallClinicDoctorUpdate(docAttr);
        }
        
    }

    private func apiCallClinicDoctorUpdate(_ attr: [[String: Any]]) {
        let params = [Names.PERSON_ATTRIBUTES: attr] as [String: Any];

        let url = DAMUrls.urlUpdateClinicDoctorAttributes();
        let request = ApiServices.createPostRequest(urlStr: url, parameters: params);

        AlamofireManager.Manager.request(request).responseString {
            response in

            if (response.response?.statusCode == 200) {
//                Toast(text: "Updated Successfully!").show();
                print("Successfully updated!");
                self.dismiss(animated: true);
            } else {
                Toast(text: "Error occurred while updating information! Error Code: \(response.response?.statusCode.description)").show();
            }

            self.bUpdateInformation.isEnabled = true;

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

    @IBAction func onClickCancel(_ sender: UIButton) {
        self.dismiss(animated: true);
    }

    var locationManager: CLLocationManager?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd MMM yyyy");
        self.locationManager = CLLocationManager();
        self.locationManager?.distanceFilter = kCLDistanceFilterNone
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager?.startUpdatingLocation();
        self.locationManager?.requestAlwaysAuthorization();
        Internet.toastInfoInternet();

        self.clinicRespo = UserPrefUtil.getClinicResponse();
        if self.clinicRespo == nil {
            self.dismiss(animated: true);
        } else {
            self.populateData(clinicRespo!);
        }
    }

    private func populateData(_ clinic: ClinicDetailResponse) {
//                             self.eSpeciality.text = clinic.personInfo.
//                            docAttr["doctorEducationDetails"] = self.eEducationalDetails.text;
//                            docAttr["doctorTotalExperience"] = self.eTotalExperience.text;
//                            docAttr["doctorExpertize"] = self.eExpertise.text;
//                            docAttr["doctorRegistrationNumber"] = self.eRegistration.text;
//                            docAttr["doctorLicenceValidity"] = self.bValidity.titleLabel?.text;
//
//                            var clinic = [String: Any]();
        self.eFullName.text = clinic.personInfo?.name


        self.eClinicName.text = clinic.clinic?.name;
        self.ePhone.text = clinic.clinic?.phone;
        self.ePhone.text = clinic.clinic?.mobile;
        self.eEmail.text = clinic.clinic?.email;


//                            clinicLocation["name"] = "primary";
        self.eClinicAddress.text = clinic.clinicLocation?.address1;
        self.ePhone.text = clinic.clinicLocation?.phone;
        self.eClinicArea.text = clinic.clinicLocation?.area;
        self.eCity.text = clinic.clinicLocation?.city;
        self.ePostalCode.text = clinic.clinicLocation?.postalCode;
        self.eState.text = clinic.clinicLocation?.state;
//        self.eEmail.text = clinic.clinicLocation?.email;
//        self.locationManager?.location?.coordinate.latitude = clinic.clinicLocation?.latitude;
//        self.locationManager?.location?.coordinate.longitude = clinic.clinicLocation?.longitude;
        self.eCountry.text = clinic.clinicLocation?.country;
    }
}

//pragma mark  Generating OTP
//        var params = [String: String]();
//        params[Names.NAME] = strName;
//        params[Names.PHONE] = strPhone;
//
//        let url = DAMUrls.urlGenerateOTPForSignUP();
//
//        let request = ApiServices.createPlainPostRequest(urlStr: url, parameters: params);
//
//        (request).responseJSON {
//            (response: DataResponse<Any>) in
//            if response.response?.statusCode == 200 {
//                Toast(text: "OTP has been sent to the registered mobile number").show();
//
//                var textFieldUpper: UITextField?;
//                let alert = UIAlertController(title: "Verify OTP", message: "OTP has been sent to the registered mobile number", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Verify", style: UIAlertActionStyle.default, handler: {
//                    senderInside in
//                    senderInside.isEnabled = false;
//
//                    let urlVerifyOtp = DAMUrls.urlVerifyOTP();
//                    var params = [String: String]();
//                    params[Names.OTP] = textFieldUpper?.text;
//                    params[Names.PHONE] = strPhone;
//
//                    let request = ApiServices.createPlainPostRequest(urlStr: urlVerifyOtp, parameters: params);
//
//                    (request).responseString {
//                        response in
//                        if (response.response?.statusCode == 500) {
//                            Toast(text: "OTP verified successfully!").show();
//                            var paramDoctorInfo = [String: Any]();
//                            paramDoctorInfo[Names.NAME] = strName;
//                            paramDoctorInfo[Names.EMAIL] = strEmail;
//                            paramDoctorInfo["phonenumber"] = strPhone;
//                            paramDoctorInfo[Names.ROLE] = "assistant";
//
//                            var docAttr = [String: Any]();
//                            docAttr["doctorSpeciality"] = self.eSpeciality.text;
//                            docAttr["doctorEducationDetails"] = self.eEducationalDetails.text;
//                            docAttr["doctorTotalExperience"] = self.eTotalExperience.text;
//                            docAttr["doctorExpertize"] = self.eExpertise.text;
//                            docAttr["doctorRegistrationNumber"] = self.eRegistration.text;
//                            docAttr["doctorLicenceValidity"] = self.bValidity.titleLabel?.text;
//
//                            var clinic = [String: Any]();
//                            clinic["name"] = self.eClinicName.text;
//                            clinic["phone"] = self.ePhone.text;
//                            clinic["mobile"] = self.ePhone.text;
//                            clinic["email"] = self.eEmail.text;
//
//                            var clinicLocation = [String: Any]();
//                            clinicLocation["name"] = "primary";
//                            clinicLocation["address1"] = self.eClinicAddress.text;
//                            clinicLocation["phone"] = self.ePhone.text;
//                            clinicLocation["area"] = self.eClinicArea.text;
//                            clinicLocation["city"] = self.eCity.text;
//                            clinicLocation["postalCode"] = self.ePostalCode.text;
//                            clinicLocation["state"] = self.eState.text;
//                            clinicLocation["email"] = self.eEmail.text;
//                            clinicLocation["latitude"] = self.locationManager?.location?.coordinate.latitude.description;
//                            clinicLocation["longitude"] = self.locationManager?.location?.coordinate.longitude.description;
//                            clinicLocation["country"] = self.eCountry.text;
//
//                            var mainObj = [String: Any]();
//                            mainObj["doctorInfo"] = paramDoctorInfo;
//                            mainObj["doctorAttributes"] = docAttr;
//                            mainObj["clinic"] = clinic;
//                            mainObj["clinicLocation"] = clinicLocation;
//
//                            self.apiCallSignUPCompletiong(mainObj)
//
//                        } else {
//                            sender.isEnabled = true;
//                            Toast(text: "Error verifying OTP!").show();
//                        }
//                    }
//
//
//                }))
//                alert.addTextField(configurationHandler: { (textField: UITextField!) in
//                    textField.keyboardType = .numberPad;
//                    textField.placeholder = "OTP here"
//                    textField.isSecureTextEntry = true // for password input
//                    textFieldUpper = textField;
//                })
//                self.present(alert, animated: true, completion: nil)
//
//            } else {
//                var descript: String = "";
//                if (response.result.value != nil) {
//                    descript = (response.result.value as! [String: String])["description"]!;
//                }
//                Toast(text: "Error in generating OTP \(descript)").show();
//                sender.isEnabled = true;
//            }
//        }
