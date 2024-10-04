public with sharing class SeriePagamentosExtension {
    public List<SeriePagamentoWrapper> seriesDePagamentos { get; set; }
    public Id tabelaVendasId { get; set; }
    public Decimal valorTotalGeralReais { get; set; } 

    public SeriePagamentosExtension(ApexPages.StandardController controller) {
        this.tabelaVendasId = controller.getId();
        seriesDePagamentos = new List<SeriePagamentoWrapper>();
        carregarSeriesDePagamentos();
        calcularValorTotalGeralReais();
    }

    // Carregar as séries de pagamentos simuladas
    private void carregarSeriesDePagamentos() {
        List<SeriePagamentos__c> series = SeriePagamentoSelector.obterSeriePagamentosPorInicioPagamento(tabelaVendasId);

        Decimal precoLista = obterPrecoLista(); 

        for (SeriePagamentos__c serie : series) {
            Decimal valorTotalReais = (serie.ValorTotal__c * precoLista) / 100;
            seriesDePagamentos.add(new SeriePagamentoWrapper(serie, valorTotalReais));
        }
    }

    // Método para obter o preço da lista da tabela de vendas
    private Decimal obterPrecoLista() {
        List<UnidadeTabelaVendas__c> unidade = TabelaVendaSelector.obterUnidadeTabelasPorId(tabelaVendasId);
        return unidade[0].precoLista__c;
    }

    // Calcular o valor total em reais de todas as séries de pagamentos
    private void calcularValorTotalGeralReais() {
        valorTotalGeralReais = 0;
        for (SeriePagamentoWrapper wrapper : seriesDePagamentos) {
            valorTotalGeralReais += wrapper.valorTotalReais;
        }
    }

    public class SeriePagamentoWrapper {
        public SeriePagamentos__c serie { get; set; }
        public Decimal valorTotalReais { get; set; }

        public SeriePagamentoWrapper(SeriePagamentos__c serie, Decimal valorTotalReais) {
            this.serie = serie;
            this.valorTotalReais = valorTotalReais;
        }
    }
}