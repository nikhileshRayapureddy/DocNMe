//
// Created by Sandeep Rana on 21/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class VCQuestions: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var arrOfQuestionResp = [QuestionResponse]();
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    private var allQuestions = [QuestionResponse]();

    var formatter: DateFormatter?;
    @IBOutlet weak var tableView: UITableView!;
    @IBOutlet weak var segmentView: UISegmentedControl!


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfQuestionResp.count;
    }

    func filterSegmentAndReload() {
        self.arrOfQuestionResp.removeAll();
        for quest in self.allQuestions {
            if (eligibleToAdd(quest, self.segmentView.selectedSegmentIndex)) {
                arrOfQuestionResp.append(quest);
            }
        }
        self.tableView.reloadData();
    }


    private func eligibleToAdd(_ quest: QuestionResponse, _ index: Int) -> Bool {
        switch index {
        case 0:
            if (quest.question?.category == "6") {
                return true;
            } else {
                return false;
            }

        case 1:
            if (quest.question?.category == "12") {
                return true;
            } else {
                return false;
            }

        case 2:
            if (quest.question?.category == "24") {
                return true;
            } else {
                return false;
            }


        default:
            return true;

        }
    }

    @IBAction func onSegmentSelectionChanged(_ sender: Any) {
        self.filterSegmentAndReload();
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellTableViewQuestions = tableView.dequeueReusableCell(
                withIdentifier: Names.VContIdentifiers.CELL_QUESTIONSLIST, for: indexPath) as! CellTableViewQuestions;
        let questionResp = self.arrOfQuestionResp[indexPath.row];
        let pregPInfo = questionResp.pregnancyInfo;
        cell.lTitle.text = pregPInfo?.name;
        var strStatus = "";
        if let ms = pregPInfo?.mstatus {
            switch ms {
            case Names.StatusMarriage.MARRIED:
                strStatus = "Married | ";
                break;
            case Names.StatusMarriage.DIVORCED:
                strStatus = "Divorced | ";
                break;
            case Names.StatusMarriage.WIDOW:
                strStatus = "Widow | ";
                break;
            default: //single
                strStatus = "Single | ";
                break;
            }
        }

        if let age = Utility.calculateAgefromDOB(pregPInfo?.dob) {
            strStatus = strStatus + age;
        }

        if let bg = pregPInfo?.bloodgroup {
            strStatus = strStatus + " | " + Utility.getResolvedBloodGroup(bg: bg);
        }

        if let gen = pregPInfo?.gender {
            switch gen {
            case Names.Gender.MALE:
                strStatus = strStatus + " | Male";
                break;
            case Names.Gender.FEMALE:
                strStatus = strStatus + " | Female";
                break;
            default:
                strStatus = strStatus + " | Other";
                break;
            }
        }

        if (questionResp.question?.expirationTime != nil && questionResp.question?.expirationTime != 0) {
            let date = Date(milliseconds: (questionResp.question?.expirationTime)!);
            if let strDat = Utility.getTimeComponent(date) {
                cell.lExpiresIn.text = "Expires in " + strDat;
            }

        }


        cell.lMStatusAgeBloodGroup.text = strStatus;
        cell.lQuestionTitle.text = questionResp.question?.title;
        cell.lDateAndTime.text = self.formatter?.string(from: Date(milliseconds: (questionResp.question?.createdDate)!));


        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row at");
        tableView.deselectRow(at: indexPath, animated: false);
        let vc: VCQuestionConversation = self.storyboard!.instantiateViewController(
                withIdentifier: Names.VContIdentifiers.VC_QUESTIONCONVERSATION) as! VCQuestionConversation;
        vc.question = self.arrOfQuestionResp[indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.formatter = Utility.getDateFormatter(dateFormat: "dd-MM-yyyy");
        self.apiCallGetQuestionsList();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.title = "Questions";
    }

    private func apiCallGetQuestionsList() {
        self.updateFromDatabase();
        app_delegate.showLoader(message: "Fetching Questions...")
        let url = DAMUrls.urlQuestionsListAll(doctorId: UserPrefUtil.getPersonIdClinic()!);
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[QuestionResponse]>) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                if (response.response?.statusCode == 200) {
                    //                self.populateData(response.result.value);
                    self.checkAndWriteToData(response.result.value!);
                }
            }
        }
    }


    let realm = try? Realm();

    private func checkAndWriteToData(_ value: [QuestionResponse]) {
        try? realm?.write({
            for item in value {
                let res = self.realm?.objects(QuestionResponse.self).filter("questionId = '\(item.questionId)'").first;
                if res == nil {
                    let question = QuestionResponse();
                    question.questionId = item.questionId;
                    question.personId = item.personId;
                    question.personPregnancyProfile = item.personPregnancyProfile;
                    question.pregnancyInfo = item.pregnancyInfo;
                    realm?.add(question);

                    let quest = self.realm?.objects(Question.self).filter("id = '\(question.questionId)'").first;
                    if (quest == nil) {
                        realm?.add(item.question!);
                    }

                    let resPers = self.realm?.objects(PersonPregnancyProfile.self).filter("personId = '\((item.personId))'").first;
                    if (resPers == nil && item.pregnancyInfo != nil) {
                        realm?.add(item.pregnancyInfo!);
                    }

                    let resPreg = self.realm?.objects(PregnancyInfo.self).filter("id = '\((item.personId))'").first;

                    if (resPreg == nil && item.personPregnancyProfile != nil) {
                        realm?.add(item.personPregnancyProfile!);
                    }

                } else {
                    res?.questionId = item.questionId;
                    let res = self.realm?.objects(Question.self).filter("id = '\((item.questionId))'").first;
                    if (res == nil) {
                        realm?.add(item.question!);
                    }

                    let resPers = self.realm?.objects(PersonPregnancyProfile.self).filter("personId = '\((item.personId))'").first;
                    if (resPers == nil) {
                        realm?.add(item.personPregnancyProfile!);
                    }
                    let resPregInfo = self.realm?.objects(PregnancyInfo.self).filter("id = '\((item.personId))'").first;
                    if (resPregInfo == nil) {
                        realm?.add(item.pregnancyInfo!);
                    }
                }

            }
        })
        self.updateFromDatabase();
    }

    private func updateFromDatabase() {

        let results = realm?.objects(QuestionResponse.self);
        var arrOfQuestionResponse = [QuestionResponse]();
        if (results != nil) {
            for item in results! {
                let questRespo = QuestionResponse();
                let quest = realm?.objects(Question.self).filter("id = '\(item.questionId)'").first;
                let pregnancy = realm?.objects(PersonPregnancyProfile.self).filter("personId = '\(item.personId)'").first;
                let pregnancyInfo = realm?.objects(PregnancyInfo.self).filter("id = '\(item.personId)'").first;

                if (quest != nil) {
                    questRespo.question = quest!;
                    questRespo.questionId = (quest?.id!)!;
                }
                if (pregnancy != nil) {
                    questRespo.personPregnancyProfile = pregnancy!;
                }

                if (pregnancyInfo != nil) {
                    questRespo.pregnancyInfo = pregnancyInfo!;
                    questRespo.personId = (pregnancyInfo?.id!)!;
                }

                arrOfQuestionResponse.append(questRespo);
            }
        }

        self.populateData(arrOfQuestionResponse);
    }

    private func populateData(_ value: [QuestionResponse]?) {
//        let results = self.realm.objects(Question.self).filter();

        self.allQuestions.removeAll();
        self.allQuestions.append(contentsOf: value!);
        self.filterSegmentAndReload();
    }


}
