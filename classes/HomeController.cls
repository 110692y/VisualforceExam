public with sharing class HomeController {
    public List<Exam__c> exams { get; set; }
    public Exam__c exam { get; set; }
    public Boolean creation { get; set; }

    public void turnOnCreation() {
        creation = true;
    }

    public PageReference save() {
        insert exam;
        PageReference pageRef = new PageReference('/apex/editExam');
        pageRef.getParameters().put('id', exam.Id);
        return pageRef;
    }

    public homeController() {
        exams = [
                SELECT Count_Questions__c,
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OwnerId, Owner.Name,
                        SystemModstamp
                FROM Exam__c
        ];
        exam = new Exam__c();
    }

}