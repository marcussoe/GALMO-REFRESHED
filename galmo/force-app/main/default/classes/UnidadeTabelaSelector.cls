public class UnidadeTabelaSelector {
    public static List<UnidadeTabelaVendas__c> obterUnidadeTabelaPorId(Id tabelaVendaRelacionada){
        return [
            SELECT
            Id,
            TabelaVenda__c,
            PrecoLista__c
            FROM UnidadeTabelaVendas__c 
            WHERE TabelaVenda__c = :tabelaVendaRelacionada
        ];
    }
}