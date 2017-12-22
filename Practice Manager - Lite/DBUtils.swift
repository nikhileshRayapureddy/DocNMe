//
// Created by Sandeep Rana on 15/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import RealmSwift

public class DBUtils {
    public static var stringAllergies: [String]?;
    public static let config = Realm.Configuration(
            // Get the URL to the bundled file
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            // Open the file in read-only mode as application bundles are not writeable
            readOnly: true)

    public static func getStringAllergies() -> [String] {
        if stringAllergies != nil {
            return stringAllergies!;
        } else {

            do {
                // This solution assumes  you've got the file in your bundle
                if let path = Bundle.main.path(forResource: "allergies", ofType: "txt") {
                    let data = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                    stringAllergies = data.components(separatedBy: "\n")
                }
            } catch let err as NSError {
                print(err)
            }
            if stringAllergies == nil {
                stringAllergies = [String]();
            }
            return stringAllergies!;

        }
    }

}
