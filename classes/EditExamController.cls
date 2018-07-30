public with sharing class EditExamController {
    public Exam__c exam { get; set; }
    public Question__c newQuestion { get; set; }
    public List<Question__c> questions { get; set; }

    public editExamController() {
        Id examId = apexpages.currentpage().getparameters(). get ('id');
        exam = [
                SELECT
                        Count_Questions__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId,
                        SystemModstamp
                FROM Exam__c
                WHERE ID = :examId
        ];
        loadQuestions();

    }

    public void addQuestion() {
        save();
        newQuestion = new Question__c(Exam__c = exam.Id);
        insert newQuestion;
        loadQuestions();
    }

    public void save() {
        if (!questions.isEmpty()) {
            upsert questions;
        }
    }

    public PageReference passExam() {
        save();
        PageReference pageRef = new PageReference('/apex/passExam');
        pageRef.getParameters().put('id', exam.Id);
        return pageRef;
    }

    public void loadQuestions() {
        questions = [
                SELECT
                        AnswerA__c,
                        AnswerB__c,
                        AnswerC__c,
                        AnswerD__c,
                        CorrectAnswer__c,
                        CreatedById,
                        CreatedDate,
                        Exam__c,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        Question__c,
                        SystemModstamp
                FROM Question__c
                WHERE Exam__c = :exam.Id
        ];
    }
}