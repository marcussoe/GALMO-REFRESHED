@isTest
public class SObjectDomainTest {
    static final String NOME_CONTA = 'Test Account';

    @TestSetup
    static void makeData() {
        Account conta = new Account(Name = NOME_CONTA);
        insert conta;
    }

    @isTest
    static void testarObterRegistroPorId() {
        Account conta = [SELECT Id FROM Account LIMIT 1];
        Account contaRecuperada = (Account) SObjectDomain.obterRegistroPorId(new List<String>(), 'Account', conta.Id);

        Assert.areEqual(conta.Id, contaRecuperada.Id, 'Registro recuperado com sucesso.');
    }

    @isTest
    static void testarObterIds() {
        List<Account> contas = [SELECT Id FROM Account];
        List<Id> idsContas = new List<Id>(SObjectDomain.obterIds(contas));

        Assert.areEqual(contas.get(0).Id, idsContas.get(0), 'Ids dos registros obtidos com sucesso.');
    }
}