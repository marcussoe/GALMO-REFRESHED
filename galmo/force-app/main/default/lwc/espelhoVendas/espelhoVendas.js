import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TituloEspelhoVendas from '@salesforce/label/c.TituloEspelhoVendas';
import TituloEmpreendimento from '@salesforce/label/c.TituloEmpreendimento';
import PlaceholderCampoPesquisaEmpreendimentos from '@salesforce/label/c.PlaceholderCampoPesquisaEmpreendimentos';
import TituloTipoImovel from '@salesforce/label/c.TituloTipoImovel';
import PlaceholderCampoPesquisaTiposImoveis from '@salesforce/label/c.PlaceholderCampoPesquisaTiposImoveis';
import TituloFiltros from '@salesforce/label/c.TituloFiltros';
import TituloUnidades from '@salesforce/label/c.TituloUnidades';
import TituloSituacao from '@salesforce/label/c.TituloSituacao';
import TituloValorImovel from '@salesforce/label/c.TituloValorImovel';
import TituloMinimo from '@salesforce/label/c.TituloMinimo';
import TituloMaximo from '@salesforce/label/c.TituloMaximo';
import PlaceholderZeroReais from '@salesforce/label/c.PlaceholderZeroReais';
import PlaceholderZeroMetrosQuadrados from '@salesforce/label/c.PlaceholderZeroMetrosQuadrados';
import TituloErro from '@salesforce/label/c.TituloErro';
// import obterEmpreendimentos from '@salesforce/apex/EmpreendimentoController.getEmpreendimentoRecords';
// import obterTorresPorIdsEmpreendimentos from '@salesforce/apex/EspelhoVendasController.obterTorresPorIdsEmpreendimentos';
// import obterRegiaoCidadeUF from '@salesforce/apex/EmpreendimentoController.getRegiaoCidadeUF';
// import obterAndarPorIdTorre from '@salesforce/apex/AndarController.BuscarAndar';
// import obterImoveis from '@salesforce/apex/UnidadeController.BuscarUnidade';
// import obterUnidadesPesquisadas from '@salesforce/apex/UnidadePorPesquisa.unidadePesquisada';

export default class EspelhoVendas extends LightningElement {
    @track rotulos = {
        TituloEspelhoVendas,
        TituloEmpreendimento,
        PlaceholderCampoPesquisaEmpreendimentos,
        TituloTipoImovel,
        PlaceholderCampoPesquisaTiposImoveis,
        TituloFiltros,
        TituloUnidades,
        TituloSituacao,
        TituloValorImovel,
        TituloAreaTerreno: 'Metragem:',
        TituloMinimo,
        TituloMaximo,
        PlaceholderZeroReais,
        PlaceholderZeroMetrosQuadrados,
        PlaceholderTorre: 'Pesquisar torres',
        TituloErro,
        TituloAndar: 'Andar',
        PlaceholderAndar: 'Pesquisar por andar',
        TituloTorre: 'Torre'
    };
    @track minimo = {
        valorImovel: null,
        areaTerreno: null
    };
    @track maximo = {
        valorImovel: null,
        areaTerreno: null
    };
    @track qtdUnidadesTotal;
    @track qtdUnidades;
    @track qtdUnidadesDisponivel;
    @track qtdUnidadesPermutada;
    @track qtdUnidadesReservada;
    @track qtdUnidadesPreEscritura;
    @track qtdUnidadesEmNegociacao;
    @track qtdUnidadesAlugada;
    @track qtdUnidadesAssinaturaDeContrato;
    @track qtdUnidadesVendida;
    @track qtdUnidadesBloqueada;
    @track valueEmpreendimento;
    @track empreendimento;
    @track valueUF;
    @track valueRegiao;
    @track valorMaxInseridoArea
    @track valorMinInseridoArea
    @track BuscarImovel;
    @track labelAndar;
    @track mostrarCard2 = false;
    @track exibirVisualizacao = false;
    @track valueAndar;
    @track situacoes = [];
    @track optionsEmpreendimentos = [];
    @track optionsUF = [];
    @track optionsRegiao = [];
    @track valueTorre;
    @track optionsTorre = [];
    @track BuscarTorre;
    @track valueImovel;
    @track optionsImovel = [];
    @track optionsAndar = [];
    cidadeList = [];
    empreendimentosList = [];

    exibirFiltros() {
        const panel = this.template.querySelector('.panel');
        if (panel.classList.contains('slds-hide')) {
            panel.classList.remove('slds-hide');
        } else {
            panel.classList.add('slds-hide')
        }
    }

