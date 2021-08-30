const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.sendNotification = functions.https.onCall((data, context) => {
  const payload = {
    notification: {
      title: data["title"],
      body: data["description"],
    },
    data: {
      data_to_send: "msg_from_the_cloud",
    },
  };
  admin.messaging().sendToTopic(data["topic"], payload)
      .then((value) => {
        console.info("function executed succesfully");
        return {msg: "function executed succesfully"};
      })
      .catch((error) => {
        console.info("error in execution");
        console.log(error);
        return {msg: "error in execution"};
      });
});
