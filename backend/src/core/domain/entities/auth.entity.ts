import { Field, ObjectType } from "@nestjs/graphql";

@ObjectType()
export class RegisterUser {

    @Field((type) => String, {nullable: true})
    name : string;

    @Field((type) => String, {nullable: true})
    email : string;

    @Field((type) => String, {nullable: true})
    password : string;

    @Field((type) => String, {nullable: true})
    phone : string;

}