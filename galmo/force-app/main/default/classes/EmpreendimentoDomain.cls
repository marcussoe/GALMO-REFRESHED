public class EmpreendimentoDomain {
    public static Enterprise__c obterEmpreendimentoPorId(Id idEmpreendimento) {
        List<Enterprise__c> empreendimentos = EmpreendimentoSelector.obterEmpreendimentosPorIds(new Set<Id>{ idEmpreendimento });

        return empreendimentos.isEmpty() ? new Enterprise__c() : empreendimentos.get(0);
    }
}