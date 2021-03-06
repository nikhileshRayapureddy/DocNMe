//
// Created by Sandeep Rana on 05/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Toaster
import Foundation
import UIKit
import Dropper
import ObjectMapper
import RealmSwift
import Alamofire
import AlamofireObjectMapper

//import Validator

class VCEditPatientsBasicInfo: UIViewController {
    @IBOutlet weak var eName: UITextField!;
    @IBOutlet weak var ePhoneNumber: UITextField!;
    @IBOutlet weak var eCountryCode: UITextField!;
    @IBOutlet weak var eEmail: UITextField!;
    @IBOutlet weak var eAge: UITextField!;
    @IBOutlet weak var eReferredBy: UITextField!;
    @IBOutlet weak var ePermAddress: UITextField!;
    @IBOutlet weak var eCity: UITextField!;
    @IBOutlet weak var ePincode: UITextField!;
    @IBOutlet weak var svGender: UISegmentedControl!;
    @IBOutlet weak var svMaritalStatus: UISegmentedControl!;
    @IBOutlet weak var switchVip: UISwitch!;
    @IBOutlet weak var iProfileAvatar: UIImageView!;
    @IBOutlet weak var lState: UILabel!;
    @IBOutlet weak var bSave: UIButton!;
//    var imageController:UIImagePickerController?;

    public var personInfo: Patient?;


    let arrOfStates = [
        "Andra Pradesh",
        "Arunachal Pradesh",
        "Assam",
        "Bihar",
        "Chhattisgarh",
        "Goa",
        "Gujarat",
        "Haryana",
        "Himachal Pradesh",
        "Jammu and Kashmir",
        "Jharkhand",
        "Karnataka",
        "Kerala",
        "Madya Pradesh",
        "Maharashtra",
        "Manipur",
        "Meghalaya",
        "Mizoram",
        "Nagaland",
        "NCR",
        "Odisha",
        "Punjab",
        "Rajasthan",
        "Sikkim",
        "Tamil Nadu",
        "Telangana",
        "Tripura",
        "Uttarakhand",
        "Uttar Pradesh",
        "West Bengal"
    ]


    private var dropper: Dropper?;

    var onChangeListener: OnChangeListener?;

    let picker = UIImagePickerController();

