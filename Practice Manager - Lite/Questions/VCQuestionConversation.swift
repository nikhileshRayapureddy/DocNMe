//
// Created by Sandeep Rana on 25/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper

class VCQuestionConversation: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lQuestionTitle: UILabel!
    @IBOutlet weak var t_answerarea: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    var question: QuestionResponse?;

    var arrOfQuestionComments = [QuestionComment]();

    private var dateFormatter: DateFormatter?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Follow Up | " + (self.question?.pregnancyInfo?.name)!;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dateFormatter = Utility.getDateFormatter(dateFormat: "dd MMM yyyy hh:mm a")
        self.getListOfAnswers();
        self.lQuestionTitle.text = question?.question?.title;
    }

    private func getListOfAnswers() {
        app_delegate.showLoader(message: "Fetching answers...")
        let url = DAMUrls.urlGetAListOfAnswers(question: ((self.question?.question)!!));
        let request = ApiServices.createGetRequest(urlStr: url, parameters: []);
        AlamofireManager.Manager.request(request).responseArray {
            (response: DataResponse<[QuestionComment]>) in
            DispatchQueue.main.async {
                app_delegate.removeloder()
                if (response.response?.statusCode == 200) {
                    self.populateData(response.result.value);
                }
            }
        }
    }

    private func populateData(_ data: [QuestionComment]?) {
        self.arrOfQuestionComments.append(contentsOf: data!);
        self.tableView.reloadData();
    }

    @IBAction func onClickSend(_ sender: UIButton) {
        if (t_answerarea.text == "") {
            print("type something")
        } else {
            let url = DAMUrls.urlQuestionCommentAdd();
            let quesComment: QuestionComment = QuestionComment();
            quesComment.questionId = self.question?.question?.id;
            quesComment.comment = t_answerarea.text;
            quesComment.commentdate = Date().millisecondsSince1970;
            let dateAhead = Calendar.current.date(byAdding: .day, value: 1, to:Date());
            quesComment.expirationTime = (dateAhead?.millisecondsSince1970)!;
            quesComment.commentby = Names.CommentType.TYPE_DOCTOR;

            let request = ApiServices.createPostRequest(urlStr: url, parameters: quesComment.toJSON());
            
            sender.isEnabled = false;
            
            AlamofireManager.Manager.request(request).responseObject{
                (response:DataResponse<QuestionComment>) in
                sender.isEnabled = true;
                if (response.response?.statusCode == 200){
                    self.t_answerarea.text = "";
                    self.arrOfQuestionComments.append(response.result.value!);
                    self.tableView.reloadData();
                }
            }

        }
    }

    @IBAction func onClickAttach(_ sender: UIButton) {

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOfQuestionComments.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellQuestionComment = tableView.dequeueReusableCell(
                withIdentifier: Names.VContIdentifiers.CELL_QUESTIONCOMMENT, for: indexPath) as! CellQuestionComment;
        let comment = self.arrOfQuestionComments[indexPath.row];
        cell.lComment?.text = comment.comment;
        cell.lDateTime?.text = self.dateFormatter?.string(from: Date(milliseconds: comment.commentdate));
        return cell;
    }


}
