//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print(str);
let formatter: DateFormatter = DateFormatter();
formatter.dateFormat = "dd MM yyyy";
formatter.timeZone = Calendar.current.timeZone;
formatter.locale = Calendar.current.locale;

let startDate = formatter.date(from: "01 01 2000");
let endDate = formatter.date(from: "01 01 2010");
print(startDate)