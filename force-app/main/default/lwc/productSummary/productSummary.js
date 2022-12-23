import { api, LightningElement, track, wire } from 'lwc';
import getCase from '@salesforce/apex/ProductSummaryController.getCase';
import getServiceProducts from '@salesforce/apex/ProductSummaryController.getServiceProducts';

export default class ProductSummary extends LightningElement {
    @api recordId;
    case = {};
    @track showSpinner = false;
    @track serviceProducts = [];
    @track isEmpty = false;
    

    //lifecycle hook fires when a component is inserted into the DOM
    connectedCallback(){
        //Enabling loading spinner
        this.showSpinner = true;
        getCase({caseId : this.recordId})
        .then(result => {
            console.log('Case:' + this.case);
            this.case = result;            
            this.getProducts();
            
        })
        .catch(error => {
            console.log('ERROR: ' +error);
            this.showSpinner = false;            
            this.case = undefined;
            this.serviceProducts = [];
            this.isEmpty = false;
            this.showToast('Error', error, 'error');
            
        });
    }

    getProducts(){
        getServiceProducts({c : this.case})
        .then(result => {
            console.log('serviceProducts: ' + this.serviceProducts);
            this.serviceProducts = result;            
            this.isEmpty = this.serviceProducts.length > 0 ? true : false;
            /*if(this.serviceProducts.length > 0){
                this.isEmpty = true;
            } */
            this.showSpinner = false;
        })
    }

    showToast(title, msg, type){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: msg,
                variant: type,
            }),
        );
    }

}