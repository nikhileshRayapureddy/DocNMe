//
// Created by Sandeep Rana on 15/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation

protocol OnListOfCheckBoxListeners {
    func onResult(_ tag: Int, _ models: [CheckModel]?, _ checkedModels: [CheckModel]?, _ stringOfSel: String?)
}
