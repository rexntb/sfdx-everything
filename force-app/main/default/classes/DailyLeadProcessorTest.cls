@isTest
private class DailyLeadProcessorTest {

    public static String cronExp = '0 0 0 15 1 ? 2020';

    @isTest
    static void testScheduledJob() {
        // 1. Insert 200 leads
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(FirstName = 'Diana', 
                                LastName = 'Prince' + i, 
                                 Company = 'Justice League'));
        }
        insert leads;

        // Get the IDs of the inserted leads
        Map<Id, Lead> leadMap = new Map<Id, Lead>(leads);
        List<Id> leadIds = new List<Id>(leadMap.keySet());
        String jobName = 'ScheduledApexTest';
        DailyLeadProcessor schedulable = new DailyLeadProcessor();

        // 2. Schedule the DailyLeadProcessor class to run
        Test.startTest();
        String jobId = System.schedule(jobName, cronExp, schedulable);
        // Verify the scheduled job has not run yet.
        List<Lead> leadsCheck = [SELECT Id
                                   FROM Lead
                                  WHERE LeadSource = 'Dreamforce'
                                    AND Id IN :leadIds];
        System.assertEquals(0, leadsCheck.size(), 'Leads were updated before the job has run!');
        Test.stopTest();

        // 3. Test that all Lead records were updated correctly
        List<Lead> updatedLeads = [SELECT Id
                                     FROM Lead
                                    WHERE LeadSource = 'Dreamforce'
                                      AND Id IN :leadIds];
        System.assertEquals(200, updatedLeads.size(), 'Leads were not created!');
    }
}
