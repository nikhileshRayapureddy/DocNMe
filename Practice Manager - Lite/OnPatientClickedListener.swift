//
// Created by Sandeep Rana on 20/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation

protocol OnPatientClickedListener {

    func onPatientClicked(_ patient: Patient, _ path: IndexPath);
}
