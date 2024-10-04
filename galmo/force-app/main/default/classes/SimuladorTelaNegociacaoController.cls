public class SimuladorTelaNegociacaoController {
   
    @AuraEnabled
    public static List<TabelaVendas__c> obterTabelasPorIdEmpreendimento(Id idEmpreendimento){
        return TabelaVendaSelector.obterTabelasPorIdEmpreendimento(idEmpreendimento);
    }
}