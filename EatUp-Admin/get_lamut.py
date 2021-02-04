
import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore


cred_location = 'C:\\Users\\fran-\\Desktop\\EatUp_project\\Admin\\admin_cred.json'

cred = credentials.Certificate(cred_location)

firebase_admin.initialize_app(cred)

client = firestore.client()


ref = client.collection('restaurants').document('x2Ferrcfiumw7xQ9QIhQ')

doc = ref.get()

f = open('lamut.json', 'w')

json.dump(doc.to_dict(), f)

f.close()

print('DONE')