    @IBAction func onClickCameraButton(_ sender: UIButton) {

//        let imageController: UIImagePickerController = UIImagePickerController();
//        imageController.sourceType = .camera;
//        imageController.delegate = self;
//        self.present(imageController, animated: true);
        picker.delegate = self;
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")
            picker.sourceType = .camera;
            picker.allowsEditing = false
            picker.modalPresentationStyle = .overCurrentContext;
            self.present(picker, animated: true, completion: nil);

//            self.addChildViewController(picker)
//            picker.didMove(toParentViewController: self)
//            self.view!.addSubview(picker.view!)
        }

    }

    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr) && testStr.characters.count > 1;
    }

    @IBAction func onClickSaveButton(_ sender: UIButton) {

        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if self.eName.text?.rangeOfCharacter(from: characterset.inverted) != nil {
            Toast(text: "Name can contain only numbers and alphabets").show();
            return;
        } else {
            if self.eName.text!.characters.count < 1 {
                Toast(text: "Name can't be empty!").show();
                return;
            }
        }


        if self.ePhoneNumber.text!.characters.count < 10 {
            Toast(text: "Please input a valid phone number!").show();
            return;
        }


        if (!isValidEmail(testStr: self.eEmail.text!)) {
            Toast(text: "Invalid Email").show();
            return;
        }

//        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message:"Invalid Email"));
//
//        if (!eEmail.text!.validate(rule: emailRule).isValid){
//            Toast(text: "Invalid Email").show();
//            return;
//        }

        if (!self.ePincode.text!.isNumeric || self.ePincode.text!.characters.count != 6) {
            Toast(text: "Please enter a valid pincode").show();
            return;
        }


        if (self.personInfo == nil) {
            self.apiCallAddPatientToServer(sender);
        } else {
            self.apiEditAddPatientToServer(sender);
        }
    }

    private func apiEditAddPatientToServer(_ sender: UIButton) {
//        let urlEditPatient = DAMUrls.urlPatientEditToClinic(self.personInfo);

        let idPerson = self.personInfo?.personId;

        let patient = Patient();
        patient.personId = idPerson!;
        let personInfo = PersonInfoModel();
        personInfo.setFields(from: self.personInfo!);

        personInfo.name = self.eName.text;
        personInfo.email = self.eEmail.text;
        personInfo.gender = self.svGender.selectedSegmentIndex;
        personInfo.mstatus = self.svMaritalStatus.selectedSegmentIndex;
//        personInfo.dob = self.
        if (self.eAge.text != nil && self.eAge.text != "") {
            let earlyDate = Calendar.current.date(byAdding: .year, value: Int(self.eAge.text!)!, to: Date());
            personInfo.dob = earlyDate!.millisecondsSince1970;
        }

        personInfo.id = idPerson;


        personInfo.state = self.lState.text;
        personInfo.address = self.ePermAddress.text;
        personInfo.city = self.eCity.text;
        personInfo.pincode = self.ePincode.text;
        if !(self.eCountryCode.text?.isEmpty)! {
            personInfo.phonenumber = "\(self.eCountryCode.text!)\(self.ePhoneNumber.text!)";
        }else {
            personInfo.phonenumber = "+91\(self.ePhoneNumber.text!)";
        }

        personInfo.role = "assistant";

        personInfo.vip = (self.switchVip.isOn ? 1 : 0);

        patient.clinicId = self.personInfo?.clinicId;
        patient.clinicPersonId = self.personInfo?.clinicPersonId;
        patient.personId = (self.personInfo?.personId)!;

        patient.refererName = self.eReferredBy.text;

        let realm = try? Realm();
        do {
            try realm?.write({
                patient.isUpdated = true;
                if (self.personInfo == nil) {
                    realm?.add(patient);
                    realm?.add(personInfo);
                } else {

                    let results = realm?.objects(Patient.self).filter("personId = '" + patient.personId.description + "'");

                    if ((results?.count)! > 0) {
                        var pat = results?.first;
                        pat?.isUpdated = true;
//                        pat?.personId = "";
                        pat?.refererName = patient.refererName;
                    }

                    let pregIn = realm?.objects(PregnancyInfo.self).filter("id = '" + patient.personId.description + "'").first;
                    pregIn?.id = personInfo.id;
                    pregIn?.name = personInfo.name;
                    pregIn?.email = personInfo.email;
                    pregIn?.icon = personInfo.icon;
                    pregIn?.gender = personInfo.gender;
                    pregIn?.mstatus = personInfo.mstatus;
//                    pregIn?.dob = personInfo.dob;
                    pregIn?.bloodgroup = personInfo.bloodgroup;
                    pregIn?.donor = personInfo.donor;
                    pregIn?.vip = personInfo.vip;

                    if let address = personInfo.address {
                        pregIn?.address = address;
                    }

                    if let city = personInfo.city {
                        pregIn?.city = city;
                    }

                    if let state = personInfo.state {
                        pregIn?.state = state;
                    }

                    if let country = personInfo.country {
                        pregIn?.country = country;
                    }

                    if let pincode = personInfo.pincode {
                        pregIn?.pincode = pincode;
                    }
                    pregIn?.phonenumber = personInfo.phonenumber;
                    pregIn?.changepassword = personInfo.changepassword;
//                    pregIn?.pregnant = personInfo.pregnant;
//                    pregIn?.highrisk = personInfo.highrisk;
//                    pregIn?.edd = personInfo.edd;


                    let personInfoResult = realm?.objects(PersonInfoModel.self).filter("id = '" + patient.personId.description + "'");
                    if ((personInfoResult?.count)! > 0) {
//                        let personInfoRes = personInfoResult?.first;
                        personInfoResult?.first?.id = personInfo.id;
                        personInfoResult?.first?.prefixStr = personInfo.prefixStr;
                        personInfoResult?.first?.name = personInfo.name;
                        personInfoResult?.first?.email = personInfo.email;
                        personInfoResult?.first?.icon = personInfo.icon;
                        personInfoResult?.first?.gender = personInfo.gender;
                        personInfoResult?.first?.mstatus = personInfo.mstatus;
                        personInfoResult?.first?.dob = personInfo.dob;
                        personInfoResult?.first?.bloodgroup = personInfo.bloodgroup;
                        personInfoResult?.first?.donor = personInfo.donor;
                        personInfoResult?.first?.vip = personInfo.vip;
                        personInfoResult?.first?.address = personInfo.address;
                        personInfoResult?.first?.address2 = personInfo.address2;
                        personInfoResult?.first?.city = personInfo.city;
                        personInfoResult?.first?.state = personInfo.state;
                        personInfoResult?.first?.country = personInfo.country;
                        personInfoResult?.first?.pincode = personInfo.pincode;
                        personInfoResult?.first?.latitude = personInfo.latitude;
                        personInfoResult?.first?.longitude = personInfo.longitude;
                        personInfoResult?.first?.phonenumber = personInfo.phonenumber;
                        personInfoResult?.first?.landline = personInfo.landline;
                        personInfoResult?.first?.changepassword = personInfo.changepassword;
                        personInfoResult?.first?.role = personInfo.role;
                    } else {
                        realm?.add(personInfo);
                    }


                }
            })
        } catch {
            print("\(error.localizedDescription) Error occured");
        };

        self.navigationController?.popViewController(animated: true);
        if self.onChangeListener != nil {
            self.onChangeListener?.onChange();
        }
        try? realm?.commitWrite();
//        patient.personInfo = personInfo;
//
//        sender.setTitle("saving...", for: .normal);
//
//        let request = ApiServices.createPostRequest(urlStr: urlEditPatient, parameters: patient.toJSON());
//        AlamofireManager.Manager.request(request).responseString() {
//            response in
//            sender.isEnabled = true;
//            sender.setTitle("SAVE", for: .normal);
//            if response.response?.statusCode == 200 {
//                print(response.result.value);
//                self.navigationController?.popViewController(animated: true);
//            }
//        }

    }

    private func apiCallAddPatientToServer(_ sender: UIButton) {
        sender.isEnabled = false;
//        let urlAddPatient = DAMUrls.urlPatientAddToClinic();

        let idPerson = Date().millisecondsSince1970.description;

        let patient = Patient();
        patient.clinicId = UserPrefUtil.getClinicResponse()?.clinic?.id;
        patient.personId = idPerson;
        let personInfo = PersonInfoModel();
//        if self.personInfo != nil {
        personInfo.id = idPerson;
//        }
        personInfo.name = self.eName.text;
        personInfo.email = self.eEmail.text;
        personInfo.gender = self.svGender.selectedSegmentIndex;
        personInfo.mstatus = self.svMaritalStatus.selectedSegmentIndex;
//        personInfo.dob = self.
        if (self.eAge.text != nil && self.eAge.text != "") {
            let earlyDate = Calendar.current.date(byAdding: .year, value: Int(self.eAge.text!)!, to: Date());
            personInfo.dob = earlyDate!.millisecondsSince1970;
        }

        personInfo.address = self.ePermAddress.text;
        personInfo.city = self.eCity.text;
        personInfo.pincode = self.ePincode.text;

        if !(self.eCountryCode.text?.isEmpty)! {
            personInfo.phonenumber = "\(self.eCountryCode.text!)\(self.ePhoneNumber.text!)";
        }else {
            personInfo.phonenumber = "+91\(self.ePhoneNumber.text!)";
        }

        personInfo.role = "assistant";

        personInfo.vip = (self.switchVip.isOn ? 1 : 0);

        patient.refererName = self.eReferredBy.text;


        let realm = try? Realm();
        do {
            try realm?.write({
                patient.isUpdated = true;
                if (self.personInfo == nil) {

                    realm?.add(patient);
                    realm?.add(personInfo);

                    let pregIn = PregnancyInfo();
                    pregIn.id = idPerson;
                    pregIn.name = personInfo.name;
                    pregIn.email = personInfo.email;
                    pregIn.icon = personInfo.icon;
                    pregIn.gender = personInfo.gender;
                    pregIn.mstatus = personInfo.mstatus;
                    pregIn.bloodgroup = personInfo.bloodgroup;
                    pregIn.donor = personInfo.donor;
                    pregIn.vip = personInfo.vip;
                    pregIn.address = personInfo.address;
                    pregIn.city = personInfo.city;
                    pregIn.state = personInfo.state;
                    pregIn.country = personInfo.country;
                    pregIn.pincode = personInfo.pincode;
                    pregIn.phonenumber = personInfo.phonenumber;
                    pregIn.changepassword = personInfo.changepassword;

                    realm?.add(pregIn);

                }
            })
        } catch {
            print("\(error.localizedDescription) Error occured");
        };

        self.navigationController?.popViewController(animated: true);
        if self.onChangeListener != nil {
            self.onChangeListener?.onChange();
        }
//        patient.personInfo = personInfo;
//        try? self.realm?.write({
//            realm?.add(patient);
//            realm?.add(personInfo);
//            let pregInfo = PregnancyInfo();
//            pregInfo.setFields(personInfo);
////            realm
//        });

//        let request = ApiServices.createPostRequest(urlStr: urlAddPatient, parameters: patient.toJSON());
//        AlamofireManager.Manager.request(request).responseString() {
//            response in
//            sender.isEnabled = true;
//            if response.response?.statusCode == 200 {
//                print(response.result.value);
//                self.navigationController?.popViewController(animated: true);
//            }
//        }
    }

