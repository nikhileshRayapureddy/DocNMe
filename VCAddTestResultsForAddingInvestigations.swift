//
// Created by Sandeep Rana on 26/10/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog
import Toaster

class VCAddTestResultsForAddingInvestigations: UIViewController, UITableViewDelegate, UITableViewDataSource, OnRecordAddedDelegate {
    var onRecordAddedListener: OnRecordAddedDelegate?;

    func onRecordAdded(_ record: [Record]) {
//        self.navigationController?.popViewController(animated: false);
        if self.onRecordAddedListener != nil {
            self.onRecordAddedListener?.onRecordAdded(record);
        }

    }

    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var bDate: UIButton!;

    var arrOfResults = [Result]();

    var personInfo: PersonInfoModel?;


    private var dateFormatter: DateFormatter = Utility.getDateFormatter(dateFormat: "dd/MM/yyyy");

    @IBAction func onClickAddTests(_ sender: UIButton) {
        let vc = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier: Names.VContIdentifiers.VC_ADDRESULT) as! VCAddResult;
        vc.onAddedResult = self;
//        vc.personInfo = self.personInfo;
        self.navigationController?.pushViewController(vc, animated: true);
    }

    @IBAction func onClickNext(_ sender: UIButton) {
        if self.arrOfResults.count < 1 {
            Toast(text: "Add atleast one result").show();
            return;
        }
//        VCTestResultsNextScreen  vc_testresultsnextscreen
        let vc = UIStoryboard(name: Names.STORYBOARD.PERSON_INFO, bundle: nil).instantiateViewController(withIdentifier:
        Names.VContIdentifiers.VC_TESTRESULTSNEXTSCREEN) as! VCTestResultsNextScreen;
        vc.arrOfResults.removeAll();
        vc.arrOfResults.append(contentsOf: self.arrOfResults);
        vc.onRecordAddedDelegate = self;
        vc.personInfo = self.personInfo;
        vc.date = self.dateFormatter.date(from: (self.bDate.titleLabel?.text!)!);
        self.navigationController?.pushViewController(vc, animated: true);

    }

    @IBAction func onClickDate(_ sender: UIButton) {
        DatePickerDialog().show("Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if (date != nil) {
                sender.setTitle(self.dateFormatter.string(from: date!), for: .normal);
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Names.VContIdentifiers.CELL_RESULTS, for: indexPath) as! CellResultsTableView;
        let resul: Result = self.arrOfResults[indexPath.row];
        cell.lName.text = resul.name;
        let resArr = resul.results?.components(separatedBy: "||");
        if (resArr?.count)! > 1 {
            cell.lRange.text = resArr![0] == "1" ? "YES" : "NO";
            cell.lObservations.text = resArr?[1];
            cell.bRemove.tag = indexPath.row;
            cell.bRemove.addTarget(self, action: #selector(self.onRemoveClicked(_:)), for: UIControlEvents.touchUpInside);
        }
        return cell;
    }

    func onRemoveClicked(_ sender: UIButton) {
        self.arrOfResults.remove(at: sender.tag);
        self.tableView.reloadData();
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath);
        if (cell != nil) {
            return cell!.frame.size.height;
        } else {
            return 150;
        }
    }


    func onClickRemoveItem(_ sender: UIButton) {
        self.arrOfResults.remove(at: sender.tag);
        self.tableView.reloadData();
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfResults.count;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }


}

extension VCAddTestResultsForAddingInvestigations: OnResultAddedListener {
    func onAdded(_ result: Result) {
        self.arrOfResults.append(result);
        self.tableView.reloadData();
    }
}
