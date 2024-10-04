import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class UnidadeInfoDisplay extends NavigationMixin(LightningElement) {
    @api produtoSelecionado;

    get produtoSelecionadoEmpreendimento(){
        return this.produtoSelecionado && this.produtoSelecionado.Enterprise__r.Name ? this.produtoSelecionado.Enterprise__r.Name : false;
    }

    get produtoSelecionadoName(){
        return this.produtoSelecionado && this.produtoSelecionado.Name ? this.produtoSelecionado.Name : false;
    }

    get produtoSelecionadoNumeroUnidade(){
        
        return this.produtoSelecionado && this.produtoSelecionado.Numero__c ? this.produtoSelecionado.Numero__c : false;
    }


    // get produtoSelecionadoEnquadramento(){
    //     
    //     return 'Placeholder';
    // }

    get produtoSelecionadoAndar(){
        
        return this.produtoSelecionado && this.produtoSelecionado.Andar__c ? this.produtoSelecionado.Andar__c : false;
    }

    get produtoSelecionadoQuartos(){
        
        return this.produtoSelecionado && this.produtoSelecionado.Quartos__c ? this.produtoSelecionado.Quartos__c : false;
    }

    get produtoSelecionadoMetragemUnidade(){
        
        return this.produtoSelecionado && this.produtoSelecionado.MetragemDaUnidadeM__c ? this.produtoSelecionado.MetragemDaUnidadeM__c : false;
    }

    get produtoSelecionadoPrecoLista(){
        return this.produtoSelecionado && this.produtoSelecionado.UnitPrice ? this.produtoSelecionado.UnitPrice : false;
    }
    
    

    get isProdutoSelecionado(){
        return this.produtoSelecionado;
    }

    get produtoSelecionadoId(){
        return this.produtoSelecionado && this.produtoSelecionado.Id ? this.produtoSelecionado.Id : false;
    }

    redirectToEmpreendimento(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.produtoSelecionado.Id,
                actionName: 'view'
                }
        })
    }
}