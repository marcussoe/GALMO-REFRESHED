public class DistribuicaoComissaoHandler extends TriggerHandler {

    public override void afterInsert() {
        DistribuicaoComissaoService.atualizarComissoes((List<DistribuicaoComissao__c>) Trigger.new);
    }

    public override void afterUpdate() {
        DistribuicaoComissaoService.atualizarComissoes((List<DistribuicaoComissao__c>) Trigger.new);
    }

    public override void afterDelete() {
        DistribuicaoComissaoService.diminuiComissoes((List<DistribuicaoComissao__c>) Trigger.old);
    }
}