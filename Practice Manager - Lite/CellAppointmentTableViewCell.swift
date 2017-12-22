//
//  CellAppointmentTableViewCell.swift
//  Practice Manager - Lite
//
//  Created by Sandeep Rana on 23/08/17.
//  Copyright © 2017 DocNMe. All rights reserved.
//

import UIKit

class CellAppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var l_patientname: UILabel!;

    @IBOutlet weak var l_gender: UILabel!;

    @IBOutlet weak var l_purpose: UILabel!;

    @IBOutlet weak var l_time: UILabel!;
    @IBOutlet weak var lGestAge: UILabel!;
    @IBOutlet weak var iAvatar: UIImageView!;


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