    limparFiltros() {
        this.unidadesParaExibir = this.unidades;
    }

    // @wire(obterEmpreendimentos)
    // detalheEmpreendimento({ data, error }) {
    //     if (data) {
    //         this.optionsEmpreendimentos = data.map(item => ({
    //             label: item.Name,
    //             value: item.Id,
    //             UF: item.EnderecoDoEmpreendimento__StateCode__s,
    //             regiao: item.Regiao__c
    //         }));
    //         this.empreendimentosList = this.optionsEmpreendimentos;


    //     }
    //     if (error) {
    //         console.log(error);
    //     }
    // }

    handleChangeEmpreendimento(event) {
        this.valueEmpreendimento = event.detail.value;

        const empreendimentoSelecionado = this.optionsEmpreendimentos.find(
            option => option.value === this.valueEmpreendimento
        );

        if (empreendimentoSelecionado) {
            this.empreendimento = empreendimentoSelecionado.label;
        } else {
            console.error("Empreendimento não encontrado!");
        }

        this.detalheTorre();
    }

    torresPorId = new Map();
    detalheTorre() {
        // obterTorresPorIdsEmpreendimentos({ idsEmpreendimentos: this.valueEmpreendimento })
        //     .then(torre => {
        //         torre.forEach(torre => this.torresPorId.set(torre.Id, torre));
        //         this.optionsTorre = [];
        //         torre.forEach(item => {
        //             this.optionsTorre.push({
        //                 label: item.Name,
        //                 value: item.Id
        //             });
        //         });

        //     });
    }

    detalheAndar() {
        // obterAndarPorIdTorre({ idTorre: this.valueTorre })
        //     .then(andar => {
        //         this.optionsAndar = [];
        //         andar.forEach(item => {
        //             for (let i = 1; i <= item.QuantidadeDeAndares__c; i++) {
        //                 this.optionsAndar.push({
        //                     label: `${i}`,
        //                     value: `${i}`
        //                 });

        //                 this.unidadesFinal[i] = [];
        //             }

        //             this.optionsAndar.push({
        //                 label: 'Todos',
        //                 value: 'Todos'
        //             })

        //         })
        //     }
        //     )
    }

    handleChangeAndar(event) {
        this.valueAndar = event.detail.value;
        this.exibirUnidadesPorAndar();
        this.mostrarCard2 = true;
        this.exibirVisualizacao = true;
    }

    exibirUnidadesPorAndar() {
        this.unidadesParaExibir = this.unidades.filter(e => e.andar == this.valueAndar);
        if (this.valueAndar == 'Todos') {
            this.unidadesParaExibir = this.unidades
        }
    }

    handleChangeTorre(event) {
        this.valueTorre = event.detail.value;
        const teste = this.unidades.filter(e => e.status == 'Disponível');

        this.qtdUnidadesDisponivel = teste.length;

        this.detalheImoveis();
        this.detalheUnidade();
        this.detalheAndar();
    }

    imovelPorId = new Map();
    detalheImoveis() {
        // obterImoveis({ idsTorre: this.valueTorre })
        //     .then(imovel => {
        //         imovel.forEach(imovel => this.imovelPorId.set(imovel.Id, imovel));
        //         this.optionsImovel = [];

        //         imovel.forEach(item => {
        //             if (!(this.optionsImovel.findIndex(e => e.label === item.TipoDaUnidade__c) > -1)) {
        //                 this.optionsImovel.push({
        //                     label: item.TipoDaUnidade__c,
        //                     value: item.Id
        //                 })
        //             }
        //         })
        //         this.optionsImovel.push({
        //             label: 'Todos',
        //             value: 'Todos'
        //         });
        //     })

    }

    connectedCallback() {
        this.exibirQtdUnidades = true;
    }

    @track nomeTipoImovel
    handleChangeTipoImoveis(event) {
        this.valueImovel = event.detail.value;
        const tipoImovelSelecionado = this.optionsImovel.find(
            option => option.value === this.valueImovel
        );

        if (tipoImovelSelecionado) {
            this.nomeTipoImovel = tipoImovelSelecionado.label;
            this.unidadesParaExibir = this.unidades.filter(e => e.tipo == this.nomeTipoImovel)
            if (this.nomeTipoImovel == 'Todos') {
                this.unidadesParaExibir = this.unidades
            }
        }
    }


    regioesSet = new Set();
    // @wire(obterRegiaoCidadeUF)
    // detalheRegiaoCidadeUF({ data, error }) {
    //     if (data) {

