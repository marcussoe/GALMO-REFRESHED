trigger DistribuicaoComissaoTrigger on distribuicaoComissao__c (after insert, after update,after delete) {
    new DistribuicaoComissaoHandler().run();
}