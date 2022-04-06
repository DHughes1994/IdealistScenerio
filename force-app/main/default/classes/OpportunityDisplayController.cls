public class OpportunityDisplayController {

    @AuraEnabled
    public static List<OpportunityWrapper> getRelatedOpportunitiesWithContacts(Id accountId, String sortByField, String sortDirection){
        try {
            List<OpportunityContactRole> relatedContactRoles = new List<OpportunityContactRole>();
            String contactRoleQuery =
                'SELECT '
                    +'ContactId, Contact.Name, Role, OpportunityId, Opportunity.Name, Opportunity.StageName, Opportunity.CloseDate, Opportunity.Amount '
                +'FROM '
                    +'OpportunityContactRole '
                +'WHERE '
                    +'OpportunityId IN (SELECT Id FROM Opportunity WHERE AccountId = \''+accountId+ '\''+')';
            if (sortByField == 'closeDate') {
                contactRoleQuery += ' ORDER BY Opportunity.' +sortByField+' '+sortDirection;
            }
            if (sortByField == 'contactRoles') {
                contactRoleQuery += ' ORDER BY Role ' +sortDirection;
            }
            relatedContactRoles = Database.query(contactRoleQuery);
            Map<Id, OpportunityWrapper> formattedOpportunities = new Map<Id, OpportunityWrapper>();

            for (OpportunityContactRole relatedRole : relatedContactRoles) {
                OpportunityWrapper tempWrapper = new OpportunityWrapper();
                if (!formattedOpportunities.containsKey(relatedRole.OpportunityId)) {
                    tempWrapper.oppId = relatedRole.OpportunityId;
                    tempWrapper.name = relatedRole.Opportunity.Name;
                    tempWrapper.nameUrl = '/'+relatedRole.OpportunityId;
                    tempWrapper.stageName = relatedRole.Opportunity.StageName;
                    tempWrapper.amount = relatedRole.Opportunity.Amount;
                    tempWrapper.closeDate = relatedRole.Opportunity.CloseDate;
                    tempWrapper.contactRoles = '<a target="_blank" href = /' +relatedRole.ContactId+ '>' + relatedRole.Contact.Name +'</a>' + ' - ' + relatedRole.Role;
                    formattedOpportunities.put(relatedRole.OpportunityId, tempWrapper);
                }
                else {
                    formattedOpportunities.get(relatedRole.OpportunityId).contactRoles += '\n ' + '<a target="_blank" href = /'+relatedRole.ContactId+'>' + relatedRole.Contact.Name +'</a>' + ' - ' + relatedRole.Role;
                }
            }

            return formattedOpportunities.values();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private class OpportunityWrapper {
        @AuraEnabled
        public Id oppId {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String nameUrl {get;set;}
        @AuraEnabled
        public String stageName {get;set;}
        @AuraEnabled
        public Decimal amount {get;set;}
        @AuraEnabled
        public Date closeDate {get;set;}
        @AuraEnabled
        public String contactRoles {get;set;}
    }
}