//    let realm = try? Realm();

    @IBAction func onClickSelectState(_ sender: UIButton) {
        self.view.bringSubview(toFront: sender);
        if (self.dropper != nil) {
            self.dropper?.hide();
            self.dropper = nil;
            return;
        }

        self.dropper = Dropper.init(width: 140, height: 200);
        self.dropper?.items = Array(self.arrOfStates);
        self.dropper?.delegate = self;
//        self.dropper?.show(.top, button: sender);
        self.dropper?.showWithAnimation((0.15), options: .left, position: .top, button: self.bSave)

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = Utility.getDateFormatter(dateFormat: "yyyy-MM-dd")
        if (self.personInfo != nil) {
            let pregInfo = self.personInfo?.personPregnancyInfo;
            self.eName.text = pregInfo?.name;
            if (pregInfo?.dob != nil && pregInfo?.dob != "") {
                self.eAge.text = Utility.calculateAgefromDOB(pregInfo?.dob);
            }
            self.eCity.text = pregInfo!.city;
            self.eEmail.text = pregInfo!.email;
            self.ePermAddress.text = pregInfo!.address;
            self.ePhoneNumber.text = pregInfo!.phonenumber;
            self.ePincode.text = pregInfo!.pincode;
            self.eReferredBy.text = self.personInfo?.refererName;
            self.lState.text = pregInfo!.state;
            self.svGender.selectedSegmentIndex = pregInfo!.gender;
            self.svMaritalStatus.selectedSegmentIndex = pregInfo!.mstatus;
            self.switchVip.isOn = (pregInfo!.vip == 0 ? false : true);
            self.title = "Edit Profile"
        } else {
            self.title = "Add Patient";
        }
    }

}


extension VCEditPatientsBasicInfo: DropperDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String, tag: Int) {
        self.lState.text = contents;
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        self.iProfileAvatar.contentMode = .scaleAspectFit;
        self.iProfileAvatar.image = image;
        picker.dismiss(animated: true);
//        dismiss(animated: true);
    }
}


