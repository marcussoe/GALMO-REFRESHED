import { LightningElement, track, wire } from 'lwc';
import buscarProdutoPorId from '@salesforce/apex/SimuladorVendasController.buscarProdutoPorId';
import buscarEntradaTabelaPrecoPorIdDeProduto from '@salesforce/apex/SimuladorVendasController.buscarEntradaTabelaPrecoPorIdDeProduto';
import obterTabelasPorIdEmpreendimento from '@salesforce/apex/SimuladorVendasController.obterTabelasPorIdEmpreendimento';

const tabelaVendasColunas = [
    { label: 'Tipo de condição', fieldName: 'TipoCondicao__c' },
    { label: 'Início de pagamento', fieldName: 'InicioPagamento__c', type: 'number' },
    { label: 'Quantidade de Parcelas', fieldName: 'QuantidadeParcelas__c', type: 'number' },
    { label: 'Valor Parcela ', fieldName: 'valorParcela', type: 'currency' }, //não achei
    { label: 'Valor Total', fieldName: 'valorTotal', type: 'currency' },//não achei
    { label: '% parcela', fieldName: 'porcentagemParcela', type: 'number' }, // não achei
    { label: '% total', fieldName: 'ValorTotal__c', type: 'number' },
    { label: 'Após habite-se?', fieldName: 'AposHabiteSe__c', type: 'boolean' }
];

const produtosEstaticosId = [{id: '01tbe000001Bg6bAAC'}, {id: '01tD2000009mkkvIAA'}];

export default class SimuladorDeVendas extends LightningElement {
    
    tabelaVendasColunas = tabelaVendasColunas;
    produtosEstaticosId = produtosEstaticosId;

    @track currentStep = 0;
    @track produtoEstatico;
    @track tipoVendaValue = null;
    @track tabelaVendasValue = null;

    @track idEmpreendimento = 'a01D2000004bD6cIAE';
    @track idUnidade = '01tbe000001Bg6bAAC';



    seriePagamentosTabelaVendas = [{
        TipoCondicao__c: 'Ato',
        InicioPagamento__c: 10,
        QuantidadeParcelas__c: 2,
        valorParcela: 100.00,
        valorTotal: 200.00,
        porcentagemParcela: 50,
        ValorTotal__c: 100,
        AposHabiteSe__c: true

    }];

    connectedCallback(){
        this.obterTabelasPorIdEmpreendimento()
    }

    stepValues = [
        'espelho', 'unidade', 'negociacao', 'extrato'
    ];

    get currentStepValue() {
        return this.stepValues[this.currentStep];
    }

    get etapaEspelho(){
        return this.currentStepValue === 'espelho';
    }

    get etapaUnidade(){
        return this.currentStepValue === 'unidade';
    }

    get etapaNegociacao(){
        return this.currentStepValue === 'negociacao';
    }

    get isFirstStep() {
        return this.currentStep === 0;
    }

    get isLastStep() {
        return this.currentStep === 3;
    }

    get tipoVendaOptions() {
        return [
            { label: 'Teste', value: 'teste1' },
            { label: 'Teste 2', value: 'teste2' },
            { label: 'Teste 3', value: 'teste3' },
        ];
    }

    

    get tabelaVendasOptions() {
        return [
            { label: 'Teste', value: 'teste4' },
            { label: 'Teste 2', value: 'teste5' },
            { label: 'Teste 3', value: 'teste6' },
        ];
    }


    doPrevStep(){

        if(this.isFirstStep) {return};
        this.currentStep = this.currentStep - 1;
    }
    
    doNextstep(){
        if(this.isLastStep) {return};
        this.currentStep = this.currentStep + 1;
    }

    handleChooseUnidade(event){
        if(!event.currentTarget.dataset.id){return};
        this.chooseUnidade(event.currentTarget.dataset.id);
        
        console.log(JSON.stringify(this.produtoEstatico));
    }

    chooseUnidade(id){
        buscarProdutoPorId({id: id})
        .then(result => {
            this.preencherUnitPrice(result)
            .then(produtoEstatico =>{
                this.produtoEstatico = {...produtoEstatico};
            });
        })
        .catch(error => {
            console.log(error);
        })
    }

    preencherUnitPrice(produtoEstatico){
        return buscarEntradaTabelaPrecoPorIdDeProduto({id: produtoEstatico.Id})
        .then(result=>{
            let produtoModificado = {...produtoEstatico};
            produtoModificado.UnitPrice = result.UnitPrice || 0;
            return produtoModificado;
        })
        .catch(error => {
            console.log(error);
        })
    }

    obterTabelasPorIdEmpreendimento(){
        obterTabelasPorIdEmpreendimento({idEmpreendimento: 'a01D2000004bD6cIAE'})
        .then(result =>{
            result.forEach(element => {
                console.log(element.Name);
            });
        })
        .catch(error => {
            console.log(error);
        })
    }
}