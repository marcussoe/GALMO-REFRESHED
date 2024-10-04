@isTest
private class TaskDATest {
    @isTest
    static void testGetContactTasksByWhoId() {
     
         Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;

        Lead testLead = new Lead(
            LastName = 'Will',
            Company = 'Elera',
            CNPJ__c = '07135796000139',
            Email = 'Willdantas@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead;
        
        testLead.Status = 'Tentativa de contato';
        update testLead;
       
        Task task = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLead.Id
        );
        insert task;
        
        
        
        Set<Id> leadsIds = new Set<Id>{testLead.Id};
        List<Task> result = TaskDA.getContactTasksByWhoId(leadsIds, true);
    }
    @isTest
    static void testGetOpenContactTasksByWhoId() {
      
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
      
        Lead testLead = new Lead(
            LastName = 'Ewerton',
            Company = 'São Paulo Tech School',
            Email = 'ewertonsptech@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '119847643238',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead;
        
          testLead.Status = 'Tentativa de contato';
        update testLead;
        
        
        Task task = new Task(
            Subject = 'Chamada',
            Status = 'Open',
            WhoId = testLead.Id
        );
        insert task;
       
        List<Task> result = TaskDA.getContactTasksByWhoId(new Set<Id>{testLead.Id}, 'Open');
    }
}