//
// Created by Sandeep Rana on 21/09/17.
// Copyright (c) 2017 DocNMe. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class QuestionResponse: Object, Mappable {

    dynamic var questionId = "";
    dynamic var personId = "";

    var question: Question?;
    var personPregnancyProfile: PersonPregnancyProfile?;
    var pregnancyInfo: PregnancyInfo?;


    required convenience init?(map: Map) {
        self.init();
    }

    func mapping(map: Map) {
        question <- map["question"];
        personPregnancyProfile <- map["personPregnancyProfile"];
        pregnancyInfo <- map["personPregnancyInfo"];
        self.questionId = (self.question?.id!)!;
        self.personId = (pregnancyInfo?.id!)!;
    }
}

