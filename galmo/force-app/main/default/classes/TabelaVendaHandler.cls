public class TabelaVendaHandler extends TriggerHandler{
    public override void afterInsert(){
        TabelaVendaService.inserirUnidadesTabelas((List<TabelaVendas__c>) Trigger.new);
    }

    public override void afterUpdate(){
        tabelaVendaService.inserirUnidadesTabelas((List<TabelaVendas__c>) Trigger.new);
    }
}