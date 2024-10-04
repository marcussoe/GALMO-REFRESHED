public with sharing class QuoteHelper {

    public static void updateOpportunitiesFromQuotes(List<Quote> newQuotes, Map<Id, Quote> oldMap) {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        Set<Id> quoteIds = new Set<Id>();
        
        // Lista de notificações personalizadas a serem enviadas
        Set<String> recipientsIds = new Set<String>();

        // Adiciona as cotações que foram aprovadas e sincronizadas
        for (Quote newQuote : newQuotes) {
            if (newQuote.Status == 'Aprovada' && oldMap.get(newQuote.Id).Status != 'Aprovada') {
                quoteIds.add(newQuote.Id);
            }
        }

        if (!quoteIds.isEmpty()) {
            // Busca as cotações aprovadas no banco de dados
            Map<Id, Quote> quotesMap = QuoteDA.getQuotesMapByIds(new List<Id>(quoteIds));
            
            for (Quote newQuote : newQuotes) {
                if (quotesMap.containsKey(newQuote.Id)) {
                    // Obtém a cotação sincronizada
                    Quote quoteFromMap = quotesMap.get(newQuote.Id);
                    
                    // Verifica se o campo Empreendimento__c está preenchido
                    if (quoteFromMap.Empreendimento__c != null && quoteFromMap.Produto__c != null && quoteFromMap.Bloco__c != null) {
                        // Define os valores a serem atualizados na Oportunidade
                        Opportunity opp = new Opportunity(
                            Id = newQuote.OpportunityId,
                            Amount = newQuote.GrandTotal,
                            Empreendimento__c = quoteFromMap.Empreendimento__c,
                            Produto__c = quoteFromMap.Produto__c,
                            Bloco__c = quoteFromMap.Bloco__c,
                            Sincronizado__c = true
                        );
                        
                        opportunitiesToUpdate.add(opp);
                        
                        // Adiciona o ID do dono da oportunidade à lista de destinatários
                        recipientsIds.add(opp.OwnerId);
                        
                        // Busca o corretor associado à oportunidade
                        List<User> corretorList = [SELECT Id, Name, Reportase__c, Coordenador__c FROM User WHERE Id = :opp.OwnerId LIMIT 1];
                        if (!corretorList.isEmpty()) {
                            User corretor = corretorList[0];
                            recipientsIds.add(corretor.Id);
                            
                            if (corretor.Reportase__c != null) {
                                recipientsIds.add(corretor.Reportase__c);
                                System.debug('Reporta-se adicionado: ' + corretor.Reportase__c);
                            }
                            if (corretor.Coordenador__c != null) {
                                recipientsIds.add(corretor.Coordenador__c);
                            }
                        } else {
                            System.debug('Corretor não encontrado para a oportunidade: ' + opp.Id);
                        }                        
                        
                        System.debug('Cotação sincronizada: ' + newQuote.Id + ', Empreendimento__c: ' + quoteFromMap.Empreendimento__c);
                    } else {
                        System.debug('A cotação não possui Empreendimento__c, Bloco__c ou Produto__c definido: ' + newQuote.Id);
                    }
                }
            }
            
            // Atualiza as oportunidades com os novos valores
            if (!opportunitiesToUpdate.isEmpty()) {
                try {
                    update opportunitiesToUpdate;
                    System.debug('Oportunidades atualizadas: ' + opportunitiesToUpdate);
                } catch (DmlException e) {
                    System.debug('Erro ao atualizar oportunidades: ' + e.getMessage());
                }
            }
            
            // Adiciona os produtos da cotação à oportunidade
            addQuoteProductsToOpportunities(new List<Id>(quoteIds));
            
            // Envia as notificações
            if (!recipientsIds.isEmpty()) {
                try {
                    sendCustomNotification(recipientsIds, newQuotes[0].OpportunityId);
                } catch (Exception e) {
                    System.debug('Erro ao enviar notificações: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString());
                }
            }
        }
    }

    public static void addQuoteProductsToOpportunities(List<Id> quoteIds) {
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
        for (Id quoteId : quoteIds) {
            List<QuoteLineItem> quoteLineItems = QuoteDA.getQuoteLineItemsByQuoteId(quoteId);
            
            for (QuoteLineItem qli : quoteLineItems) {
                OpportunityLineItem oli = new OpportunityLineItem(
                    OpportunityId = qli.Quote.OpportunityId,
                    PricebookEntryId = QuoteDA.getOrCreatePricebookEntryId(qli.Product2Id, qli.PricebookEntryId),
                    Quantity = qli.Quantity,
                    UnitPrice = qli.UnitPrice
                );
                oppLineItems.add(oli);
            }
        }
        
        if (!oppLineItems.isEmpty()) {
            try {
                insert oppLineItems;
                System.debug('Itens de Oportunidade inseridos: ' + oppLineItems);
            } catch (DmlException e) {
                System.debug('Erro ao inserir itens de Oportunidade: ' + e.getMessage());
            }
        }
    }

    public static void sendCustomNotification(Set<String> recipientsIds, String targetId) {
        List<CustomNotificationType> notificationTypes = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName = 'CotacaoAprovada'];

        if (notificationTypes.isEmpty()) {
            System.debug('Nenhum tipo de notificação encontrado com o DeveloperName: CotacaoAprovada');
            return; // Saia da função se não houver tipos de notificação
        }

        // Use o primeiro tipo de notificação encontrado
        CustomNotificationType notificationType = notificationTypes[0];

        // Cria uma nova notificação personalizada
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Cotação Aprovada e Sincronizada');
        notification.setBody('A cotação foi aprovada e sincronizada com a oportunidade.');
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);
        
        // Envia a notificação
        try {
            notification.send(recipientsIds);
            System.debug('Notificações enviadas com sucesso para: ' + recipientsIds);
        } catch (Exception e) {
            System.debug('Erro ao enviar notificações: ' + e.getMessage() + ' StackTrace: ' + e.getStackTraceString());
        }
    }
}