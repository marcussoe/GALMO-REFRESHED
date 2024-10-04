@isTest
public class LeadDATest {
    @isTest
    static void testGetLeadsById() {
      Enterprise__c empreendimento = new Enterprise__c(Name = 'Teste empreendimento',CNPJ__c ='07135796000139');
       insert empreendimento;
        
        
        Lead lead1 = new Lead(
            LastName = 'Silva',
            Company = 'Empresa XYZSantiago',
            Email = 'silva@xyz.com',
            LeadSource = 'Chat',
             CNPJ__c = '07135796000139',
            CanalAtendimento__c = 'Telefone',
            MobilePhone = '11987654321',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert lead1;

        lead1.Status = 'Tentativa de Contato';
        update lead1;

        Lead lead2 = new Lead(
            LastName = 'Santos',
            Company = 'Empresa ABC',
            Email = 'santosfj@gmail.com',
            LeadSource = 'Telefone',
            CanalAtendimento__c = 'Chat',
            MobilePhone = '11960387699',
            Status = 'Novo',
            EmpreendimentoInteresseLead__c = empreendimento.Id
        );
        insert lead2;

        lead2.Status = 'Tentativa de Contato';
        update lead2;

        
        
        Task task1 = new Task(
            Subject = 'Chamada',
            WhoId = lead1.Id,
            ActivityDate = Date.today().addDays(5),
            Status = 'Completed'
        );
        insert task1;

        Task task2 = new Task(
            Subject = 'Chamada',
            WhoId = lead2.Id,
            ActivityDate = Date.today().addDays(-5),
            Status = 'Completed'
        );
        insert task2;

        Set<Id> leadsIds = new Set<Id>{lead1.Id};
        Set<Id> whoIds = new Set<Id>{task1.WhoId};
        Set<String> camposLead = new Set<String>{'Id', 'Status', 'TotalDeAtividadesFaseAtual__c', 'EmpreendimentoInteresseLead__c'};

        LeadDA.getLeadsAgendamentoById(whoIds);
        LeadDA.getLeadsByIds(leadsIds);
        LeadDA.getLeadScheduledById(camposLead, leadsIds);

        Set<Id> leadIds = new Set<Id>{lead1.Id, lead2.Id};

        Test.startTest();
        List<Lead> queriedLeads = LeadDA.getLeadsByIds(leadIds);
        Test.stopTest();

        System.assertEquals(2, queriedLeads.size());
        for (Lead queriedLead : queriedLeads) {
            System.assert(leadIds.contains(queriedLead.Id));
        }
    }
    
     @isTest
    static void testFindPotentialDuplicateLeads() {
        // Crie seus dados de teste
        Map<String, Object> leadParams = new Map<String, Object>{
            'LastName' => 'Silva',
            'MobilePhone' => '123456789',
            'Email' => 'test@example.com',
            'EmpreendimentoInteresseLead__c' => null 
        };
            

        Test.startTest();
        List<Lead> potentialDuplicates = LeadDA.findPotentialDuplicateLeads(leadParams);
        Test.stopTest();

        
        System.assertEquals(0, potentialDuplicates.size(), 'Expected no potential duplicates found');
    }

    @isTest
    static void testFindCampaignByName() {
      
        Campaign testCampaign = new Campaign(Name = 'Test Campaign');
        insert testCampaign;

        Test.startTest();
        Campaign foundCampaign = LeadDA.findCampaignByName('Test Campaign');
        Test.stopTest();

      
        System.assertEquals('Test Campaign', foundCampaign.Name);
    }

    @isTest
    static void testCreateCampaignIfNotExist() {
      
        Test.startTest();
        LeadDA.createCampaignIfNotExist('New Campaign');
        Test.stopTest();

      
        Campaign newCampaign = [SELECT Name FROM Campaign WHERE Name = 'New Campaign'];
        System.assertNotEquals(null, newCampaign, 'New campaign should be created');

       
        
        LeadDA.createCampaignIfNotExist('New Campaign');
   

       
        List<Campaign> existingCampaigns = [SELECT Name FROM Campaign WHERE Name = 'New Campaign'];
        System.assertEquals(1, existingCampaigns.size(), 'Only one campaign with the same name should exist');
    }
}