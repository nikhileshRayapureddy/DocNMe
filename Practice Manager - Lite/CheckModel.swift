//
// Created by Sandeep Rana on 15/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation

class CheckModel {
    var key: Int?;
    var value: String?;
    var isChecked: Bool?;

    func setFields(_ key: Int, _ value: String, _ checked: Bool) {
        self.key = key;
        self.value = value;
        self.isChecked = checked;
    }
}
