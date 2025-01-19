import { gql } from '@apollo/client/core';

export const ProductsQuery = gql`
query Products {
    products {
        id
        name
        price
        description
        stock
        rating
        discount
        image
        category {
            id
            name
            description
        }
        provider {
            id
            name
            email
            phone
            description
            country
        }
    }
}
`;