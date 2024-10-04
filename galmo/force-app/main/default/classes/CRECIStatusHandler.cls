public class CRECIStatusHandler {
    public static void updateCRECIStatus(List<Contact> records) {
        Date dataAtual = Date.today();
        
        for (Contact record : records) {
            if (record.DataVencimento__c!= null) {
                if (record.DataVencimento__c>= dataAtual) {
                    record.CRECIAtivo__c = true;
                } else {
                    record.CRECIAtivo__c = false;
                }
            }
        }
    }
}