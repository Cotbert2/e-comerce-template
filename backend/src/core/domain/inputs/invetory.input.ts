import { Field, InputType } from "@nestjs/graphql";

/*

import { ICountry } from './places.interface'

export interface ICategory{
    id : string;
    name : string;
    description : string;
}

export interface IProvider{
    id : string;
    name : string;
    email : string;
    phone : string;
    description : string;
    country : ICountry;
}

export interface IProduct{
    id : string;
    name : string;
    price : number;
    description : string;
    stock : number;
    category : ICategory;
    provider : IProvider;
    rating : number;
    image : string;
}*/
@InputType('CategoryInput')
export class CategoryInput {
    @Field((type) => String, {nullable: true})
    name : string;

    @Field((type) => String, {nullable: true})
    description : string;
}


@InputType('ProviderInput')
export class ProviderInput {
    @Field((type) => String, {nullable: true})
    name : string;

    @Field((type) => String, {nullable: true})
    email : string;

    @Field((type) => String, {nullable: true})
    phone : string;

    @Field((type) => String, {nullable: true})
    description : string;

    @Field((type) => String, {nullable: true})
    country : string;
}

/*

export interface IProduct{
    id : string;
    name : string;
    price : number;
    description : string;
    stock : number;
    category : ICategory;
    provider : IProvider;
    rating : number;
    image : string;
}*/



@InputType('ProductInput')
export class ProductInput {
    @Field((type) => String, {nullable: true})
    name : string;

    @Field((type) => Number, {nullable: true})
    price : number;

    @Field((type) => String, {nullable: true})
    description : string;

    @Field((type) => Number, {nullable: true})
    stock : number;

    @Field((type) => String, {nullable: true})
    category : string;

    @Field((type) => String, {nullable: true})
    provider : string;

    @Field((type) => Number, {nullable: true})
    rating : number;

    @Field((type) => String, {nullable: true})
    image : string;
}