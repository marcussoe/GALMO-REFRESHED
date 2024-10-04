@isTest
public class TaskTriggerHandlerTest {
    @isTest
    static void testBeforeInsert() {

       
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        
        Lead lead = new Lead(
            LastName = 'Paulo',
            Company = 'Elera',
            Email = 'pauloelera123@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo', 
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert lead;

      
        lead.Status = 'Tentativa de contato';
        update lead;
        
        Task task = new Task(
            WhoId = lead.Id,
            Subject = 'Chamada',
            Status = 'Not Started',
            ActivityDate = Date.today().addDays(5)
        );

        Test.startTest();
        insert task;
        Test.stopTest();

       
        Task updatedTask = [SELECT Id, ActivityDate FROM Task WHERE Id = :task.Id];
        System.assertEquals(Date.today().addDays(5), updatedTask.ActivityDate);
    }

    @isTest
    static void testBeforeUpdate() {
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        
        Lead lead = new Lead(
            LastName = 'Paulo',
            Company = 'Elera',
            Email = 'pauloelera123@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert lead;

        lead.Status = 'Tentativa de contato';
        update lead;
        
        Task task = new Task(
            WhoId = lead.Id,
            Subject = 'Chamada',
            Status = 'Not Started',
            ActivityDate = Date.today().addDays(5)
        );
        insert task;

        
        task.ActivityDate = Date.today().addDays(10);

        Test.startTest();
        update task;
        Test.stopTest();

       
        Task updatedTask = [SELECT Id, ActivityDate FROM Task WHERE Id = :task.Id];
        System.assertEquals(Date.today().addDays(10), updatedTask.ActivityDate);
    }
}