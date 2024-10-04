public class TabelaVendaSelector {
    public static List<UnidadeTabelaVendas__c> obterUnidadeTabelasPorId (Id tabelaVendasId) {
        return [
            SELECT PrecoLista__c
            FROM UnidadeTabelaVendas__c
            WHERE TabelaVenda__c = :tabelaVendasId
            LIMIT 1
        ];
    }

    public static TabelaVendas__c obterTabelasRelacionadas(Id tabelaRelacionada){
        return [
            SELECT
                Id,
                AntecipacaoAteHabiteSe__c,
                AntecipacaoAposHabiteSe__c
            FROM TabelaVendas__c
            WHERE Id = :tabelaRelacionada LIMIT 1
        ];
    }


}