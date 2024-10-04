@IsTest
public class EventeDATest {
    @isTest
    static void testGetAllEventByLead(){
 
        
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
        insert empreendimento;

        
        Lead testLead = new Lead(
            LastName = 'Silva',
            Company = 'Empresa XYZ',
            Email = 'silva@gmail.com',
            LeadSource = 'Chat',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11987654321',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert testLead;

        
        testLead.Status = 'Tentativa de contato';
        update testLead;

    
        Task testTask = new Task(
            Subject = 'Chamada',
            Status = 'Completed',
            WhoId = testLead.Id,
            ActivityDate = Date.today()
        );
        insert testTask;

        testLead.Status = 'Contato Realizado';
        update testLead;
        
        
       
        testLead.Status = 'Agendamento de visita';
        update testLead;

       
        Event testEvent = new Event(
            WhoId = testLead.Id,
            Subject = 'Visita',
            DurationInMinutes = 30,
            ActivityDateTime = Datetime.now()
        );
        insert testEvent;

       
        Set<Id> leadsIds = new Set<Id>{testLead.Id};
        List<Event> result = EventDA.getAllEventByLead(leadsIds);

    
       
    }
}