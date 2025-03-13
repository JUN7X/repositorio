const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const app = express();

// Usando JSON para os dados
app.use(bodyParser.json());

// Pegando as variáveis de ambiente ou valores diretos
const SHOPEE_APP_ID = '18313610359'; // App ID Shopee
const SHOPEE_APP_SECRET = 'O6F7EENZ2FZE3IAGFN2C4R7S6QBDHN2T'; // Shopee Secret Key
const FACEBOOK_PIXEL_ID = '840837570802318'; // Pixel ID Facebook
const FACEBOOK_ACCESS_TOKEN = 'EAARCfEvzABoBOyOpboS7CADXgYAhZC7UzpaBJbxp9YN9NoLzylDf2zs5xeuVBl8fQiWqxmxFtBW63CthK48GLKiBpzhWdNGua8MMED3lWbiBIjqk0tVlvoMxAvhdUOeXbGg8x05Q3l1YMEZAMmKbH1jyDLTwge9nRrBllvl4SJ2iZATaVvTTV7ewa1ZB12VggQZDZD'; // Access Token Facebook

// Função para enviar dados para o Facebook Ads (via Pixel)
async function sendToFacebook(eventData) {
    try {
        const response = await axios.post(`https://graph.facebook.com/v11.0/${FACEBOOK_PIXEL_ID}/events`, {
            data: [
                {
                    event_name: eventData.event_name,
                    event_time: eventData.event_time,
                    user_data: eventData.user_data,
                    custom_data: eventData.custom_data
                }
            ],
            access_token: FACEBOOK_ACCESS_TOKEN
        });
        console.log('Evento enviado para o Facebook Ads:', response.data);
    } catch (error) {
        console.error('Erro ao enviar evento para o Facebook:', error);
        throw error;
    }
}

// Função para registrar eventos de conversão na Shopee
async function sendToShopee(conversionData) {
    try {
        const response = await axios.post('https://api.shopee.com/v1/conversion', {
            app_id: SHOPEE_APP_ID,
            app_secret: SHOPEE_APP_SECRET,
            conversion_data: conversionData
        });
        console.log('Evento de conversão enviado para a Shopee:', response.data);
    } catch (error) {
        console.error('Erro ao enviar evento para a Shopee:', error);
        throw error;
    }
}

// Rota para capturar e enviar eventos de conversão para o Facebook e Shopee
app.post('/track/conversion', async (req, res) => {
    const eventData = req.body;

    // Dados para o Facebook
    const facebookEventData = {
        event_name: eventData.event_name,  // Ex: 'PageView', 'ProductClick', 'Purchase'
        event_time: eventData.event_time,  // Timestamp do evento
        user_data: eventData.user_data,    // Informações sobre o usuário (email, telefone)
        custom_data: eventData.custom_data // Dados customizados (ex: valor da compra, produto clicado)
    };

    // Dados para a Shopee
    const shopeeEventData = {
        event_name: eventData.event_name,  // Nome do evento (ex: 'PageView', 'ProductClick')
        event_time: eventData.event_time,  // Timestamp do evento
        custom_data: eventData.custom_data // Dados extras (ex: valor da conversão, produto)
    };

    try {
        // Envia para o Facebook Ads
        await sendToFacebook(facebookEventData);

        // Envia para a Shopee
        await sendToShopee(shopeeEventData);

        res.status(200).send('Conversão processada com sucesso!');
    } catch (error) {
        res.status(500).send('Erro ao processar conversão');
    }
});

// Iniciar o servidor
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});
