@isTest
private class ObjectHelperTest {
    
    @TestSetup
    static void makeData(){
        doMakeData();
    }

    private static void doMakeData(){
        Enterprise__c empreendimento = new Enterprise__c();
        empreendimento.Name = 'Empreendimento de Teste';
        insert empreendimento;

        

        insert new Lead(
                LastName = 'Zika',
                Company = 'Chave',
                Status = 'New',
                EmpreendimentoInteresseLead__c = empreendimento.Id
            );
    }

    @isTest
    private static void getLookUpId(){
        Enterprise__c empreendimento = [SELECT Id FROM Enterprise__c LIMIT 1].get(0);
        List<Lead> leads = [SELECT Id, EmpreendimentoInteresseLead__c FROM Lead];

        Set<Id> empreendimentosId = new Set<Id>();

        Test.startTest();

        empreendimentosId = ObjectHelper.getLookUpId(leads, 'InterestedEnterprise__c');

        Test.stopTest();

        Assert.isTrue(empreendimentosId.contains(empreendimento.Id));
    }
}