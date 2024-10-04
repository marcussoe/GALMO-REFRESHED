import { LightningElement, track, api } from 'lwc';
import obterTabelasPorIdEmpreendimento from '@salesforce/apex/SimuladorTelaNegociacaoController.obterTabelasPorIdEmpreendimento';

const tipoVendaOptions = [
    { label: 'Financiado', value: 'Financiado' },
    { label: 'À vista', value: 'À vista' },
    { label: 'Finaciamento Anual', value: 'Finaciamento Anual'}
];

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

export default class SimuladorTelaNegociacao extends LightningElement {

    // @api idEmpreendimento;
    // @api idUnidade;

    // @track tabelaVendasOptions = [];
    // @track tabelaVendasValue;

    // @track tipoVendaValue;
    // @track tipoVendaOptions = tipoVendaOptions;

    // @track tabelaVendasColunas = tabelaVendasColunas;

    // seriePagamentosTabelaVendas = [{
    //     TipoCondicao__c: 'Ato',
    //     InicioPagamento__c: 10,
    //     QuantidadeParcelas__c: 2,
    //     valorParcela: 100.00,
    //     valorTotal: 200.00,
    //     porcentagemParcela: 50,
    //     ValorTotal__c: 100,
    //     AposHabiteSe__c: true

    // }];

    // connectedCallback(){
    //     this.obterTabelasPorIdEmpreendimento()
    // }

    // obterTabelasPorIdEmpreendimento(){
    //     obterTabelasPorIdEmpreendimento({idEmpreendimento: this.idEmpreendimento})
    //         .then(result => {
    //             result.forEach(element => {
    //                 this.tabelaVendasOptions.push(
    //                     { label: element.Name, value: element.Id }
    //                 );
    //             });
    //         })
    //         .catch(error => {
    //             console.log(error);
    //         })
    // }
}