
import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore


cred_location = 'C:\\Users\\fran-\\Desktop\\EatUp_project\\Admin\\admin_cred.json'

cred = credentials.Certificate(cred_location)

firebase_admin.initialize_app(cred)

client = firestore.client()

with open('lamut.json') as json_file:
    data = json.load(json_file)

ref = client.collection('restaurants').document('x2Ferrcfiumw7xQ9QIhQ')

ref.set(data)

print('DONE')
