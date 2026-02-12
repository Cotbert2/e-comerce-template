import http from 'k6/http';
import { check, sleep } from 'k6';

// 1. Configuración de Escenarios y Thresholds
export const options = {
    stages: [
        { duration: '30s', target: 50 }, //  50 usuarios
        { duration: '1m', target: 50 },  // carga constante
        { duration: '20s', target: 0 },  // Bajada
    ],
    thresholds: {
        http_req_duration: ['p(95)<1500'], // El 95% debe responder en 1,5 segundos
        http_req_failed: ['rate<0.01'],   // Menos del 1% de errores permitidos
    },
};

const BASE_URL = 'http://host.docker.internal:3000/graphql';

export default function () {
    const query = `
        query {
        categories {
            id
            name
        }
        products {
            id
            name
            price
            stock
            image
            category {
                name
            }
        }
        }
    `;
    // 2. Peticiones
    const headers = { 'Content-Type': 'application/json' };
    const res = http.post(BASE_URL, JSON.stringify({ query: query }), { headers });

    // 3. Validaciones
    check(res, {
        'status es 200': (r) => r.status === 200,
        'sin errores de GraphQL': (r) => !JSON.parse(r.body).errors,
        'tiempo respuesta < 800ms': (r) => r.timings.duration < 800,
    });

    sleep(Math.random() * 2);
}