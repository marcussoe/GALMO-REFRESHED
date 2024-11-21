@isTest
private class ChecklistHelperTest {
    
    @TestSetup
    static void setup() {
    	Contact contact1 = TestDataFactory.gerarContato(); 
		Contact contact2 = TestDataFactory.gerarContato(); 
		insert new List<Contact>{contact1, contact2};
        
        Documentacao__c docMandatory1 = TestDataFactory.gerarDocumentacao();
        Documentacao__c docMandatory2 = TestDataFactory.gerarDocumentacao();
        Documentacao__c docOptional1 = TestDataFactory.gerarDocumentacao();
        docOptional1.Obrigatorio__c = false;
        Documentacao__c docOptional2 = TestDataFactory.gerarDocumentacao();
        docOptional2.Obrigatorio__c = false;
        insert new List<Documentacao__c>{docMandatory1, docMandatory2, docOptional1, docOptional2};
        
        Opportunity opp1 = TestDataFactory.gerarOportunidade();
		opp1.StageName = 'Pré-análise';
        Opportunity opp2 = TestDataFactory.gerarOportunidade();
        opp2.StageName = 'Prospecting';
        insert new List<Opportunity>{opp1, opp2};
            
       	
        Checklist_de_Documentos__c checklist1 = TestDataFactory.gerarChecklistDocumentos(opp1, docMandatory1, contact1);
        Checklist_de_Documentos__c checklist2 = TestDataFactory.gerarChecklistDocumentos(opp1, docMandatory2, contact1);
        Checklist_de_Documentos__c checklist3 = TestDataFactory.gerarChecklistDocumentos(opp1, docMandatory1, contact2);
        Checklist_de_Documentos__c checklist4 = TestDataFactory.gerarChecklistDocumentos(opp1, docMandatory2, contact2); 
        insert new List<Checklist_de_Documentos__c>{checklist1, checklist2, checklist3, checklist4};
             
    }
    
    @isTest
    static void testUpdateOpportunityChecklistStatus() {
		
		Opportunity opp = [
            SELECT Id, Name, StageName
            FROM Opportunity
            WHERE StageName = 'Prospecting'
        ];
        
        List<Documentacao__c> documentos = [
            SELECT Id, Name, Obrigatorio__c, Entregue__c
            FROM Documentacao__c
            WHERE Obrigatorio__c = true
        ];
       
        List<Checklist_de_Documentos__c> checklists = [
            SELECT Id, Oportunidade__c, Documenta_o__c, Contato__c
            FROM Checklist_de_Documentos__c
        ];
        
        for (Checklist_de_Documentos__c checklist : checklists) {
            checklist.Oportunidade__c = opp.Id;
        }
        Test.startTest();
        update checklists;
        
        
        documentos.get(0).Entregue__c = true; 
        update documentos.get(0);

        
        ChecklistHelper.updateOpportunityChecklistStatus(checklists);
        
        
        Opportunity updatedOpp = [SELECT Id, FarolChecklistDocumento__c FROM Opportunity WHERE Id = :opp.Id];
        
        
        documentos.get(1).Entregue__c = true; 
        update documentos.get(1);

       
        ChecklistHelper.updateOpportunityChecklistStatus(checklists);
        
       
        updatedOpp = [SELECT Id, FarolChecklistDocumento__c FROM Opportunity WHERE Id = :opp.Id];
    	Test.stopTest();
    }
   
    @IsTest
    static void testGetByAnalisesCredito() {
        Opportunity opp = [
            SELECT Id, StageName
            FROM Opportunity
            LIMIT 1
        ];
        AnaliseCredito__c analise = TestDataFactory.gerarAnaliseCredito(opp);
        insert analise;
 
        Test.startTest();
        List<Checklist_de_Documentos__c> result = ChecklistHelper.getByAnalisesCredito(new Set<Id>{ analise.Id });
        Test.stopTest();

        System.assertEquals(4, result.size(), 'Deveria conter 4 valores na lista');
    }
}