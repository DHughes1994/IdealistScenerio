import { api, LightningElement } from 'lwc';
import getRelatedOpportunitiesWithContacts from '@salesforce/apex/OpportunityDisplayController.getRelatedOpportunitiesWithContacts';

const columns = [
    { label: 'Opportunity', fieldName: 'nameUrl', type: 'url', typeAttributes: {label: { fieldName: 'name' }, target: '_blank'}, hideDefaultActions: true},
    { label: 'Stage', fieldName: 'stageName', type: 'text', hideDefaultActions: true},
    { label: 'Close Date', fieldName: 'closeDate', type: 'date-local', typeAttributes:{ month: '2-digit', day: '2-digit' }, sortable : true, hideDefaultActions: true},
    { label: 'Amount', fieldName: 'amount', type: 'currency', hideDefaultActions: true },
    { label: 'Contact Roles', fieldName: 'contactRoles', type: 'richText', typeAttributes: { linkify: 'True' }, wrapText: 'True', sortable : true, hideDefaultActions: true}
];

export default class OpportunityDisplay extends LightningElement {
    data = [];
    columns = columns;
    sortedBy = 'closeDate';
    sortedDirection = 'asc';

    @api recordId;

    connectedCallback(){
        getRelatedOpportunitiesWithContacts({
            accountId : this.recordId,
            sortByField : this.sortedBy,
            sortDirection : this.sortedDirection
        })
            .then(result => {
                this.data = result;
                this.testLine = this.data[0].contactRoles;
            })
            .catch(error => {
                this.error = error;
            });
    }

    updateColumnSorting(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        getRelatedOpportunitiesWithContacts({
            accountId : this.recordId,
            sortByField : this.sortedBy,
            sortDirection : this.sortedDirection
        })
            .then(result => {
                this.data = result;
                this.testLine = this.data[0].contactRoles;
            })
            .catch(error => {
                this.error = error;
            });
   }
}