    //         const ufsSet = new Set();
    //         const regiaoSet = new Set();


    //         data.forEach(item => {
    //             ufsSet.add(item.EnderecoDoEmpreendimento__StateCode__s);
    //             regiaoSet.add(item.Regiao__c);
    //         });


    //         this.optionsUF = [...ufsSet].map(label => ({ label, value: label }));
    //         this.optionsRegiao = [...regiaoSet].map(label => ({ label, value: label }));
    //     }
    //     if (error) {
    //         console.log(error);
    //     }
    // }

    regioesList = [];
    handleChangeUF(event) {
        this.valueUF = event.detail.value;
        this.optionsEmpreendimentos = this.empreendimentosList.filter(e => e.UF == this.valueUF);
        this.regioesList = this.optionsEmpreendimentos;

    }

    handleChangeRegiao(event) {
        this.valueRegiao = event.detail.value;
        this.optionsEmpreendimentos = this.regioesList.filter(e => e.regiao == this.valueRegiao)
    }

    compararAndar(a = { andar }, b = { andar }) {
        return a.andar - b.andar;
    }

    @track exibirQtdUnidades = false;

    @track exibirPaginacao = false;
    @track valueUnidade;
    @track unidades = [];
    @track BuscarUnidade;
    @track unidadesFinal = {};
    detalheUnidade() {
        obterImoveis({ idsTorre: this.valueTorre })
            .then(unidade => {
                this.unidades = [];
                console.log(unidade);

                unidade.forEach(item => {
                    this.unidades.push({
                        empreendimento: this.empreendimento,
                        id: item.Id,
                        unidade: item.Name,
                        status: item.Situacao__c,
                        numeroDeQuartos: item.Quartos__c,
                        unidade: item.NumeroDaUnidade__c,
                        status: item.Status__c,
                        andar: item.Andar__c,
                        area: item.MetragemDaUnidadeM__c,
                    })
                });

                this.unidadesParaExibir = this.unidades.sort(this.compararAndar);

                this.exibirPaginacao = true;
                this.qtdUnidadesDisponivel = this.unidades.filter(e => e.status == 'Disponível').length;
                this.qtdUnidadesPermutada = this.unidades.filter(e => e.status == 'Permutada').length;
                this.qtdUnidadesReservada = this.unidades.filter(e => e.status == 'Reservada').length;
                this.qtdUnidadesPreEscritura = this.unidades.filter(e => e.status == 'Pré-Escritura').length;
                this.qtdUnidadesEmNegociacao = this.unidades.filter(e => e.status == 'Em negociação').length;
                this.qtdUnidadesAlugada = this.unidades.filter(e => e.status == 'Alugada').length;
                this.qtdUnidadesAssinaturaDeContrato = this.unidades.filter(e => e.status == 'Assinatura de contrato').length;
                this.qtdUnidadesVendida = this.unidades.filter(e => e.status == 'Vendida').length;
                this.qtdUnidadesBloqueada = this.unidades.filter(e => e.status == 'Bloqueada').length;
                this.qtdUnidadesTotal = this.unidades.length
            })
    }

    renderedCallback() {
        this.qtdUnidades = this.unidadesParaExibir.length;
        this.qtdUnidadesTotal = this.unidades.length;
        this.valorMaxDeUnidade = Math.max(this.unidades.valorDaUnidade)
    }

    @track valorMinInserido;
    atualizarLimiteInferior(event) {
        this.valorMinInserido = event.target.value;
        this.atualizarLimite();
    }



    @track atualizar = false;
    @track valorMaxInserido;
    @track valorMaxDeUnidade;
    atualizarLimiteSuperior(event) {
        this.valorMaxInserido = event.target.value;
        this.atualizarLimite();
    }

