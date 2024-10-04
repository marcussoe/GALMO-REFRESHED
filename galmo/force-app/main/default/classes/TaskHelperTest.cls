@IsTest
public class TaskHelperTest {
    
    @TestSetup
    static void makeData(){
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        
        BusinessSettings__c slaConfig = new BusinessSettings__c(
            Step__c = 'Novo',
            SlaTime__c = 1 
        );
        insert slaConfig;
        
        Lead testLead = new Lead(
            LastName = 'Will',
            Company = 'Elera',
            Email = 'Willdantas@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id,
            ConfiguracaoDeSLA__c = slaConfig.Id
        );
        insert testLead;
        
         
        testLead.Status = 'Tentativa de contato';
        update testLead;
        
        Task testTask = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLead.Id,
            ActivityDate = Date.today().addDays(-1) 
        );
        insert testTask;
    }
    
    @IsTest
    static void testValidateTaskDate() {
        Task testTaskPast = [SELECT Id, ActivityDate, WhoId FROM Task LIMIT 1];
        Task testTaskPresent = new Task(
            Subject = 'Chamada Presente',
            Status = 'Completed',
            WhoId = testTaskPast.WhoId,
            ActivityDate = Date.today()
        );
        Task testTaskFuture = new Task(
            Subject = 'Chamada Futura',
            Status = 'Completed',
            WhoId = testTaskPast.WhoId,
            ActivityDate = Date.today().addDays(1)
        );
        
        Test.startTest();
        TaskHelper.validateTaskDate(new List<Task>{testTaskPast, testTaskPresent, testTaskFuture});
        Test.stopTest();
        
       
    }
    
    @IsTest
    static void testValidateTaskDateNullSlaConfig() {
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;
        Lead testLeadSLA = new Lead(
            LastName = 'Will',
            Company = 'EleraCompany',
            Email = 'saladacebola@example.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960557699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLeadSLA;
        
         
        testLeadSLA.Status = 'Tentativa de contato';
        update testLeadSLA;
        
        
        Task testTask = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLeadSLA.Id,
            ActivityDate = Date.today().addDays(-1)
        );
        insert testTask;
        
        Test.startTest();
        TaskHelper.validateTaskDate(new List<Task>{testTask});
        Test.stopTest();
        
      
    }
}