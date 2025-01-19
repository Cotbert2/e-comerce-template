import { gql } from '@apollo/client/core';



/*

mutation Singup {
    singup(
        data: { name: null, email: null, password: null, phone: null, role: null }
    )
}*/
export const SINGUP = gql`
mutation Singup($data: UserInput!){
    singup(data: $data)
}
`;