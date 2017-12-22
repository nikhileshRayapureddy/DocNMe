//
// Created by Sandeep Rana on 09/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Toaster

class VCPay: UIViewController {
    @IBOutlet weak var lInInr: UILabel!
    @IBOutlet weak var lAbountUSD: UILabel!
    
    let minThresHold = 500;
    var amountUSD = 500;
    
    @IBAction func onClickUP(_ sender: UIButton) {
        amountUSD = amountUSD + 500;
        self.updateUI();
    }
    
    @IBAction func onClickDown(_ sender: UIButton) {
        if (amountUSD == self.minThresHold){
            Toast(text: "Reached minimum threshold!").show();
            return;
        }
        amountUSD = amountUSD - 500;
        self.updateUI();
    }
    func updateUI() {
        self.lAmoutnUSD.text = amountUSD.description;
        self.lInInr.text = "INR "+(amountUSD * inrValue).description;
    }
    @IBAction func onClickPay(_ sender: UIButton) {
        
    }
    
    let inrValue = 70;
    
    @IBOutlet weak var lAmoutnUSD: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}
