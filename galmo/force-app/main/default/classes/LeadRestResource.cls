@RestResource(urlMapping='/Lead/*')
global with sharing class LeadRestResource {

    
    public class LeadDto {
        public String LastName { get; set; }
        public String Company { get; set; }
        public String Email { get; set; }
        public String MobilePhone { get; set; }
        public String LeadSource { get; set; }
        public String Status { get; set; }

        public LeadDto(Lead lead) {
            this.LastName = lead.LastName;
            this.Company = lead.Company;
            this.Email = lead.Email;
            this.MobilePhone = lead.MobilePhone;
            this.LeadSource = lead.LeadSource;
            this.Status = lead.Status;
        }
    }

   
    public class CampaignDto {
        public String Name { get; set; }
        public String Type { get; set; }
        public String Status { get; set; }
        public Boolean IsActive { get; set; }

        public CampaignDto(Campaign campaign) {
            this.Name = campaign.Name;
            this.Type = campaign.Type;
            this.Status = campaign.Status;
            this.IsActive = campaign.IsActive;
        }
    }

  
    public class LeadCampaignDto {
        public LeadDto lead { get; set; }
        public CampaignDto campaign { get; set; }

        public LeadCampaignDto(LeadDto lead, CampaignDto campaign) {
            this.lead = lead;
            this.campaign = campaign;
        }
    }

  
    @HttpPost
    global static void doPost() {
        RestContext.response.statusCode = 400;
        RestContext.response.responseBody = Blob.valueOf('Ocorreu um erro inesperado.');

        List<LeadCampaignDto> createdLeads = new List<LeadCampaignDto>();
        List<String> errors = new List<String>();

        try {
            RestRequest req = RestContext.request;
            List<Object> leadsParamsObject = (List<Object>) JSON.deserializeUntyped(req.requestBody.toString());
            List<Map<String, Object>> leadsParams = new List<Map<String, Object>>();

            for (Object leadParam : leadsParamsObject) {
                leadsParams.add((Map<String, Object>) leadParam);
            }

            Set<String> processedLeads = new Set<String>();

            for (Map<String, Object> params : leadsParams) {
                String leadKey = String.valueOf(params);

                if (processedLeads.contains(leadKey)) {
                    errors.add('Falha: Um Lead idêntico já foi processado.');
                    continue;
                }

                processedLeads.add(leadKey);

                if (!validateRequiredFields(params, errors)) {
                    continue;
                }

                Lead potentialDuplicate = findPotentialDuplicate(params);

                if (potentialDuplicate != null) {
                    handleLeadReiteration(potentialDuplicate, params);
                    errors.add('Um Lead existente foi encontrado. ID do Lead: ' + potentialDuplicate.Id);
                    continue;
                }

                Lead newLead = createNewLead(params);

                Campaign campaign = findOrCreateCampaign(params);

                if (campaign == null) {
                    return;
                }

                CampaignDto campaignDto = new CampaignDto(campaign);
                LeadDto leadDto = new LeadDto(newLead);
                LeadCampaignDto leadCampaignDto = new LeadCampaignDto(leadDto, campaignDto);
                createdLeads.add(leadCampaignDto);

                createCampaignMember(newLead, campaign);
            }

            if (errors.isEmpty()) {
                RestContext.response.statusCode = 201;
                RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(createdLeads));
            } else {
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf(String.join(errors, '\n'));
            }

        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Falha: ' + e.getMessage());
        }
    }

   
    private static Boolean validateRequiredFields(Map<String, Object> params, List<String> errors) {
        Map<String, String> requiredFields = new Map<String, String>{
            'LastName' => 'Sobrenome',
            'Company' => 'Empresa',
            'LeadSource' => 'Fonte do Lead',
            'CanalAtendimento__c' => 'Canal de Atendimento',
            'EmpreendimentoInteresseLead__c' => 'Empreendimento de Interesse',
            'MobilePhone' => 'Telefone',
            'Status' => 'Status'
        };

        for (String fieldName : requiredFields.keySet()) {
            if (!params.containsKey(fieldName) || String.isBlank((String) params.get(fieldName))) {
                errors.add('Campo obrigatório ausente: ' + requiredFields.get(fieldName));
                return false;
            }
        }
        return true;
    }
  
    private static Lead findPotentialDuplicate(Map<String, Object> params) {
        return LeadDA.findPotentialDuplicateLeads(params).isEmpty() ? null : LeadDA.findPotentialDuplicateLeads(params)[0];
    }

   
    private static void handleLeadReiteration(Lead existingLead, Map<String, Object> params) {
        LeadHelper.handleLeadReiteration(existingLead, params);
    }

   
    private static Lead createNewLead(Map<String, Object> params) {
        Lead newLead = new Lead();

        for (String fieldName : params.keySet()) {
            if (!fieldName.equalsIgnoreCase('campaignName')) {
                newLead.put(fieldName, params.get(fieldName));
            }
        }

        newLead.QuantidadeReiteracoes__c = 0;
        insert newLead;

        return newLead;
    }

   
    private static Campaign findOrCreateCampaign(Map<String, Object> params) {
        String campaignName = params.containsKey('campaignName') ? (String) params.get('campaignName') : (String) params.get('LeadSource');

        Campaign campaign = LeadDA.findCampaignByName(campaignName);

        if (campaign == null) {
            RestContext.response.responseBody = Blob.valueOf('Falha: Não existe uma campanha com o nome ' + campaignName);
            return null;
        }

        if (!params.containsKey('campaignName')) {
            LeadDA.createCampaignIfNotExist(campaignName);
            campaign = LeadDA.findCampaignByName(campaignName);
        }

        return campaign;
    }

    
    private static void createCampaignMember(Lead newLead, Campaign campaign) {
        CampaignMember campaignMember = new CampaignMember(
            CampaignId = campaign.Id,
            LeadId = newLead.Id,
            Status = 'Enviado'
        );

        insert campaignMember;
    }
}