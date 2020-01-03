global class DailyLeadProcessor implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        // 1. Find the first 200 leads with a blank LeadSource
        List<Lead> leadsWithNoLeadSource = [SELECT Id, LeadSource
                                              FROM Lead
                                             WHERE LeadSource = null
                                             LIMIT 200];

        // 2. Update them with a LeadSource of 'Dreamforce'
        for (Lead lead : leadsWithNoLeadSource) {
            lead.LeadSource = 'Dreamforce';
        }
        update leadsWithNoLeadSource;
    }
}
