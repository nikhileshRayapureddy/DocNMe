//
// Created by Sandeep Rana on 15/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class VCListOfCheckboxes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arrOfModels: [CheckModel]?;

    @IBAction func onClickDone(_ sender: UIButton) {

        var chekecItems = [CheckModel]();
        var strSelectedItems = "";
        for it: CheckModel in self.arrOfModels! {
            if it.isChecked! {
                chekecItems.append(it);
                strSelectedItems.append(it.value! + ",");
            }
        }

        if strSelectedItems.hasSuffix(",") {
            strSelectedItems.remove(at: strSelectedItems.index(before: strSelectedItems.endIndex));
        }

        self.delegate?.onResult(self.tag, arrOfModels, chekecItems, strSelectedItems);
        self.navigationController?.popViewController(animated: true);
    }

    @IBOutlet weak var tableView: UITableView!;

    var tag = 0;

    var delegate: OnListOfCheckBoxListeners?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrOfModels?.count)!;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let valu: CheckModel = self.arrOfModels![indexPath.row];

        let cell: CellListOfCheckbox = tableView.dequeueReusableCell(
                withIdentifier: Names.VContIdentifiers.CELL_LISTOFCHECKBOX,
                for: indexPath) as! CellListOfCheckbox;
        cell.lValue?.text = valu.value;
        cell.bemCheckBox?.on = valu.isChecked!;
        cell.bemCheckBox?.tag = indexPath.row;
        cell.bemCheckBox?.delegate = self;

        return cell;

    }
}

extension VCListOfCheckboxes: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        let checkModel = self.arrOfModels?[checkBox.tag]
        checkModel?.isChecked = checkBox.on;
        self.arrOfModels?[checkBox.tag] = checkModel!;
    }
}