    atualizarLimite() {
        obterImoveis({ idsTorre: this.valueTorre })
            .then(unidade => {
                this.unidadesParaExibir = [];
                unidade.forEach(item => {

                    if (this.valorMinInserido === '' || this.valorMinInserido === undefined) {
                        this.valorMinInserido = 0;

                    }

                    else if (this.valorMaxInserido === '' || this.valorMaxInserido === undefined) {
                        this.valorMaxInserido = 99999999999999;
                    }
                    else if (this.valorMinInserido === undefined && this.valorMaxInserido === undefined) {
                        this.valorMinInserido = 0;
                        this.valorMaxInserido = 9999999999999;
                    }
                    else if (item.ValorDaUnidade__c >= this.valorMinInserido && this.valorMaxInserido == '') {
                        this.valorMaxInserido = 9999999999999;
                    }
                    else if (item.ValorDaUnidade__c <= this.valorMaxInserido && this.valorMinInserido == '') {
                        this.valorMinInserido = 0;
                    }

                    if (item.ValorDaUnidade__c <= this.valorMaxInserido && item.ValorDaUnidade__c >= this.valorMinInserido) {


                        this.unidadesParaExibir.push({
                            empreendimento: this.empreendimento,
                            id: item.Id,
                            unidade: item.NumeroDaUnidade__c,
                            status: item.Status__c,
                            metragem: item.MetragemDaUnidadeM__c,
                            numeroDeQuartos: item.NumeroDeQuartos__c,
                            numeroDeVagas: item.NumeroDeVagas__c,
                            valorDaUnidade: parseFloat(item.ValorDaUnidade__c).toLocaleString('pt-br', { style: 'currency', currency: 'BRL' }),
                            mostrarTooltip: false,
                            andar: item.Andar__c,
                            area: item.MetragemDaUnidadeM__c,
                            tipo: item.TipoDaUnidade__c,
                            link: `https://elera2--quickstart.sandbox.lightning.force.com/lightning/r/Unidade__c/${item.Id}/view?ws=%2Flightning%2Fr%2FEmpreendimento__c%2F${this.valueEmpreendimento}%2Fview`
                        })
                    }

                })

            })
    }

    atualizarLimiteInferiorArea(event) {
        this.valorMinInseridoArea = event.target.value;
        this.atualizarLimiteArea();
    }

    atualizarLimiteSuperiorArea(event) {
        this.valorMaxInseridoArea = event.target.value;
        this.atualizarLimiteArea();
    }

    atualizarLimiteArea() {
        if (this.valorMinInseridoArea === undefined || this.valorMaxInseridoArea === undefined) {
            this.valorMinInseridoArea = 0;
            this.valorMaxInseridoArea = 9999999999999;
        }

        this.unidadesParaExibir = this.unidades.filter(item =>
            (this.valorMinInseridoArea <= item.metragem || isNaN(this.valorMinInseridoArea)) &&
            (this.valorMaxInseridoArea >= item.metragem || isNaN(this.valorMaxInseridoArea))
        );

    }

    @track unidadesParaExibir = [];
    @track filtroSelecionado;

    handleClick(event) {
        this.filtroSelecionado = event.target.label;
        this.unidadesParaExibir = this.unidades.filter(e => e.status == this.filtroSelecionado);
    }
    unidadePesquisada = '';
    handleSearch(event) {
        this.unidadePesquisada = event.target.value;

        if (this.unidadePesquisada !== null && this.unidadePesquisada.trim() !== '') {
            this.atualizarListaComUnidadePesquisa();
        } else {
            this.unidadesParaExibir = this.unidades;
        }

        if (this.unidadePesquisada == null) {
            this.unidadePesquisada = 0;
        }
    }


    atualizarListaComUnidadePesquisa() {
        // obterUnidadesPesquisadas({ searchKey: this.unidadePesquisada, idsTorre: this.valueTorre })
        //     .then(unidade => {
        //         this.unidadesParaExibir = [];
        //         unidade.forEach(item => {
        //             this.unidadesParaExibir.push({
        //                 empreendimento: this.empreendimento,
        //                 id: item.Id,
        //                 unidade: item.NumeroDaUnidade__c,
        //                 status: item.Status__c,
        //                 metragem: item.MetragemDaUnidadeM__c,
        //                 numeroDeQuartos: item.NumeroDeQuartos__c,
        //                 numeroDeVagas: item.NumeroDeVagas__c,
        //                 valorDaUnidade: parseFloat(item.ValorDaUnidade__c).toLocaleString('pt-br', { style: 'currency', currency: 'BRL' }),
        //                 mostrarTooltip: false,
        //                 andar: item.Andar__c,
        //                 area: item.MetragemDaUnidadeM__c,
        //                 tipo: item.TipoDaUnidade__c,
        //                 link: `https://elera2--quickstart.sandbox.lightning.force.com/lightning/r/Unidade__c/${item.Id}/view?ws=%2Flightning%2Fr%2FEmpreendimento__c%2F${this.valueEmpreendimento}%2Fview`

        //             })

        //         })

        //     })
    }

    apresentarMensagem(titulo, mensagem, tipo) {
        this.dispatchEvent(new ShowToastEvent({
            title: titulo,
            message: mensagem,
            variant: tipo
        }));
    }


}