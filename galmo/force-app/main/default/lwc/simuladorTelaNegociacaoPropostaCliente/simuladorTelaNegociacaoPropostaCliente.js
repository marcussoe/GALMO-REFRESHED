import { LightningElement, track } from 'lwc';


export default class SimuladorTelaNegociacaoPropostaCliente extends LightningElement {
    colunas =[
        {
         fieldApiName: 'TipoCondicao__c',
         label: 'Tipo de Condição'   
        },
        {
         fieldApiName: 'InicioPagamento__c',
         label: 'Início de Pagamento'   
        },
        {
         fieldApiName: 'diaVencimento__c',
         label: 'Dia de vencimento'   
        },
        {
         fieldApiName: 'valorCondicao',
         label: 'Valor da condição'   
        },
        {
         fieldApiName: 'quantidade',
         label: 'Quantidade'   
        },
        {
         fieldApiName: 'totalCondicao',
         label: 'Valor total da condição'   
        },
        {
         fieldApiName: 'porcTotal',
         label: '% Total'   
        },
        {
         fieldApiName: 'porcParcela',
         label: '% Parcela'   
        },
        {
         fieldApiName: 'actions',
         label: ''   
        }
    ]

    @track seriesList = []

    addNewObjectWithUid() {
        const novaCondicao = {
            uid: this.generateUniqueId(),
            inicioPagamento__c: null,
            tipoCondicao__c: null,
            diaVencimento__c: null,
            valorCondicao: null,
            quantidade: null,
            totalCondicao: null,
            porcTotal: null,
            porcParcela: null
        };

    
        let seriesListClone = [...this.seriesList];
    
        seriesListClone.push(novaCondicao);
       
        this.seriesList = seriesListClone;
    }


    generateUniqueId() {
        return 'id-' + Math.random().toString(36).substr(2, 9);
    }

    handleChangeCondicao(event){
        const uid = event.detail.target.dataset.uid;
        const fieldName = event.detail.target.dataset.name;
        const newValue = event.detail.target.value;

        let seriesListClone = [...this.seriesList];
        const indexToUpdate = seriesListClone.findIndex(item => item.uid === uid);
        if (indexToUpdate !== -1) {
            seriesListClone[indexToUpdate][fieldName] = newValue;
        }
        this.seriesList = seriesListClone;
    }

    handleDeleteCondicao(event){
        const uidToDelete = event.detail.target.dataset.uid;
        let updatedSeriesList = this.seriesList.filter(item => item.uid !== uidToDelete);
        this.seriesList = updatedSeriesList;
    }
    
}