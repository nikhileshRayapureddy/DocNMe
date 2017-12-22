//
// Created by Sandeep Rana on 05/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class VCChangePassword: UIViewController {

    @IBOutlet weak var eOldPassword: UITextField!;
    @IBOutlet weak var eNewPassword: UITextField!;
    @IBOutlet weak var eConfirmPassword: UITextField!;

    @IBAction func onClickUpdatePassword(_ sender: UIButton) {
        if ((self.eNewPassword.text?.characters.count)! < 6) {
            Toast(text: "password must be 6 characters long").show();
            return;
        }

        var params = [String: Any]();
        params["password"] = eNewPassword.text;
        params["existingPassword"] = eOldPassword.text;

        let url = DAMUrls.urlChangePassword();
        let request = ApiServices.createPostRequest(urlStr: url, parameters: params);
        AlamofireManager.Manager.request(request).responseString() {
            response in
            if response.response?.statusCode == 200 {
                print(response.result.value)
                Toast(text: "😉 Password successfully changed! ❤️").show();
                self.navigationController?.popViewController(animated: true);
            }else {
                print(response.result.value)
                Toast(text: response.result.value).show();
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
