import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';
import { PaymentsService } from './payments.service';
import { CardInput, GiftCardCreationInput, GiftCardResgitrationInput } from 'src/core/domain/inputs/payments.intpu';
// Removed incorrect import
import { PaymentMethod } from 'src/core/domain/entities/payments.entity';

@Resolver()
export class PaymentsResolver {

    constructor(
        private readonly paymentService: PaymentsService
    ){

    }


    @Query(() => [PaymentMethod])
    public async paymentMethods(
        @Args('id') id: string
    ) {
        return await this.paymentService.getPaymentMethodsByUserId(id);
    }


    @Mutation(() => Boolean)
    public async insertCreditCard(
        @Args('data', {type: () => CardInput}) data: CardInput
    ) {
        return await this.paymentService.newPaymentMethods(data,'credit-card');
    }


    @Mutation(() => Boolean)
    public async insertDebitCard(
        @Args('data', {type: () => CardInput}) data: CardInput
    ) {
        return await this.paymentService.newPaymentMethods(data,'debit-card');
    }


    @Mutation(() => Boolean)
    public async insertGiftCard(
        @Args('data', {type: () => GiftCardCreationInput}) data: GiftCardCreationInput
    ) {
        return await this.paymentService.createGiftCard(data);
    }



    @Mutation(() => Boolean)
    public async registerGiftCard(
        @Args('data', {type: () => GiftCardResgitrationInput}) data: GiftCardResgitrationInput
    ) {
        return await this.paymentService.registerGiftCard(data);
    }
    
}
