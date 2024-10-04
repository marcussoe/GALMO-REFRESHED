public class SeriePagamentosService {
    // Cria a lista principal que contém listas secundárias
    private static List<ValorLinha> listaGlobal = new List<ValorLinha>();
    private static Map<String, Decimal> mapaValorTotalPorData = new Map<String, Decimal>();

    private static Map<Date, List<Object>> mapaDatas = new Map<Date, List<Object>>();
    private static Map<Date, valorLinha> mapaValorLinha = new Map<Date, valorLinha>();

    private static List<ValorLinha> listaValoresReais = new List<ValorLinha>();

    private static List<ValorLinha> listaVPL = new List<ValorLinha>();

    private static Decimal taxaPos;
    private static Decimal taxaAte;
    

    public static void setarHabiteSe (Id tabelaVenda){
        TabelaVendas__c tabelaRelacionada = TabelaVendaSelector.obterTabelasRelacionadas(tabelaVenda);

        taxaPos = tabelaRelacionada.AntecipacaoAposHabiteSe__c;
        taxaAte = tabelaRelacionada.AntecipacaoAteHabiteSe__c;
    }

    public void inicioSerieTabelaVendas(Set<Id> seriesDePagamentosIds){
        Set<Id> idsNaoEncontrados = new Set<Id>(seriesDePagamentosIds);

        System.debug('InicioSerieTabelaVendas');
        if (seriesDePagamentosIds == null || seriesDePagamentosIds.isEmpty()) {
            throw new IllegalArgumentException('Nenhum ID de série de pagamentos fornecido.');
        }
        
        List<SeriePagamentos__c> seriesDePagamentos = [
            SELECT
                Id,
                ValorTotal__c,
                QuantidadeParcelas__c,
                Periodicidade__c,
                InicioPagamento__c,
                TabelaVenda__c,
                AposHabiteSe__c
            FROM SeriePagamentos__c
            WHERE Id IN :seriesDePagamentosIds
        ];
        
        List<ObjetoSerie> seriesDePagamentosDTO = new List<ObjetoSerie>();
        for(SeriePagamentos__c serie : seriesDePagamentos){
            idsNaoEncontrados.remove(serie.Id);
            ObjetoSerie serieDTO = new ObjetoSerie();
            serieDTO.id = serie.Id;
            serieDTO.valorTotal = serie.ValorTotal__c;
            serieDTO.quantidadeParcelas = serie.QuantidadeParcelas__c.intValue();
            serieDTO.periodicidade = serie.Periodicidade__c.intValue();
            serieDTO.inicioPagamento = serie.InicioPagamento__c.intValue();
            serieDTO.tabelaVenda = serie.TabelaVenda__c;
            serieDTO.aposHabiteSe = serie.AposHabiteSe__c;
            seriesDePagamentosDTO.add(serieDTO);
        }

        if (!idsNaoEncontrados.isEmpty()) {
            List<String> idsNaoEncontradosStr = new List<String>();
            for (Id id : idsNaoEncontrados) {
                idsNaoEncontradosStr.add(id.toString());
            }
            System.debug('IDs de séries de pagamentos não encontrados: ' + String.join(idsNaoEncontradosStr, ', '));
        }

        calcularSerieDePagamentos(seriesDePagamentosDTO);
    }

    public void inicioPropostaCliente(List<ObjetoSerie> seriesPagamentosCliente){
        calcularSerieDePagamentos(seriesPagamentosCliente);
    }
    
    public void calcularSerieDePagamentos(List<ObjetoSerie> seriesDePagamentos) { 
        System.debug('InicioCalcularSerieDePagamentos');
        
        List<Map<String, Object>> listaSeriesInfo = new List<Map<String, Object>>();

        for (ObjetoSerie serie : seriesDePagamentos) {
            
            if (serie.valorTotal == null || serie.quantidadeParcelas == null || serie.quantidadeParcelas == 0) {
                System.debug('Série de Pagamento ID ' + serie.id + ' possui valor total ou quantidade de parcelas inválidos.');
                continue;
            }
    
            List<Decimal> valoresParcelas = calcularParcelas(serie.valorTotal, serie.quantidadeParcelas);
    
            List<Comissao__c> comissoes = ComissaoSelector.obterComissaoPorId(serie.id);
            

            if (comissoes.isEmpty()) {
                System.debug('Nenhuma comissão encontrada para a série de pagamentos ID ' + serie.Id);
                continue;
            }
            
            Comissao__c comissao = comissoes[0];
            
            if (comissao.ValorTotalComissaoPorcentagem__c == null || comissao.PorcentagemMaximaComissao__c == null) {
                System.debug('Comissão não configurada corretamente para a série de pagamentos ID ' + serie.Id);
                continue;
            }
            
            Map<String, Object> serieInfo = new Map<String, Object>();
            serieInfo.put('serieDePagamentos', serie);
            serieInfo.put('valoresParcelas', valoresParcelas);
            serieInfo.put('valorTotalComissaoPorcentagem', comissao.ValorTotalComissaoPorcentagem__c);
            serieInfo.put('pagamentoGrupo', comissao.PorcentagemMaximaComissao__c);
            
            listaSeriesInfo.add(serieInfo);
        }
    
        
    
        if (!listaSeriesInfo.isEmpty()) {
            criarMatrizCondicoes(listaSeriesInfo);
        }
    }
    

    private List<Decimal> calcularParcelas(Decimal valorTotal, Integer quantidadeParcelas) {
        List<Decimal> valoresParcelas = new List<Decimal>();
        Decimal valorParcela = valorTotal / quantidadeParcelas;
        for (Integer i = 0; i < quantidadeParcelas; i++) {
            valoresParcelas.add(valorParcela);
        }
        return valoresParcelas;
    }

    public static List<ValorLinha> criarMatrizCondicoes(List<Map<String, Object>> listaSeriesInfo) {
        System.debug('InicioCriarMatrizCondicoes');
        List<ValorLinha> listaTemporaria = new List<ValorLinha>();
        
        for (Map<String, Object> serieInfo : listaSeriesInfo) {
            ObjetoSerie serieDePagamentos = (ObjetoSerie) serieInfo.get('serieDePagamentos');
            List<Decimal> valoresParcelas = (List<Decimal>) serieInfo.get('valoresParcelas');
            Decimal valorTotalComissaoPorcentagem = (Decimal) serieInfo.get('valorTotalComissaoPorcentagem');
            Decimal pagamentoGrupo = (Decimal) serieInfo.get('pagamentoGrupo');
            ObjetoSerie serieHabites = (ObjetoSerie) serieInfo.get('serieDePagamentos');
            Boolean aposHabiteSe = serieHabites.aposHabiteSe;

            Decimal valorDistribuicaoComissao = valorTotalComissaoPorcentagem;

            Integer mesesParaInicio = serieDePagamentos.inicioPagamento != null ? serieDePagamentos.inicioPagamento : 0;
            Date dataInicio = Date.today().addMonths(mesesParaInicio);
            Integer quantidadeParcelas = serieDePagamentos.quantidadeParcelas != null ? serieDePagamentos.quantidadeParcelas : 0;
            Integer periodicidade = serieDePagamentos.periodicidade != null ? serieDePagamentos.periodicidade : 1;

            for (Integer i = 0; i < quantidadeParcelas; i++) {
                Date dataLinha = dataInicio.addMonths(i * periodicidade);
                ValorLinha novaLinha = new ValorLinha();
                novaLinha.dataLinha = dataLinha;
                novaLinha.valorTotal = 0;
                novaLinha.descontoComissao = 0;
                novaLinha.valorLiquido = 0;

                Boolean encontrouLinha = false;
                for (ValorLinha linha : listaTemporaria) {
                    if (linha.dataLinha == dataLinha) {
                        linha.valorTotal += 0;
                        linha.descontoComissao += 0;
                        linha.valorLiquido += 0;
                        encontrouLinha = true;
                        break;
                    }
                }

                if (!encontrouLinha) {
                    listaTemporaria.add(novaLinha);
                }
            }

            for (Integer i = 0; i < quantidadeParcelas; i++) {
                Date dataLinha = dataInicio.addMonths(i * periodicidade);
                Decimal valorParcela = valoresParcelas.size() > i ? valoresParcelas[i] : 0;
                Decimal valorTotal = valorParcela;
                Decimal descontoComissao = 0;
                Decimal valorLiquido = valorParcela;

                if (i == quantidadeParcelas - 1) {
                    descontoComissao = valorDistribuicaoComissao;
                    if (descontoComissao > valorParcela) {
                        descontoComissao = valorParcela;
                    }
                    valorLiquido = valorParcela - descontoComissao;
                    valorDistribuicaoComissao = 0;
                } else if (valorDistribuicaoComissao > 0) {
                    if (valorDistribuicaoComissao >= valorParcela) {
                        descontoComissao = valorParcela * (pagamentoGrupo / 100);
                    } else {
                        descontoComissao = valorDistribuicaoComissao;
                    }
                    if (descontoComissao > valorParcela) {
                        descontoComissao = valorParcela;
                    }
                    valorLiquido = valorParcela - descontoComissao;
                    valorDistribuicaoComissao -= descontoComissao;
                }

                for (ValorLinha linha : listaTemporaria) {
                    if (linha.dataLinha == dataLinha) {
                        linha.valorTotal += valorParcela;
                        linha.descontoComissao += descontoComissao;
                        linha.valorLiquido += valorLiquido;
                        linha.aposHabiteSe = aposHabiteSe;
                        break;
                    }
                }
            }
        }

        List<ValorLinha> listaOrdenada = new List<ValorLinha>();
        
        for (ValorLinha linha : listaTemporaria) {
            Boolean adicionou = false;

            for (Integer j = 0; j < listaOrdenada.size(); j++) {
                if (linha.dataLinha <= listaOrdenada[j].dataLinha) {
                    listaOrdenada.add(j, linha);
                    adicionou = true;
                    break;
                }
            }
            
            if (!adicionou) {
                listaOrdenada.add(linha);
            }
        }

        Integer contadorPosicao = 0;
        for (ValorLinha linha : listaOrdenada) {
            linha.posicao = contadorPosicao++;
        }
        
        listaGlobal = listaOrdenada;
        
        exibirMatrizConsolidada();
        criarMatrizValoresReias('a0Abe0000007iKTEAY');
        criarMatrizVPL('a0Abe0000007iKTEAY', listaGlobal); 
        return listaGlobal;
    }

    public static List<ValorLinha> criarMatrizValoresReias(Id tabelaRelacionada) {
        System.debug('InicioCriarMatrizValroesReais');
        List<UnidadeTabelaVendas__c> unidadesTabelaVendas = UnidadeTabelaSelector.obterUnidadeTabelaPorId(tabelaRelacionada);
        
        System.debug('Tabela: ' + tabelaRelacionada + ' | Unidades: ' + unidadesTabelaVendas);
    
        if (unidadesTabelaVendas.isEmpty()) {
            throw new IllegalArgumentException('Nenhuma unidade de tabela de vendas encontrada.');
        }
    
        UnidadeTabelaVendas__c unidade = unidadesTabelaVendas[0];
        Decimal valorTotalReais = unidade.PrecoLista__c;

        for (ValorLinha linha : listaGlobal) {
            ValorLinha novaLinhaReais = new ValorLinha();
            novaLinhaReais.posicao = linha.posicao;
            novaLinhaReais.dataLinha = linha.dataLinha;
            novaLinhaReais.valorTotal = linha.valorTotal * (valorTotalReais / 100);
            novaLinhaReais.descontoComissao = linha.descontoComissao * (valorTotalReais / 100);
            novaLinhaReais.valorLiquido = linha.valorLiquido * (valorTotalReais / 100);
            novaLinhaReais.aposHabiteSe = linha.aposHabiteSe;
    
            listaValoresReais.add(novaLinhaReais);
        }
    
        exibirMatrizReaisConsolidada();
        return listaValoresReais;
    }

    public static List<ValorLinha> criarMatrizVPL (Id tabelaRelacionada, List<ValorLinha> listaMatrizGlobla) {
        System.debug('InicioCriarMatrizVPL');
        TabelaVendas__c tabelaVendasRelacionada = TabelaVendaSelector.obterTabelasRelacionadas(tabelaRelacionada);
        setarHabiteSe(tabelaRelacionada);

        if (tabelaVendasRelacionada == null) {
            throw new IllegalArgumentException('Nenhuma tabela de vendas encontrada.');
        }

        for(ValorLinha linha : listaValoresReais) {
            linha.taxaUsada = linha.aposHabiteSe ? taxaPos : taxaAte;

            Decimal valorPresente = linha.valorTotal / (1 + (linha.taxaUsada / 100)).pow(linha.posicao);

            ValorLinha novaLinhaVPL = new ValorLinha();
            novaLinhaVPL.posicao = linha.posicao;
            novaLinhaVPL.dataLinha = linha.dataLinha;
            novaLinhaVPL.valorTotal = valorPresente.setScale(2);
    
            listaVPL.add(novaLinhaVPL);
        }

        exibirMatrizVPLConsolidada();
        return listaVPL;
    }

    public static void exibirMatrizConsolidada() {
        for (ValorLinha listaVPL : listaGlobal) {
            System.debug(
                'Data: ' + listaVPL.dataLinha + ' | '
                + 'Posição: ' + listaVPL.posicao  + ' | ' 
                + 'ValorTotal: ' + listaVPL.valorTotal 
            );
        }
    }

    public static void exibirMatrizReaisConsolidada() {
        for (ValorLinha linha : listaValoresReais) {
            System.debug(
                'Data: ' + linha.dataLinha + ' | '
                + 'Posição: ' + linha.posicao  + ' | ' 
                + 'ValorTotal: ' + linha.valorTotal
            );
        }
    }

    public static void exibirMatrizVPLConsolidada() {
        for (ValorLinha linha : listaVPL) {
            System.debug(
                'Data: ' + linha.dataLinha + ' | '
                + 'Posição: ' + linha.posicao  + ' | ' 
                + 'ValorTotal VPL: ' + linha.valorTotal
            );
        }
    }

    public static List<valorLinha> getListaGlobal() {
        return listaGlobal;
    }

    public class ValorLinha{
        public Integer posicao {get; set;}
        public Date dataLinha {get; set;}
        public Decimal valorTotal {get; set;}
        public Decimal descontoComissao {get; set;}
        public Decimal valorLiquido {get; set;}
        public Decimal taxaUsada {get; set;}
        public Boolean aposHabiteSe {get; set;}
    }

    public class ObjetoSerie{
        public String  id {get; set;}
        public Decimal valorTotal {get; set;}
        public Integer quantidadeParcelas {get; set;}
        public Integer periodicidade {get; set;}
        public integer inicioPagamento {get; set;}
        public String  tabelaVenda {get; set;}
        public Boolean aposHabiteSe {get; set;}
    }

}