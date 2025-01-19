import { Injectable } from '@angular/core';
import { Apollo } from 'apollo-angular';
import { ProductsQuery } from './graphql/queries/inventory.query';

@Injectable({
  providedIn: 'root'
})
export class InventoryService {

  constructor(

    private apollo: Apollo
  ) { }


  getProducts() {
    return this.apollo.query(
      {
        query: ProductsQuery,
      })
  }
}
