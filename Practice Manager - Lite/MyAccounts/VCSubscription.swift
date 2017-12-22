//
//  VCSubscription.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 09/10/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Toaster

class VCSubscription: UIViewController {

    @IBOutlet weak var segmentOutlet: UISegmentedControl!

    private var coupon: CouponResponse?;

    @IBAction func onSegmentControlChanged(_ sender: UISegmentedControl) {
        self.updateUI();
    }


    func switchChangedUpdateUI() {
        self.updateUI();
    }

    @IBAction func onSwitchEnableCloudBackup(_ sender: UISwitch) {
        self.switchChangedUpdateUI();
    }

    @IBAction func onClickBuyCredits(_ sender: UIButton) {
        
    }

    @IBAction func onSwitchBuyPatientCredits(_ sender: UISwitch) {
        if (sender.isOn) {
            self.segment500.isHidden = false;
        } else {
            self.segment500.isHidden = true;
        }
        self.switchChangedUpdateUI();
    }

    @IBOutlet weak var bBuyCredits: UIButton!
    @IBOutlet weak var lAvailableCredit: UILabel!
    @IBOutlet weak var lCurrentSubscription: UILabel!
    @IBOutlet weak var lPatientCount: UILabel!
    @IBOutlet weak var lSmsCount: UILabel!

    @IBOutlet weak var switchRequestEnterprize: UISwitch!
    @IBOutlet weak var switchBuy500SMS: UISwitch!
    @IBOutlet weak var switchEnableBackUP: UISwitch!
    @IBOutlet weak var swutchBuyPatientCredits: UISwitch!

    @IBOutlet weak var segment500: UISegmentedControl!
    @IBOutlet weak var eCouponcode: UITextField!

    @IBAction func onClickApplyCoupon(_ sender: UIButton) {
        let couponCode = self.eCouponcode.text;
        if couponCode == "" {
            Toast(text: "Please enter valid coupon code").show();
            return;
        }
        let urlRequestEnterprise = DAMUrls.urlValidateVoucher(couponCode:couponCode!);
        var params = [String: Any]();

        params[Names.PERSONID] = UserPrefUtil.getClinicResponse()?.personInfo?.id;

        sender.isEnabled = false;

        let request = ApiServices.createPostRequest(urlStr: urlRequestEnterprise, parameters: params);
        AlamofireManager.Manager.request(request).responseObject {
            (response: DataResponse<CouponResponse>) in
            sender.isEnabled = true;
            if response.response?.statusCode == 200 {
                self.coupon = response.result.value;
                self.updateUI();
            } else {
                Toast(text: "Invalid Coupon Code!").show();
            }

        }
    }

    @IBAction func onClickUpgrade(_ sender: UIButton) {
        if (Int((self.lRequiredCredits.text?.description)!)! < Int((self.lAvailableCredit.text?.description)!)!) {
            Toast(text: "💰 Don't have enough credits 💰").show();
            return;
        }

        if (switchRequestEnterprize.isOn) {
            let urlRequestEnterprise = DAMUrls.urlRequestEnterprise();
            var params = [String: Any]();

            params[Names.PERSONID] = UserPrefUtil.getClinicResponse()?.personInfo?.id;

            let request = ApiServices.createPostRequest(urlStr: urlRequestEnterprise, parameters: params);
            AlamofireManager.Manager.request(request).responseString {
                response in
                if response.response?.statusCode == 200 {
                    Toast(text: "🤘We have noted your request to upgrade. Our sales team will contact you shortly.").show();
                } else {
                    Toast(text: "Error").show();
                }
            }
        } else {

            let url = DAMUrls.urlUpgradeThings();
            let request = ApiServices.createGetRequest(urlStr: url, parameters: []);

            AlamofireManager.Manager.request(request).responseString {
                response in

            }

        }

    }

