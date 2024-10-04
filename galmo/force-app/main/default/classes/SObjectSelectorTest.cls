@isTest
public class SObjectSelectorTest {
    @TestSetup
    static void makeData() {
        Account conta = new Account(Name = 'Test Account');
        insert conta;
    }

    @isTest
    static void testBuscarPorId() {
        Account conta = [SELECT Id FROM Account LIMIT 1];

        List<SObject> registros = SObjectSelector.buscarRegistrosPorIds(new List<String>{'Name'}, 'Account', new Set<Id>{ conta.Id });

        Assert.areEqual(1, registros.size(), 'Registro obtido.');

        Account contaRetornada = (Account) registros[0];

        Assert.areEqual('Test Account', contaRetornada.Name, 'Conta correta obtida.');
    }
}