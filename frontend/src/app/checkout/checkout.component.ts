import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { StepperModule } from 'primeng/stepper';
import { ButtonModule } from 'primeng/button';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AppComponent } from '../app.component';
import { FloatLabelModule } from 'primeng/floatlabel';
import { InputTextModule } from 'primeng/inputtext';
import { MessageService } from 'primeng/api';
import { ShippingService } from '../services/shipping.service';
import { CatalogService } from '../services/catalog.service';
import { DropdownModule } from 'primeng/dropdown';
import { SelectModule } from 'primeng/select';
import {  ReactiveFormsModule } from '@angular/forms';
import { DataViewModule } from 'primeng/dataview';
import { DividerModule } from 'primeng/divider';
import { InputNumberModule } from 'primeng/inputnumber';


@Component({
  selector: 'app-checkout',
  imports: [
    StepperModule,
    ButtonModule,
    FormsModule,
    CommonModule,
    FloatLabelModule,
    InputTextModule,
    SelectModule,
    DataViewModule,
    DividerModule,
    InputNumberModule
  ],
  templateUrl: './checkout.component.html',
  styleUrl: './checkout.component.scss'
})
export class CheckoutComponent implements OnInit{

  @Input() cartItems : any = {};
  @Output() checkoutEvent = new EventEmitter<any>();
  

  session : any = {};
  countryCatalog : any = {};

  isValidAddressData : boolean = false;


  placesId : any = {}
  shippingData : any = {};


  customerData : any = {
    name: "",
    phone: "",
    identification: "",
    user : ""
  }

  paymentOptions : any = [
    {label: 'Card', value: 'card'},
    {label: 'Gift Card', value: 'giftCard'},
    {label: 'Paypal', value: 'paypal'},
  ]

  customerCreated : boolean = false;

  countryComboConfig : any = {};
  currentPayment : string = "";
  cardData : any = {};


  giftCard : string = "";


  constructor(
    private appComponent : AppComponent,
    private messageService : MessageService,
    private shippingService : ShippingService,
    private catalogService : CatalogService
  ){
  }

  ngOnInit(): void {
    this.catalogService.getCountryCatalog()
    .subscribe((data : any) => {
      console.log('country catalog: ',data.data);
      this.countryCatalog = data;
      this.countryComboConfig = data.data.countries
      .map((country : any) => {
        return {
          label: country.name,
          value: country.states.map((state : any) => {
            return {
              label: state.name,
              value: state.cities.map((city : any) => {
                return {
                  label: city.name,
                  value: city.id
                }
              })
            }
          })
        }
      });

      console.log('countryComboConfig: ',this.countryComboConfig);
    },
    (error) => {
      console.log('error: ',error);
    });

    console.log('cartItems: ',this.cartItems);

    this.session = JSON.parse(localStorage.getItem('loggedUser') || '{}');
    console.log('session: ',this.session);
    this.customerData.user = this.session.id;
  }

  changeCurrentView(view: string) : void {
    this.appComponent.currentView = view;
  }

  validateCustomerData() : boolean{
    if(this.customerData.name == "" || this.customerData.phone == "" || this.customerData.identification == ""){
      return false;
    }


    return true;

  }

  createCustomer() : void {
    this.shippingService.createCustomer(this.customerData).subscribe((data : any) => {
      console.log('customer created: ',data);
      this.messageService.add({severity:'success', summary:'Success', detail:'Customer created'});
      this.customerCreated = true;
    },
    (error) => {
      console.log('error: ',error);
      this.messageService.add({severity:'error', summary:'Error', detail:'Error creating customer'});
    })


  }

  validateShippingData() : boolean {
    if(!this.shippingData.street1 || !this.shippingData.street2
      || !this.shippingData.zipCode || !this.placesId.cityId
    ){
      return false;
    }
    return true;
  }


  

  removeItem(item: any) : void {
    const index = this.cartItems.indexOf(item);
    this.cartItems.splice(index, 1);
  }

  payWithPaypal() : void {
    console.log('paying with paypal');
  }

  

  


}
