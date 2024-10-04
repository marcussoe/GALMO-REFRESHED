import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, unsubscribe }  from 'lightning/empApi';

import obterLeadPorId from "@salesforce/apex/WhatsAppController.obterLeadPorId";
import obterMensagensPorChaveExternaCliente from "@salesforce/apex/WhatsAppController.obterMensagensPorChaveExternaCliente";
import controlarDialogo from "@salesforce/apex/WhatsAppController.controlarDialogo";
import enviarMensagem from "@salesforce/apex/WhatsAppController.enviarMensagem";
import enviarMidia from "@salesforce/apex/WhatsAppController.enviarMidia";
import enviarTemplatePadrao from "@salesforce/apex/WhatsAppController.enviarTemplatePadrao";

// import whatsappIcon from '@salesforce/resourceUrl/whatsappIcon';

export default class WhatsApp extends LightningElement {
    @api recordId;

    @track lead = {};
    @track mensagens = [];

    channelName = '/event/EventoWhatsApp__e';
    carregando = false;
    mensagemTexto = null;

    get dialogoEmAndamento() {
        return !Boolean(this.lead.fimDialogo);
    }

    async connectedCallback() {
        await this.obterLead();
        await this.obterMensagensCarregando();
        this.handleSubscribe();
    }

    renderedCallback() {
        this.apresentarUltimasMensagens();
    }

    /**
     * Método responsável por manter o chat em posição para apresentação das
     * mensagens mais recentes.
     */
    apresentarUltimasMensagens() {
        const chat = this.template.querySelector('[data-id="chat"]');

        if (!chat) { return; }

        chat.scrollTo(0, chat.scrollHeight);
    }

    /**
     * Método responsável pela obtenção de mensagens relacionadas ao número
     * para contato do lead.
     */
    async obterMensagensCarregando() {
        this.carregando = true;
        this.obterMensagens();
        this.carregando = false;
    }

    async obterMensagens() {
        try {
            this.mensagens = await this.obterMensagensPorChaveExternaCliente(this.lead.chaveExternaWhatsApp);
        } catch (erro) {
            this.apresentarMensagem('Erro', erro.body.message, 'error');
        }
    }

    obterMensagensPorChaveExternaCliente(chaveExternaCliente) {
        return new Promise((resolve, reject) => obterMensagensPorChaveExternaCliente({ chaveExternaCliente })
            .then(resultado => resolve(JSON.parse(resultado)))
            .catch(erro => reject(erro))
        );
    }

    get mensagemPayload(){
        return this.mensagens;
    }

    /**
     * Método responsável pela obtenção do lead a partir do Id do registro.
     */
    async obterLead() {
        this.carregando = true;

        try {
            this.lead = await this.obterLeadPorId(this.recordId);
        } catch (erro) {
            this.apresentarMensagem('Erro', erro.body.message, 'error');
        }

        this.carregando = false;
    }

    obterLeadPorId(idLead) {
        return new Promise((resolve, reject) => obterLeadPorId({ idLead })
            .then(resultado => resolve(JSON.parse(resultado)))
            .catch(erro => reject(erro))
        );
    }

    /**
     * Método responsável por atualizar o lead com alteração em situação do diálogo
     * com o atendente, indicando se finalizado ou em andamento.
     */
    async handleControlarDialogo() {
        this.carregando = true;

        try {
            this.lead = await this.controlarDialogo(this.recordId);
        } catch (erro) {
            this.apresentarMensagem('Erro', erro.body.message, 'error');
        }

        this.carregando = false;
    }

    controlarDialogo(idLead) {
        return new Promise((resolve, reject) => controlarDialogo({ idLead })
            .then(resultado => resolve(JSON.parse(resultado)))
            .catch(erro => reject(erro))
        );
    }

    /**
     * Método responsável pelo envio de mensagem escrita para o cliente ao digitar
     * 'enter' na caixa de entrada.
     */
    handleEnter(event) {
        if (event.key !== 13) { return; }

        this.handleEnviarMensagem();
    }

    handleAlteracaoMensagemTexto(event) {
        this.mensagemTexto = event.target.value;
    }

    /**
     * Método responsável pelo envio de mensagem ao cliente via WhatsApp seguida de 
     * atualização das mensagens exibidas ao atendente.
     */
    async handleEnviarMensagem() {
        try {
            this.mensagens.push(await this.enviarMensagem(this.recordId, this.mensagemTexto));

            this.mensagemTexto = null;
        } catch (erro) {
            this.apresentarMensagem('Erro', erro.body.message, 'error');
        }
    }

    enviarMensagem(idLead, mensagemTexto) {
        return new Promise((resolve, reject) => enviarMensagem({ idLead, mensagemTexto })
            .then(resultado => resolve(JSON.parse(resultado)))
            .catch(erro => reject(erro))
        );
    }

    handleEnviarTemplatePadrao(event) {
        enviarTemplatePadrao({ idLead: this.recordId, nomeTemplate: 'contatolead'})
    }

    /**s
     * Método responsável pela leitura e envio de mídia como mensagem para o
     * cliente. Os arquivos são lidos e enviados um por vez. 
     */
    handleEnviarMidia(event) {
        const leitor = new FileReader();
    
        Array.from(event.target.files).forEach(arquivo => {
            console.log('File type:', arquivo.type); // Log file type to verify
            leitor.addEventListener('load', (event => this.carregarArquivo(event, arquivo)).bind(this));
            leitor.readAsDataURL(arquivo);
        });
    }
    
    async carregarArquivo(event, arquivo) {
        this.carregando = true;
    
        try {
            const base64Data = this.obterBase64(event.target.result);
            console.log('Arquivo enviado com sucesso:', base64Data, arquivo.type); // Additional logging
    
            const mensagemEnviada = await this.enviarMidia(this.recordId, arquivo.type, arquivo.name, base64Data);
    
            this.mensagens.push(mensagemEnviada);
        } catch (erro) {
            console.log(erro); 
            this.apresentarMensagem('Erro', erro.body.message, 'error');
        }
    
        this.carregando = false;
    }
    

    async enviarMidia(idLead, tipoArquivo, nomeArquivo, corpoArquivo) {
        return new Promise((resolve, reject) => enviarMidia({ idLead, tipoArquivo, nomeArquivo, corpoArquivo })
            .then(resultado => resolve(JSON.parse(resultado)))
            .catch(erro => reject(erro))
        );
    }

    obterBase64(result) {
        const base64 = 'base64,';
        const inicioBase64 = result.indexOf(base64) + base64.length;

        return result.substring(inicioBase64);
    }

    apresentarMensagem(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

   // Handles subscribe button click
    handleSubscribe() {
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        console.log('Antes de invocar subscribe');

        const messageCallback = (response) => {
            console.log('Retorno do response: \n', JSON.stringify(response));
            console.log(this.lead.chaveExternaWhatsApp);
            // console.log('chaveExternaWhatsApp: ' + this.lead.chaveExternaWhatsApp);
            // if(response.data.payload.MessageId__c === this.lead.chaveExternaWhatsApp){
                this.mensagens = [];
                this.obterMensagens();
            // }
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });
    }

    // Handles unsubscribe button click
    handleUnsubscribe() {
        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from channel: ', JSON.stringify(response));
        });
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }
  
}