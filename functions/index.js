const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myfunction = onDocumentWritten("chat/{messageId}", (event) => {
  const after = event.data?.after;

  if (!after?.exists) {
    console.log("Document was deleted or does not exist.");
    return null;
  }

  const data = after.data();

  return admin.messaging().send({
    notification: {
      title: data.username || "New message",
      body: data.message || "",
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    topic: "chat",
  });
});