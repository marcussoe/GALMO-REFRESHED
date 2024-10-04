public class SeriePagamentoSelector {
    public static List<SeriePagamentos__c> obterSeriePagamentosPorInicioPagamento(Id tabelaVendasId){
        return  [ 
            SELECT
                TipoCondicao__c,
                InicioPagamento__c,
                ValorTotal__c,
                QuantidadeParcelas__c,
                Periodicidade__c,
                AposHabiteSe__c
            FROM SeriePagamentos__c
            WHERE TabelaVenda__c = :tabelaVendasId
            ORDER By InicioPagamento__c ASC
        ];
    }

    public static List<SeriePagamentos__c> obterSeriePorId(Id serieDePagamentosId){
        return [
            SELECT 
                Id,
                TipoCondicao__c,
                ValorTotal__c,
                QuantidadeParcelas__c, 
                InicioPagamento__c,
                Periodicidade__c,
                Restante__c,
                AposHabiteSe__c,
                TabelaVenda__c
            FROM SeriePagamentos__c 
            WHERE Id = :serieDePagamentosId
            ORDER By InicioPagamento__c ASC
            LIMIT 1
        ];
    }
}