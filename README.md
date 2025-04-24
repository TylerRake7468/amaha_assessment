# README

1. Clone the repository.
2. cd amaha_assessment

3. bundle install

4. rails db:create
5. rails db:migrate

6. rails server


API DOCS::

[POST] http://127.0.0.1:3000/customers/import

Request: File upload through postman form-data, and hit the API
Example: file contains out of range data + in range data + duplicate user_id data


{"user_id": 1, "name": "Vivaan Sharma", "latitude": "-68.850431", "longitude": "-35.814792"}
{"user_id": 2, "name": "Aditya Singh", "latitude": "82.784317", "longitude": "-11.291294"}
{"user_id": 3, "name": "Ayaan Reddy", "latitude": "-35.328826", "longitude": "134.432403"}
{"user_id": 4, "name": "Atharv Jain", "latitude": "-9.744095", "longitude": "96.547815"}
{"user_id": 5, "name": "Rudra Roy", "latitude": "-5.555317", "longitude": "-34.804381"}
{"user_id": 25, "name": "Pratik", "latitude": "19.059507", "longitude": "72.851108"}
{"user_id": 2, "name": "Aryan Mishra", "latitude": "-71.739172", "longitude": "-126.649104"}
{"user_id": 3, "name": "Rudra Roy", "latitude": "-46.904458", "longitude": "-70.726153"}
{"user_id": 32, "name": "Manish", "latitude": "19.143192", "longitude": "72.950772"}

Response: Api will return customers who are in the range of 100km list with user_id and name. And in the error section it will give the line number which user_id record in file is duplicate one.


{
    "customers": [
        {
            "user_id": 25,
            "name": "Pratik"
        },
        {
            "user_id": 32,
            "name": "Manish"
        }
    ],
    "errors": [
        "Line 7: User has already been taken",
        "Line 8: User has already been taken"
    ]
}
