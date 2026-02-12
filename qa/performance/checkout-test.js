import http from 'k6/http';
import { check, sleep, fail } from 'k6';
import { randomString } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';

export const options = {
  // Escenario: Flujo Completo de Venta
stages: [
    { duration: '10s', target: 20 }, 
    { duration: '40s', target: 20 }, 
    { duration: '10s', target: 0 }, 
],
thresholds: {
    http_req_duration: ['p(95)<2000'], 
    http_req_failed: ['rate<0.05'], 
},
};

const BASE_URL = 'http://host.docker.internal:3000/graphql';
const HEADERS = { 'Content-Type': 'application/json' };

// --- 1. SETUP: PREPARAR PRODUCTOS ---
export function setup() {
    const suffix = randomString(5);

  // A. Crear Categoría
    const catName = `Categoría_${suffix}`;
    let mCat = `mutation { createCategory(data: { name: "${catName}", description: "Temp K6" }) }`;
    let res = http.post(BASE_URL, JSON.stringify({ query: mCat }), { headers: HEADERS });
    if (res.status !== 200) fail("[Setup] Falló crear Categoría");

  // B. Crear Proveedor
    const provName = `Proveedor_${suffix}`;
    let mProv = `mutation { insertProvider(data: { name: "${provName}", email: "proveedor_${suffix}@test.com", phone: "123456789", description: "Descripción", country: "Ecuador" }) }`;
    res = http.post(BASE_URL, JSON.stringify({ query: mProv }), { headers: HEADERS });

  // C. Buscar IDs
    let qIds = `query { categories { id name } providers { id name } }`;
    res = http.post(BASE_URL, JSON.stringify({ query: qIds }), { headers: HEADERS });
    let body = JSON.parse(res.body);

    let cat = body.data.categories.find(c => c.name === catName);
    let prov = body.data.providers.find(p => p.name === provName);

    if (!cat || !prov) fail("Error recuperando IDs");

  // D. Crear Producto
    let prodName = `Prod_Venta_${suffix}`;
    let mProd = `
        mutation {
        insertProduct(data: {
            name: "${prodName}", price: 50.00, description: "descripción producto", stock: 10000, 
            category: "${cat.id}", provider: "${prov.id}", rating: 5, discount: 0, image: "img.jpg"
        })
        }
    `;
    http.post(BASE_URL, JSON.stringify({ query: mProd }), { headers: HEADERS });

    // E. Recuperar ID Producto
    let qProd = `query { products { id name } }`;
    res = http.post(BASE_URL, JSON.stringify({ query: qProd }), { headers: HEADERS });
    let prod = JSON.parse(res.body).data.products.find(p => p.name === prodName);

    if (!prod) fail("[Setup] No se encontró el producto creado");
    return { productId: prod.id }; 
}

// --- 2. FLUJO DE USUARIO ---
export default function (data) {
    const uniqueId = randomString(8);
    const email = `usuario_${uniqueId}@test.com`;
    const password = "123123456";

  // 1. SIGNUP
    const mSignup = `mutation { singup(data: { name: "User ${uniqueId}", email: "${email}", password: "${password}", phone: "099", role: "user" }) }`;
    http.post(BASE_URL, JSON.stringify({ query: mSignup }), { headers: HEADERS });

  // 2. LOGIN
    const qLogin = `query { login(data: { email: "${email}", password: "${password}" }) { id } }`;
    let res = http.post(BASE_URL, JSON.stringify({ query: qLogin }), { headers: HEADERS });
    let userId = JSON.parse(res.body).data?.login?.id;

    if (userId) {
    // 3. CREAR CUSTOMER
    const mCust = `mutation { createCustomer(data: { name: "Cust ${uniqueId}", phone: "099", identification: "${uniqueId}", user: "${userId}" }) { id } }`;
    res = http.post(BASE_URL, JSON.stringify({ query: mCust }), { headers: HEADERS });
    let custId = JSON.parse(res.body).data?.createCustomer?.id;

    // ---  CREAR TARJETA DE CRÉDITO ---
    const mCard = `
    mutation {
        insertCreditCard(data: {
        creditCardName: "Visa test",
        creditCardNumber: "4111222233334444",
        creditCardExpirationDate: "12/30",
        creditCardCVC: "123",
        user: "${userId}"
        })
    }
    `;
    http.post(BASE_URL, JSON.stringify({ query: mCard }), { headers: HEADERS });

    // ---OBTENER EL ID DE LA TARJETA ---
    
    const qPay = `query { paymentMethods(id: "${userId}") { id } }`;
    res = http.post(BASE_URL, JSON.stringify({ query: qPay }), { headers: HEADERS });
    // Tomamos la primera tarjeta que aparezca
    let payMethodId = JSON.parse(res.body).data?.paymentMethods?.[0]?.id;

    if (custId && payMethodId) {
        const mSell = `
        mutation {
            createSell(sell: {
            address: "Av K6", zipCode: "1701", contactPhone: "099", city: "Quito", 
            paymentMethod: "${payMethodId}", 
            customer: "${custId}",
            products: [{ product: "${data.productId}", quantity: 1 }]
            })
        }
        `;
    res = http.post(BASE_URL, JSON.stringify({ query: mSell }), { headers: HEADERS });
    
    check(res, { 
        'Venta Exitosa': (r) => r.status === 200 && !JSON.parse(r.body).errors 
    });
    }
}

sleep(1);
}