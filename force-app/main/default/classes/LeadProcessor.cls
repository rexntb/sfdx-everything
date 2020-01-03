global class LeadProcessor implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Id, LeadSource ' +
            'FROM Lead'
        );
    }
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        List<Lead> leadsList = new List<Lead>();
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
            leadsList.add(l);
        }
        update leadsList;
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                                   JobItemsProcessed,
                                   TotalJobItems, CreatedBy.Email
                              FROM AsyncApexJob
                             WHERE Id = :bc.getJobId()];
        String address = job.CreatedBy.Email;
        String subject = 'Lead batch job result';
        String body = 'The batch job with Id ' + job.Id + ' has a status of ' 
                    + job.Status + '. It had ' + job.NumberOfErrors + ' errors out of '
                    + job.JobItemsProcessed + ' items processed. Total job items = '
                    + job.TotalJobItems + '.';
        String[]  addresses = new String[]{},
                   subjects = new String[]{},
                   messages = new String[]{};
        addresses.add(address);
        subjects.add(subject);
        messages.add(body);
        EmailUtils em = new EmailUtils();
        em.sendMail(addresses, subjects, messages);
    }
}
