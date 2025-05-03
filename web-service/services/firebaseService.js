const admin = require('firebase-admin');
const serviceAccount = require('../config/firebase-admin-sdk.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const sendNotificationToUser = async (fcmToken, title, body, data = {}) => {
  const message = {
    token: fcmToken,
    notification: {
      title,
      body,
    },
    android: {
      priority: "high",
      notification: {
        channelId: "high_importance_channel", // pastikan cocok dengan Flutter
        sound: "default",
        notificationCount: 1,
      },
    },
    apns: {
      headers: {
        'apns-priority': '10',
      },
      payload: {
        aps: {
          alert: {
            title,
            body,
          },
          sound: 'default',
        },
      },
    },
    data: {
      ...data,
      click_action: "FLUTTER_NOTIFICATION_CLICK", // agar Flutter bisa tangkap
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ Notifikasi berhasil dikirim:', response);
  } catch (error) {
    console.error('❌ Gagal mengirim notifikasi:', error);
  }
};

module.exports = { sendNotificationToUser };
