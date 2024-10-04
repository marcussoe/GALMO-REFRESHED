@isTest
public class ValidateConjugeCompanheiroTriggerTest {
    @isTest
    static void testSingleConjugeCompanheiro() {
        // Criar uma Person Account e uma Opportunity
        Account personAccount = new Account(LastName = 'Test Person', RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id);
        insert personAccount;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = personAccount.Id);
        insert opp;
        
        // Adicionar um contato do tipo "Cônjuge/Companheiro"
        Contact spouse = new Contact(LastName = 'Spouse', AccountId = personAccount.Id);
        insert spouse;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(ContactId = spouse.Id, OpportunityId = opp.Id, Role = 'Cônjuge/Companheiro');
        insert ocr1;
        
        // Tentar adicionar um segundo contato do tipo "Cônjuge/Companheiro" deve falhar
        Contact anotherSpouse = new Contact(LastName = 'Another Spouse', AccountId = personAccount.Id);
        insert anotherSpouse;
        
        OpportunityContactRole ocr2 = new OpportunityContactRole(ContactId = anotherSpouse.Id, OpportunityId = opp.Id, Role = 'Cônjuge/Companheiro');
        try {
            insert ocr2;
            System.assert(false, 'Inserção deve falhar pois já existe um Cônjuge/Companheiro.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('A Person Account só pode ter um relacionamento do tipo "Cônjuge/Companheiro".'), e.getMessage());
        }
    }
}