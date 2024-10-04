public with sharing class QuoteDA {
    public static Map<Id, Quote> getQuotesMapByIds(List<Id> quoteIds) {
        return new Map<Id, Quote>([SELECT Id, OpportunityId, GrandTotal, Empreendimento__c, Produto__c, Bloco__c FROM Quote WHERE Id IN :quoteIds]);
    }

    public static Product2 getProductByQuoteId(Id quoteId) {
        QuoteLineItem lineItem = getFirstQuoteLineItemByQuoteId(quoteId);
        if (lineItem != null) {
            return [SELECT Id, Bloco__c FROM Product2 WHERE Id = :lineItem.Product2Id];
        }
        return null;
    }

    public static List<QuoteLineItem> getQuoteLineItemsByQuoteId(Id quoteId) {
        return [SELECT Id, QuoteId, Product2Id, Quantity, UnitPrice FROM QuoteLineItem WHERE QuoteId = :quoteId];
    }

    public static Id getOrCreatePricebookEntryId(Id productId, Id pricebookId) {
        List<PricebookEntry> pbeList = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :pricebookId];
        if (pbeList.isEmpty()) {
            PricebookEntry pbe = new PricebookEntry(
                Product2Id = productId,
                Pricebook2Id = pricebookId,
                UnitPrice = 0, 
                IsActive = true
            );
            insert pbe;
            return pbe.Id;
        }
        return pbeList[0].Id;
    }

    private static QuoteLineItem getFirstQuoteLineItemByQuoteId(Id quoteId) {
        List<QuoteLineItem> lineItems = [SELECT Id, Product2Id FROM QuoteLineItem WHERE QuoteId = :quoteId LIMIT 1];
        return lineItems.isEmpty() ? null : lineItems[0];
    }
}