import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-product-view',
  imports: [],
  templateUrl: './product-view.component.html',
  styleUrl: './product-view.component.scss'
})
export class ProductViewComponent {

  @Input() product : any = {};

  constructor(){
    
  }

}
