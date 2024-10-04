@isTest
private class RoletaLeadsTriggerHandlerTest {
    
   
    @isTest
    static void testAfterInsert() {
    
        RoletaLeads__c roleta = new RoletaLeads__c(Name = 'Roleta Teste After Insert', HoraInicio__c = Time.newInstance(10, 0, 0, 0), HoraFim__c = Time.newInstance(10, 30, 0, 0));
        
        Test.startTest();
        insert roleta;
        Test.stopTest();
        
       
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Limpar Participantes da Roleta%'];
        System.assertEquals(1, cronTriggers.size(), 'Deveria haver exatamente um job agendado após a inserção da roleta.');
    }
    
   
    @isTest
    static void testAfterUpdate() {
        
        RoletaLeads__c roleta = new RoletaLeads__c(Name = 'Roleta Teste After Update', HoraInicio__c = Time.newInstance(10, 0, 0, 0), HoraFim__c = Time.newInstance(10, 30, 0, 0));
        insert roleta;
        
       
        roleta.HoraFim__c = Time.newInstance(11, 0, 0, 0);
        
        Test.startTest();
        update roleta;
        Test.stopTest();
        
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Limpar Participantes da Roleta%'];
        System.assertEquals(1, cronTriggers.size(), 'Deveria haver exatamente um job agendado após a atualização da roleta.');
    }
}