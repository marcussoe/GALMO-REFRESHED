public without sharing class DocumentacaoService {
    public static void criarDocumentacaoPorPapeisContato(List<OpportunityContactRole> papeisContatoOportunidade) {
        Map<Id, List<Documentacao__c>> documentacoes = buscarDocumentacao(papeisContatoOportunidade);

        Set<OpportunityContactRole> papeisContatoSemDocumentacao = new Set<OpportunityContactRole>();

        for(OpportunityContactRole papelContato : papeisContatoOportunidade) {
            if(!documentacoes.containsKey(papelContato.ContactId)) {
                papeisContatoSemDocumentacao.add(papelContato);
            }
        }

        if(!papeisContatoSemDocumentacao.isEmpty()) {
            criarDocumentacao(papeisContatoSemDocumentacao);
        }
    }

    public static void criarDocumentacao(Set<OpportunityContactRole> papeisContato) {
        List<ConfiguracaoDocumentacao__mdt> configuracoesDocumentacao = ConfiguracaoDocumentacao__mdt.getAll().values();

        List<Documentacao__c> novasDocumentacoes = new List<Documentacao__c>();

        for(OpportunityContactRole papelContato : papeisContato) {
            for(ConfiguracaoDocumentacao__mdt configuracaoDocumentacao : configuracoesDocumentacao) {
                if(papelContato.Role == configuracaoDocumentacao.PapelContato__c) {
                    novasDocumentacoes.add(new Documentacao__c(
                        Contato__c = papelContato.ContactId,
                        Name = configuracaoDocumentacao.NomeDocumento__c,
                        Obrigatorio__c = configuracaoDocumentacao.Obrigatorio__c
                    ));
                }
            }
        }
        
        if(!novasDocumentacoes.isEmpty()){
            insert novasDocumentacoes;
        }
    }

    public static Map<Id, List<Documentacao__c>> buscarDocumentacao(List<OpportunityContactRole> papeisContatoOportunidade) {
        Set<Id> idsContatos = new Set<Id>();

        for(OpportunityContactRole papelContato : papeisContatoOportunidade) {
            idsContatos.add(papelContato.ContactId);
        }

        List<Documentacao__c> documentacoes = DocumentacaoSelector.buscarDocumentacaoPorIdContato(idsContatos);

        return DocumentacaoDomain.obterDocumentacaoPorIdContato(documentacoes);
    }
}