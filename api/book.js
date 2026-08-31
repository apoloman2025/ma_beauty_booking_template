export default async function handler(req, res) {
  // Enable CORS headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const botToken = "8988599878:AAFXlfmWoifsPkRGiMP0DfunNzAjUPtbC8M";
  let data = req.body;
  if (typeof data === 'string') {
    try { data = JSON.parse(data); } catch (_) {}
  }
  data = data || {};

  const clientChatId = data.chat_id || 397179760;
  const serviceName = data.service_name || "Japanese SMART Manicure + Gel";
  const masterName = data.master_name || "Elena Rostova";
  const dateStr = data.date || "31 August 2026";
  const timeStr = data.time || "14:15";
  const price = data.price || "240";
  const currency = data.currency || "AED";
  const clientName = data.client_name || "Dima";
  const clientPhone = data.client_phone || "+971 50 892 4192";
  const clientTg = data.client_tg || "@apoloman2014";

  const msg = `✨ <b>ВАША ЗАПИСЬ ПОДТВЕРЖДЕНА!</b>
━━━━━━━━━━━━━━━━━━━━
💇‍♀️ <b>Услуга:</b> ${serviceName}
👑 <b>Мастер:</b> ${masterName}
📅 <b>Дата:</b> ${dateStr} в ${timeStr}
💰 <b>Стоимость:</b> ${currency} ${price}
━━━━━━━━━━━━━━━━━━━━
👤 <b>Гость:</b> ${clientName} (${clientTg})
📞 <b>Телефон:</b> ${clientPhone}
━━━━━━━━━━━━━━━━━━━━
📍 <b>Локация:</b> LUMINA AESTHETICS • Dubai Marina Gate 2
<i>Мы забронировали для вас лучшее время! До встречи в салоне красоты! 💅✨</i>`;

  try {
    const tgRes = await fetch(`https://api.telegram.org/bot${botToken}/sendMessage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        chat_id: clientChatId,
        text: msg,
        parse_mode: 'HTML'
      })
    });
    const result = await tgRes.json();
    return res.status(200).json({ ok: true, result });
  } catch (err) {
    return res.status(500).json({ ok: false, error: err.toString() });
  }
}
