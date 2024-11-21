@isTest
private class ChecklistDATest {
    
    @TestSetup
    static void setup() {
        Documentacao__c docMandatory1 = new Documentacao__c(Name = 'Documento Obrigatório 1', Obrigatorio__c = true, Entregue__c = false);
        Documentacao__c docMandatory2 = new Documentacao__c(Name = 'Documento Obrigatório 2', Obrigatorio__c = true, Entregue__c = false);
        Documentacao__c docOptional1 = new Documentacao__c(Name = 'Documento Opcional 1', Obrigatorio__c = false, Entregue__c = false);
        Documentacao__c docOptional2 = new Documentacao__c(Name = 'Documento Opcional 2', Obrigatorio__c = false, Entregue__c = false);
        insert new List<Documentacao__c>{docMandatory1, docMandatory2, docOptional1, docOptional2};
        
        
        Opportunity opp1 = new Opportunity(Name = 'Oportunidade Teste 1', CloseDate = Date.today(), StageName = 'Negociação');
        Opportunity opp2 = new Opportunity(Name = 'Oportunidade Teste 2', CloseDate = Date.today(), StageName = 'Negociação');
        insert new List<Opportunity>{opp1, opp2};
        
       
        Checklist_de_Documentos__c checklist1 = new Checklist_de_Documentos__c(
            Oportunidade__c = opp1.Id, 
            Documenta_o__c = docMandatory1.Id
        );
        Checklist_de_Documentos__c checklist2 = new Checklist_de_Documentos__c(
            Oportunidade__c = opp1.Id, 
            Documenta_o__c = docMandatory2.Id
        );
        Checklist_de_Documentos__c checklist3 = new Checklist_de_Documentos__c(
            Oportunidade__c = opp2.Id, 
            Documenta_o__c = docOptional1.Id
        );
        Checklist_de_Documentos__c checklist4 = new Checklist_de_Documentos__c(
            Oportunidade__c = opp2.Id, 
            Documenta_o__c = docOptional2.Id
        );
        insert new List<Checklist_de_Documentos__c>{checklist1, checklist2, checklist3, checklist4};
        
    }

    @isTest
    static void testGetWithDocumentsByOpportunity() {
        List<Opportunity> opps = [
            SELECT Id
            FROM Opportunity
        ];
        
        Set<Id> opportunityIds = new Set<Id>{opps[0].Id, opps[1].Id};
        
        
        Test.startTest();
        List<Checklist_de_Documentos__c> result = ChecklistDA.getWithDocumentsByOpportunity(opportunityIds);
        Test.stopTest();
        
      
        System.assertNotEquals(null, result, 'O resultado não deve ser nulo.');
        System.assertEquals(4, result.size(), 'Deve retornar 4 checklists no total.');
        
        
        Integer opp1Count = 0;
        Integer opp2Count = 0;
       
       
        for (Checklist_de_Documentos__c checklist : result) {
            System.assertNotEquals(null, checklist.Documenta_o__c, 'O campo Documenta_o__c não deve ser nulo.');
            System.assertNotEquals(null, checklist.Documenta_o__r, 'O campo Documenta_o__r não deve ser nulo.');
            System.assertNotEquals(null, checklist.Documenta_o__r.Obrigatorio__c, 'O campo Obrigatorio não deve ser nulo.');
        }
    }

    @isTest
    static void testGetChecklistDocumentsWithDetails() {
        Opportunity opp = [
            SELECT Id
            FROM Opportunity
            LIMIT 1
        ];
        
        Test.startTest();
        Map<Id, List<Checklist_de_Documentos__c>> result = ChecklistDA.getChecklistDocumentsWithDetails(new Set<Id> {opp.Id});
        Test.stopTest();
        
      
        System.assertNotEquals(null, result, 'O resultado não deve ser nulo.');
        
        Integer opp1Count = 0;
        Integer opp2Count = 0;
       
       
        for (Checklist_de_Documentos__c checklist : result.get(opp.Id)) {
            System.assertNotEquals(null, checklist.Documenta_o__c, 'O campo Documenta_o__c não deve ser nulo.');
            System.assertNotEquals(null, checklist.Documenta_o__r, 'O campo Documenta_o__r não deve ser nulo.');
            System.assertNotEquals(null, checklist.Documenta_o__r.Obrigatorio__c, 'O campo Obrigatorio não deve ser nulo.');
        }
    }

    @IsTest
    static void testGetRequiredDocumentsByPapeis() {
        List<String> papeis = new List<String> { 'Fiador', 'Outro' };

        Test.startTest();
        List<Documento__mdt> result = ChecklistDA.getRequiredDocumentsByPapeis(papeis);
        Test.stopTest();

        System.assertEquals(6, result.size(), 'Deveria conter 6 documentos na lista');
    }
}