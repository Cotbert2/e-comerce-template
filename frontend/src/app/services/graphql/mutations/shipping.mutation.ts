import { gql } from '@apollo/client/core';


export const createCustomer = gql`
mutation CreateCustomer($data: CustomerInput!){
    createCustomer(data: $data)
}
`;