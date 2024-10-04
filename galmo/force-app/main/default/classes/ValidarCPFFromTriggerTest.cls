@isTest
public class ValidarCPFFromTriggerTest {

   @isTest
static void testTriggerCPFValido() {
   
    Lead lead = new Lead();
    lead.FirstName = 'Test';
    lead.LastName = 'Lead';
    lead.MobilePhone = '11524478599';
    lead.Email = 'silvajoaowill@xyz.com';
    lead.LeadSource = 'Chat';
    lead.CPF__c = '12345678909';
    lead.CanalAtendimento__c = 'Chat'; 
  
    insert lead;
 
    System.assertNotEquals(null, lead.Id);
}


    @isTest
    static void testTriggerCPFInvalido() {
        Lead lead = new Lead();
        lead.FirstName = 'Test';
        lead.LastName = 'Lead';
        lead.CPF__c = '12345678901'; // CPF inválido
        Test.startTest();
        try {
            insert lead;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CPF inválido'));
        }
        Test.stopTest();
        System.assertEquals(null, lead.Id);
    }

}