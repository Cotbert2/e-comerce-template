import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { StepperModule } from 'primeng/stepper';
import { ButtonModule } from 'primeng/button';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AppComponent } from '../app.component';

@Component({
  selector: 'app-checkout',
  imports: [
    StepperModule,
    ButtonModule,
    FormsModule,
    CommonModule
  ],
  templateUrl: './checkout.component.html',
  styleUrl: './checkout.component.scss'
})
export class CheckoutComponent implements OnInit{

  

  @Input() cartItems : any = {};
  @Output() checkoutEvent = new EventEmitter<any>();

  session : any = {};

  constructor(
    private appComponent : AppComponent
  ){
  }

  ngOnInit(): void {
    this.session = JSON.parse(localStorage.getItem('loggedUser') || '{}');
    console.log('session: ',this.session);
  }

  changeCurrentView(view: string) : void {
    this.appComponent.currentView = view;
  }

}
