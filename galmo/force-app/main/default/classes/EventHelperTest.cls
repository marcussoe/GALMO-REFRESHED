@isTest
public class EventHelperTest {

    @TestSetup
    static void makeData(){
        doCreateData();
    }

    private static void doCreateData(){
        Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
       insert empreendimento;
     
        Lead testLeadNovo = new Lead(
            LastName = 'Silva',
            Company = 'Empresa XYZSantiago',
            Email = 'silva@xyz.com',
            LeadSource = 'Chat',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11987654321',
            Status = 'Novo', 
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );

        
        insert testLeadNovo;

    
        testLeadNovo.Status = 'Tentativa de Contato';
        update testLeadNovo;

       
        Task taskNovo = new Task(
            Subject = 'Chamada',
            Status = 'Open',
            WhoId = testLeadNovo.Id
        );
        insert taskNovo;

        taskNovo.Status = 'Completed';

        update taskNovo;

        testLeadNovo.Status = 'Contato Realizado';
        update testLeadNovo;
        
        
        
        testLeadNovo.Status = 'Agendamento de Visita';
        update testLeadNovo;
        


        Lead testLeadNovo2 = new Lead(
            LastName = 'Santos',
            Company = 'Empresa Santos',
            Email = 'santos@email.com',
            LeadSource = 'Chat',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11943354474',
            Status = 'Novo', 
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );

        insert testLeadNovo2;

    
        testLeadNovo2.Status = 'Tentativa de Contato';
        update testLeadNovo2;

       
        Task taskNovo2 = new Task(
            Subject = 'Chamada',
            Status = 'Open',
            WhoId = testLeadNovo2.Id
        );
        insert taskNovo2;

        taskNovo2.Status = 'Completed';
        update taskNovo2;

        testLeadNovo2.Status = 'Contato Realizado';
        update testLeadNovo2;

        testLeadNovo2.Status = 'Agendamento de Visita';
        update testLeadNovo2;


        Lead testLeadNovo3 = new Lead(
            LastName = 'Lopes',
            Company = 'Empresa Lopes',
            Email = 'Lopes@email.com',
            LeadSource = 'Chat',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11943354412',
            Status = 'Novo', 
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );

        
        insert testLeadNovo3;

    
        testLeadNovo3.Status = 'Tentativa de Contato';
        update testLeadNovo3;

       
        Task taskNovo3 = new Task(
            Subject = 'Chamada',
            Status = 'Open',
            WhoId = testLeadNovo3.Id
        );
        insert taskNovo3;

        taskNovo3.Status = 'Completed';

        update taskNovo3;

        testLeadNovo3.Status = 'Contato Realizado';
        update testLeadNovo3;
        testLeadNovo3.Status = 'Agendamento de Visita';
        update testLeadNovo3;
    }
    
    
    
    
    
    
    

    @IsTest
    public static void validateEventDateTest(){
        List<Lead> leads = [SELECT Id, Status FROM Lead];

        System.debug('leads' + leads);
        
        List<Event> events = new List<Event>{
            new Event(
                WhoId = leads[0].Id,
                Subject = 'Visita',
                ActivityDate = Date.today().addDays(5),
                DurationInMinutes = 8,
                StatusCompromisso__c = 'Realizada com Sucesso',
                ActivityDateTime = Datetime.now()
            )
        };

        Test.startTest();
        
        EventHelper.validateEventDate(events);
        
        Test.stopTest();

        System.assert(!events.get(0).hasErrors());
    }


    @IsTest
    public static void validadeLeadStatusTest(){
        List<Lead> leads = [SELECT Id, Status FROM Lead];

        List<Event> events = new List<Event>{
            new Event(
                WhoId = leads[1].Id,
                Subject = 'Visita',
                DurationInMinutes = 8,
                StatusCompromisso__c = 'Realizada com Sucesso',
                ActivityDateTime = Datetime.now()
            )
        };
        insert events;
        
        List<Event> ev = [SELECT WhoId, Subject, DurationInMinutes, StatusCompromisso__c, ActivityDate, MotivoVisitaNaoRealizada__c FROM Event];

        Test.startTest();
        
        EventHelper.validateLeadStatus(events);
        
        Test.stopTest();

        System.assert(events.get(0).hasErrors());
    }


    @isTest
    public static void validateEventStatusTest(){
        List<Lead> leads = [SELECT Id, Status FROM Lead];

        System.debug('leads' + leads);
        
        List<Event> events = new List<Event>{
            new Event(
                WhoId = leads[0].Id,
                Subject = 'Visita',
                DurationInMinutes = 8,
                StatusCompromisso__c = 'Realizada com Sucesso',
                ActivityDateTime = Datetime.now()
            ),
            new Event(
                WhoId = leads[2].Id,
                Subject = 'Visita',
                DurationInMinutes = 8,
                StatusCompromisso__c = 'Não Realizada',
                MotivoVisitaNaoRealizada__c = 'Fora da cidade',
                ActivityDateTime = Datetime.now()
            )
        };
        insert events;
        
        List<Event> ev = [SELECT WhoId, Subject, DurationInMinutes, StatusCompromisso__c, ActivityDate, MotivoVisitaNaoRealizada__c FROM Event];

        Test.startTest();
        
        EventHelper.validateEventStatus(ev);
        
        Test.stopTest();

        System.assert(!ev.get(0).hasErrors());
    }

}