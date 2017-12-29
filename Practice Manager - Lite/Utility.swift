//
// Created by Sandeep Rana on 24/08/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Dropper

class Utility {

    class func getResolvedBloodGroup(bg: String?) -> String {
        let dictBloodGroups = [
            "": "--",
            "A_POSITIVE": "A +ve",
            "A_NEGATIVE": "A -ve",
            "b_POSITIVE": "B +ve",
            "B_NEGATIVE": "B -ve",
            "AB_POSITIVE": "AB +ve",
            "AB_NEGATIVE": "AB -ve",
            "O_POSITIVE": "O +ve",
            "O_NEGATIVE": "O -ve"];
        if bg != nil {
            return dictBloodGroups[bg!]!;
        } else {
            return "--";
        }

    }

    static func getDateFormatter(dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = dateFormat;
        dateFormatter.locale = Locale(identifier: "UTC");
        //        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter;
    }

    class func showProgressForIndicator(_ indicator: UIActivityIndicatorView!, _ isProgress: Bool) {

//        indicator.isHidden = !isProgress;
//
//        if isProgress {
//            indicator.startAnimating();
//        } else {
//            indicator.stopAnimating();
//        }
//

    }


    class func buttonVisibilityAndShow(_ sender: UIButton, title: String, isEnabled: Bool) {
        sender.isEnabled = isEnabled;
        sender.setTitle(title, for: .normal);

    }

    class func calculateAgefromDOB(_ dob: String?) -> String? {
        if dob != nil {
            let formatter = getDateFormatter(dateFormat: "yyyy-MM-dd");

            let ageComponent = Calendar.current.dateComponents([.year], from: formatter.date(from: dob!)!, to: Date())
            let age = ageComponent.year!
            return age.description;
        } else {
            return nil;
        }
    }

    class func calculateGestAge(_ timeInMillis: Int64) -> String? {
        if timeInMillis > 0 {
            let date = Date(milliseconds: timeInMillis);
            let dayComponent = Calendar.current.dateComponents([.day], from: date, to: Date())
            let days = dayComponent.day!
            let strTime = "\(abs(days / 7))W \(abs(days % 7))D";
            return strTime;
        } else {
            return nil;
        }
    }

    class func getTimeComponent(_ date: Date?) -> String? {
        if date != nil {
            var ageComponent = Calendar.current.dateComponents([.year], from: date!, to: Date())
            let age = ageComponent.year! * -1;

            if age > 0 {
                return age.description + " years"
            }

            ageComponent = Calendar.current.dateComponents([.month], from: date!, to: Date())
            let month = ageComponent.month! * -1;
            if month > 0 {
                return month.description + " months"
            }

            ageComponent = Calendar.current.dateComponents([.day], from: date!, to: Date())
            let day = ageComponent.day! * -1;
            if day > 0 {
                return day.description + " days"
            }
            ageComponent = Calendar.current.dateComponents([.hour], from: date!, to: Date())
            let hours = ageComponent.hour! * -1;
            if hours > 0 {
                return hours.description + " hours"
            }
            ageComponent = Calendar.current.dateComponents([.minute], from: date!, to: Date())
            let minutes = ageComponent.minute! * -1;
            if minutes > 0 {
                return minutes.description + " minutes"
            }
            return "soon";
        } else {
            return nil;
        }
    }

    class func needToOpenFill(_ clin: ClinicDetailResponse?) -> Bool {
        var name = "";
        var address1 = "";
        var country = "";

        if clin != nil && clin?.clinic != nil {
            name = (clin?.clinic?.name!)!;
            if (clin?.personInfo != nil) {
                if clin?.personInfo?.address2 != nil {
                    address1 = (clin?.personInfo!.address2!)!;
                }
                if clin?.clinicLocation?.country != nil {
                    country = (clin?.clinicLocation!.country!)!;
                }
            }
        }

        if (name.isEmpty || address1.isEmpty || country.isEmpty) {
            return true;
        } else {
            return false;
        }
    }

    class func hideDropper(_ dropper: Dropper?) {
        if dropper != nil {
            dropper?.hide();
        }
    }
}
