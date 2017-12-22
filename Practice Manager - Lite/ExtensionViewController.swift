//
//  ExtensionViewController.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 01/09/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showInternetConnectionAlertDialog() {
        let Alert = UIAlertController(title: "Failed!", message: "Please check your Internet Connection!", preferredStyle: UIAlertControllerStyle.alert)
        Alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        self.present(Alert, animated: true, completion: nil)
    }

    func showCustomAlert(title: String, message: String) {

        let Alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        Alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
        self.present(Alert, animated: true, completion: nil)
    }

    func isValidButton(view: UIButton?) -> Bool {
        if (view != nil) {
            if (view?.titleLabel?.text != nil && view?.titleLabel?.text != "") {
                return true;
            }
        }
        return false;
    }

    func isValidField(view: UITextField?) -> Bool {
        if (view != nil) {
            if (view?.text != nil && (view?.text != "")) {
                return true;
            }
        }
        return false;
    }


//    func analyzeErrorResponseAndTakeAction() {
//        let Alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        Alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
//            print("Click of cancel button")
//        }))
//        self.present(Alert, animated: true, completion: nil)
//    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UILabel {
    func setHTML(html: String) {
        do {
            let at : NSAttributedString = try NSAttributedString(data: html.data(using: .utf8)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil);
            self.attributedText = at;
        } catch {
            self.text = html;
        }
    }
}