    @IBOutlet weak var stackViewBuyCredits: UIStackView!;
    @IBOutlet weak var countLeftWrapper: UIStackView!;
    @IBOutlet weak var planWithSwitch: UIStackView!;
    @IBOutlet weak var couponandupgrade: UIStackView!;


    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiCallGetAvailablePlans();
        self.getSubscriptionType();
        self.getTotalBalanceCredits();
        self.updateUI();
    }

    private func getTotalBalanceCredits() {
        let url = DAMUrls.getTotalBalanceCreditUsable();
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);

        AlamofireManager.Manager.request(request).responseString {
            (response) in
            if (response.response?.statusCode == 200) {
                if (response.result.value != nil) {
                    UserPrefUtil.setCreditAttribute(response.result.value);
                    self.updateUI();
                } else {
                    UserPrefUtil.setCreditAttribute(nil);
                    self.updateUI();
                }
            }
        }
    }

    private func getSubscriptionType() {
        let url = DAMUrls.getSubscriptionType(clinicID: (UserPrefUtil.getClinicResponse()?.clinic?.id!)!)
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);

        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[BasicProfileAttributes]>) in
            if (response.response?.statusCode == 200) {
//                print(response.result.value?.toJSONString());
                if (response.result.value?.count != 0) {
                    let attr: BasicProfileAttributes = response.result.value![0];
                    self.lCurrentSubscription.text = attr.value;
                    UserPrefUtil.setSubscriptionType(response.result.value![0]);
                    self.updateUI();
                } else {
                    self.updateUI();
                }

            }
        }

    }

    @IBOutlet weak var bUpgrade: UIButton!;

    private func updateUI() {


//        Based on Subscription Type

        if let attr: BasicProfileAttributes = UserPrefUtil.getSubscriptionType() {
            switch (attr.value!.description) {
            case Names.ENTERPRISE:
                self.lCurrentSubscription.text = Names.ENTERPRISE;
                stackViewBuyCredits.isHidden = true;
                self.countLeftWrapper.isHidden = true;
                self.planWithSwitch.isHidden = true;
                self.couponandupgrade.isHidden = true;
                break;
            case Names.STANDARD:
                self.lCurrentSubscription.text = Names.STANDARD;
                break;
            default:
                self.lCurrentSubscription.text = Names.STANDARD;
                break;
            }
        } else {
            self.lCurrentSubscription.text = Names.STANDARD;
        }


        if let attrCredit: CreditAttribute = UserPrefUtil.getCreditAttribute() {
            self.lAvailableCredit.text = attrCredit.creditsAvailable.description;
        } else {
            self.lAvailableCredit.text = "0";
        }

        let arrOfObjs = [CreditAttribute]();

        for credAttr in arrOfObjs {
            switch ((credAttr.name?.description)!) {
            case Names.SMS:
                self.lSmsCount.text = credAttr.creditsAvailable.description;
                break;
            case Names.PATIENTS:
                self.lPatientCount.text = credAttr.creditsAvailable.description;
                break;
            case Names.SHORTCUTS:
//                self.lsho.text = credAttr.creditsAvailable.description;
                break;
            default:
                break;
            }
        }

//

        if (switchRequestEnterprize.isOn) {
            bUpgrade.setTitle("REQUEST", for: .normal);
            self.switchBuy500SMS.isEnabled = false;
            self.switchEnableBackUP.isEnabled = false;
            self.swutchBuyPatientCredits.isEnabled = false;
            self.lRequiredCredits.text = "0"
        } else {
            bUpgrade.setTitle("UPGRADE", for: .normal)
            self.switchBuy500SMS.isEnabled = true;
            self.switchEnableBackUP.isEnabled = true;
            self.swutchBuyPatientCredits.isEnabled = true;

            var creditsRequired = 0;

            if (self.switchBuy500SMS.isOn) {
                creditsRequired = 299;
            }

            if self.switchEnableBackUP.isOn {
                creditsRequired = creditsRequired + 499;
            }

            if self.swutchBuyPatientCredits.isOn {
                self.segment500.isHidden = false;
                switch self.segment500.selectedSegmentIndex {
                case 0:
                    creditsRequired = creditsRequired + 499;
                    break;
                case 1:
                    creditsRequired = creditsRequired + 799;
                    break;
                default:
                    creditsRequired = creditsRequired + 499;
                    break;
                }
            } else {
                self.segment500.isHidden = true;
            }

            self.lRequiredCredits.text = creditsRequired.description;

            if (coupon != nil) {
                if (self.coupon?.voucherType == Names.DISCOUNT_VOUCHER && creditsRequired > 0) {
                    switch (self.coupon?.discountType.description.lowercased())! {
                    case "percentage":
                        let discount: Int = creditsRequired / 100 * Int((self.coupon?.voucherValue)!)!;
                        creditsRequired = creditsRequired - discount;
                        if creditsRequired < 0 {
                            creditsRequired = 0;
                        }

                        break;
                    case "fixed":
                        let discount = Int((self.coupon?.voucherValue)!);
                        creditsRequired = creditsRequired - discount!;
                        if creditsRequired < 0 {
                            creditsRequired = 0;
                        }
                        break;
                    default:
                        print("Voucher code not applicable");
                        break;
                    }
                }
            }

        }


    }

    @IBOutlet weak var lRequiredCredits: UILabel!;

    func apiCallGetAvailablePlans() {
        let url = DAMUrls.urlSubscriptionPlans();
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);

        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[BasicProfileAttributes]>) in
            if (response.response?.statusCode == 200) {
                print(response.result.value?.toJSONString());
            }
        }

    }

}


















