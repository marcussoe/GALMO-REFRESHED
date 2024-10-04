@IsTest
public class LeadTriggerHandlerTest {
    @TestSetup
    static void makeData(){
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        
   
        Lead testLead1 = new Lead(
            LastName = 'Will',
            Company = 'Elera',
            Email = 'Willdantas@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead1;
        
        testLead1.Status = 'Tentativa de contato';
        update testLead1;
        
        Task task1 = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLead1.Id
        );
        insert task1;
        
        
        
        Task taskOpen1 = new Task(
            Subject = 'Chamada',
            Status = 'Open',
            WhoId = testLead1.Id
        );
        insert taskOpen1;
        
        // Segundo Lead
        Lead testLead2 = new Lead(
            LastName = 'Smith',
            Company = 'Elera',
            Email = 'smith@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387698',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead2;
    }
    

    @isTest
    static void testBeforeUpdate_AdvancingFromAttemptToContact() {
          Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        
        Lead testLead = new Lead(
            LastName = 'Teste',
            Company = 'Empresa Teste',
            Email = 'teste@teste.com',
            LeadSource = 'Teste',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11987654321',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead;

        testLead.Status = 'Tentativa de Contato';
        update testLead;

        Task task = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLead.Id
        );
        insert task;
        
        testLead.Status = 'Contato Realizado';
        update testLead;
      
        testLead.Status = 'Agendamento de Visita';

        Test.startTest();
        update testLead;
        Test.stopTest();
    }
}