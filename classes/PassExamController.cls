public with sharing class PassExamController {
    public Exam__c exam { get; set; }
    public List<Question__c> questions { get; set; }
    public PassedExam__c passedExam { get; set; }
    public Boolean passed { get; set; }
    public String questionIdChosen { get; set; }

    public PassExamController() {
        loadData();
        passedExam = new PassedExam__c(Question_Number__c = 1, Exam__c = exam.Id, Count_correct_answers__c = 0, Name = '' + exam.Name + ' - ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' - ' + System.now(), UserInput__c = '');
        passed = false;
    }

    public void loadData() {
        exam = [
                SELECT Count_Questions__c, Id, Name
                FROM Exam__c
                WHERE Id = :apexpages.currentpage().getparameters(). get ('id')
        ];
        questions = [
                SELECT AnswerA__c, AnswerB__c, AnswerC__c, AnswerD__c, CorrectAnswer__c, Exam__c,
                        Id, Name, Question__c
                FROM Question__c
                WHERE Exam__r.Id = :exam.Id
        ];
    }

    public pageReference checkAnswer() {
        if (questionIdChosen == null) {
            return null;
        }
        if (passedExam.Question_Number__c < questions.size()) {
            for (Question__c question : questions)
                if (question.Id == questionIdChosen) {
                    if (question.CorrectAnswer__c == passedExam.UserInput__c) {
                        passedExam.Count_correct_answers__c = passedExam.Count_correct_answers__c + 1;
                    }
                }
            passedExam.Question_Number__c = passedExam.Question_Number__c + 1;
            upsert passedExam;
        } else if (passedExam.Question_Number__c == questions.size()) {
            passedExam.Count_correct_answers__c = passedExam.Count_correct_answers__c + 1;
            passed = true;
        }
        passedExam.UserInput__c = '';
        return null;
    }

    public void save() {
        passed = true;
        upsert passedExam;
    }

    public PageReference goHome() {
        PageReference pageref = new PageReference('/apex/Home');
        return pageref;
    }

}