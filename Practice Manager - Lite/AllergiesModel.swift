//
//  AllergiesModel.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 14/10/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift

public class AllergiesModel: Object {
    dynamic var name: String?;

    override public static func indexedProperties() -> [String] {
        return ["name"]
    }
}

public class MedicineModel: Object {
    dynamic var name: String?;

    override public static func indexedProperties() -> [String] {
        return ["name"]
    }
}

