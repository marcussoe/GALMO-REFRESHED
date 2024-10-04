public with sharing class LeadDA {
    public static List<Lead> getLeadsAgendamentoById(Set<Id> whoIds) {
        System.debug(whoIds);
        return [SELECT Id, Status FROM Lead WHERE Id IN :whoIds AND  Status = 'Agendamento de Visita'];
    }

    public static List<Lead> getLeadsByIds(Set<Id> idsLeads) {
        return [SELECT Id, EmpreendimentoInteresseLead__c, Status FROM Lead WHERE Id IN :idsLeads];
    }
    
    public static List<Lead> getLeadScheduledById(Set<String> fields, Set<Id> leadsId){
        return Database.query(String.format(
            'SELECT {0} FROM Lead WHERE Id IN :leadsId',
            new String[]{String.join(new List<String>(fields), ',')}
        ));
    }


  
    public static List<Lead> findPotentialDuplicateLeads(Map<String, Object> leadParams) {
        String lastName = (String) leadParams.get('LastName');
        String mobilePhone = (String) leadParams.get('MobilePhone');
        String email = (String) leadParams.get('Email');
        String empreendimentoInteresse = (String) leadParams.get('EmpreendimentoInteresseLead__c');

        return [
            SELECT Id, LastName, MobilePhone, Email, EmpreendimentoInteresseLead__c, 
                LeadSource,ltima_Reitera_o__c, PrimeiraInteracao__c, QuantidadeReiteracoes__c, 
                PrimeiroEmpreendimento__c, UTMOriginalMedia__c, OwnerId
            FROM Lead 
            WHERE LastName = :lastName 
                AND (MobilePhone = :mobilePhone OR Email = :email OR EmpreendimentoInteresseLead__c = :empreendimentoInteresse)
            LIMIT 1
        ];
    }

    
    public static Campaign findCampaignByName(String campaignName) {
        List<Campaign> existingCampaigns = [
            SELECT Id, Name, Type, Status, IsActive 
            FROM Campaign 
            WHERE Name = :campaignName 
            LIMIT 1
        ];
        return existingCampaigns.isEmpty() ? null : existingCampaigns[0];
    }

   
    public static void createCampaignIfNotExist(String campaignName) {
        if (String.isBlank(campaignName)) {
            campaignName = 'Campanha Padrão';
        }
        List<Campaign> existingCampaigns = [
            SELECT Id, Name, Type, Status, IsActive 
            FROM Campaign 
            WHERE Name = :campaignName 
            LIMIT 1
        ];
        if (existingCampaigns.isEmpty()) {
            Campaign campaign = new Campaign(Name = campaignName);
            insert campaign;
        }
    }
}