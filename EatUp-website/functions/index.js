const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

async function addOrderToHistory(data, restaurantUid, orderID, dataBefore) {
    var uid = data.userUid;
    delete data.userUid;
    delete data.sent;

    try {
        await db.doc(`order-history/${uid}`).update({
            'processed': admin.firestore.FieldValue.arrayUnion(data),
            'waiting': admin.firestore.FieldValue.arrayRemove(dataBefore)
        });
    } catch (e) {
        await db.doc(`order-history/${uid}`).set({
            'processed': [data],
        });
    }

    data.userUid = uid;
    await addOrderToRestaurantHistory(data);
    return 0;
}

async function addOrderToRestaurantHistory(data) {
    const restaurantUid = data.restaurantUid;
    delete data.restaurantUid;

    var counterResponse = await db.doc(`restaurants/${restaurantUid}/orderHistory/counter`).get();

    if (!counterResponse.exists) {
        await db.doc(`restaurants/${restaurantUid}/orderHistory/counter`).set({
            'counter': 1,
            'length': 1
        });
        await db.doc(`restaurants/${restaurantUid}/orderHistory/orders1`).set({
            'list': [data]
        });
        return 0;
    }

    var counter = counterResponse.data().counter;
    var length = counterResponse.data().length;

    try {
        await db.doc(`restaurants/${restaurantUid}/orderHistory/orders${counter}`).update({
            'list': admin.firestore.FieldValue.arrayUnion(data),
        });
    } catch (e) {
        await db.doc(`restaurants/${restaurantUid}/orderHistory/orders${counter}`).set({
            'list': [data]
        });
    }

    var increments = {
        'length': admin.firestore.FieldValue.increment(1),
    };
    if (length >= 999) {
        increments['length'] = 0;
        increments['counter'] = admin.firestore.FieldValue.increment(1);
    }

    await db.doc(`restaurants/${restaurantUid}/orderHistory/counter`).update(increments);

    return 0;
}

async function sendIsProcessedToUser(data) {
    try {
        const title = "Vaša narudžba je " + (data.accepted == true ? "prihvaćena." : "odbijena.");

        const payload = {
            "notification": {
                "title": title,
                "body": data.restaurantNote,
                "click_action": "FLUTTER_NOTIFICATION_CLICK"
            },
            "data": {
                "accepted": data.accepted.toString(),
                "click_action": "FLUTTER_NOTIFICATION_CLICK"
            }
        };

        const querySnapshot = await db
            .collection('users')
            .doc(data.userUid)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        await admin.messaging().sendToDevice(tokens, payload)
    } catch (e) {
        functions.logger.log(">>> Push notification wasn't sent! <<< :: Here is the payload: ", payload);
        functions.logger.error(e);
    }
    return 0;
}

exports.orderUpdated = functions.region('europe-west1').firestore
    .document('restaurants/{restaurantUid}/orders/{orderID}')
    .onUpdate((change, context) => {
        const dataBefore = change.before.data();
        const data = change.after.data();

        if (data['sent'] == true) {
            return db.doc(`restaurants/${context.params.restaurantUid}/orders/${context.params.orderID}`).delete();
        }

        delete data.userName;
        delete data.phoneNumber;

        sendIsProcessedToUser(data);

        if (data['accepted'] == true) {
            return addOrderToHistory(data, context.params.restaurantUid, context.params.orderID, dataBefore);

        } else if (data['accepted'] == false) {
            return addOrderToHistory(data, context.params.restaurantUid, context.params.orderID, dataBefore);
        }
        return 0;
    });

async function orderIscreatedToRestaurant(restaurantUid) {
    try {
        const payload = {
            "notification": {
                "title": "Imate novu narudžbu!",
                "body": "Otvorite aplikaciju pogledajte narudžbu!",
                "click_action": "FLUTTER_NOTIFICATION_CLICK"
            },
            "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK"
            }
        };

        const querySnapshot = await db
            .collection('restaurants')
            .doc(restaurantUid)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        await admin.messaging().sendToDevice(tokens, payload)
    } catch (e) {
        functions.logger.log(">>> Push notification wasn't sent! <<< :: Here is the payload: ", payload);
        functions.logger.error(e);
    }
    return 0;
}

exports.orderCreated = functions.region('europe-west1').firestore
    .document('restaurants/{restaurantUid}/orders/{orderID}')
    .onCreate(
        async(snapshot, context) => {
            const data = snapshot.data();

            orderIscreatedToRestaurant(context.params.restaurantUid);

            try {
                await db.doc(`order-history/${data.userUid}`).update({
                    'waiting': admin.firestore.FieldValue.arrayUnion(data)
                });
            } catch (e) {
                await db.doc(`order-history/${data.userUid}`).set({
                    'waiting': [data]
                });
            }
            return 0;
        }
    );

exports.newRestaurant = functions.region('europe-west1').firestore
    .document('restaurants/{restaurantUid}')
    .onCreate(
        (snapshot, context) => {
            return db.doc(`restaurants/${context.params.restaurantUid}/orderHistory/counter`).set({
                'counter': 1,
                'length': 0
            });
        }
    );