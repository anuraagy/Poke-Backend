## API Uri
http://167.99.154.236:3005/api/v1/

## Users

### Register User
----
  Creates a user and returns the jwt

* **URL**

  /users/register

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**

   `name=[string]`
   `email=[string]`
   `password=[string]`
   **Optional:**
   `device_token[string] (APNs)`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "auth_token": "eyJhbGciOiJIUzI1NiJ9.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo"
                  }`
  
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{
                      "errors": {
                          [
                            "Email has been taken",
                            "Name too short",
                            ..
                          ]
                      }
                  }`

### Update User Account Info
----
  Updates a user and returns the jwt

* **URL**

  /users/:id

* **Method:**

  `PUT`
  
*  **URL Params**
   `profile_picture=[string]`
   `name=[string]`
   `bio=[string]`
   `phone_number=[string]`
   `device_token[string] (APNs)`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "auth_token": "eyJhbGciOiJIUzI1NiJ9.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo"
                  }`
  
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{
                      "errors": {
                          [
                            "Email has been taken",
                            "Name too short",
                            ..
                          ]
                      }
                  }`

### Change user password
----
  Given old and new password, change user password

* **URL**

  /users/:id

* **Method:**

  `POST`
  
*  **URL Params**
   `old_password=[string]`
   `new_password=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`
  
* **Error Response:**

  * **Code:** 403 <br />
    **Content:** `{
                    "errors": [
                      "The old password you entered is incorrect."
                    ]
                  }`

### Get profile picture
----
  Get user profile picture given email

* **URL**

  /users/:email/profile_picture

* **Method:**

  `GET`
  
*  **URL Params**
   `email=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "profile_picture": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQIAH..."
                  }`
  
* **Error Response:**

  * **Code:** 400 <br />
    **Content:** `{
                      "errors": {
                          [
                            "User not found",
                            ...
                          ]
                      }
                  }`

### Authenticate User
----
  Authenticates a user and returns their jwt

* **URL**

  /users/authenticate

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**

   `email=[string]`
   `password=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "auth_token": "eyJhbGciOiJIUzI1NiJ9.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo"
                  }`

* **Error Response:**


  * **Code:** 401 <br />
    **Content:** `{
                      "errors": "Invalid email or password submitted"
                  }`

### Login a facebook user
----

Facebook login

* **URL**

  /users/facebook

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**

   `name=[string]`
   `email=[string]`
   `facebook_token=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "auth_token": "eyJhbGciOiJIUzI1NiJ9.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo"
                  }`

* **Error Response:**


  * **Code:** 401 <br />
    **Content:** `{
                      "errors": "This is an invalid authtoken!"
                  }`

### Login a google user
----

Google login

* **URL**

  /users/google

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**

   `name=[string]`
   `email=[string]`
   `google_token=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "auth_token": "eyJhbGciOiJIUzI1NiJ9.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo.7nefDjhCUnGeGGzr7ypoDtQTiLC66uNI8T8O7FGvnoo"
                  }`

* **Error Response:**


  * **Code:** 401 <br />
    **Content:** `{
                      "errors": "This is an invalid authtoken!"
                  }`



### Get current user profile
----
  Gets currently authenticated users profile

* **URL**

  /users

* **Method:**

  `GET`
  
*  **URL Params**
    `none`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "profile": {
                        "user": {
                            "id": 1,
                            "email": "a@b.com",
                            "name": "aj",
                            "bio": null,
                            "active": "t",
                            "rating": "0.0",
                            "created_at": "2019-02-07T18:36:39.945Z",
                            "updated_at": "2019-02-07T18:36:39.945Z"
                        },
                        "reminder_count": 1,
                        "active_reminders": 0,
                        "times_reminded_others": 0,
                        "next_reminder": {
                            "id": 1,
                            "title": "New",
                            "description": "test",
                            "status": "new",
                            "public": true,
                            "creator_id": 1,
                            "caller_id": null,
                            "will_trigger_at": "2019-02-07T18:50:00.000Z",
                            "triggered_at": null,
                            "created_at": "2019-02-07T18:41:33.056Z",
                            "updated_at": "2019-02-07T18:41:33.056Z"
                        }
                    }
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Get other user profile
----
  Gets user profile given email

* **URL**

  /users/:email

* **Method:**

  `GET`
  
*  **URL Params**
    `email=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "profile": {
                        "user": {
                            "id": 1,
                            "email": "a@b.com",
                            "name": "aj",
                            "bio": null,
                            "active": "t",
                            "rating": "0.0",
                            "created_at": "2019-02-07T18:36:39.945Z",
                            "updated_at": "2019-02-07T18:36:39.945Z"
                        },
                        "reminder_count": 1,
                        "active_reminders": 0,
                        "times_reminded_others": 0,
                    }
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

## Reminders

### Create reminder
----
  Creates a reminder with the current user as creator

* **URL:** <br />
  /reminders/

* **Method:** <br />
  `POST`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `title=[string]`
  `description=[string]`
  `status=[string]`
  `public=[boolean]`
  `creator_id=[integer]`
  `will_trigger_at=[datetime]`
  `push=[boolean]`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{
                      "id:" 1,
                      "title": "New",
                      "public": true,
                      "status": "New"
                      "creator_id": 1,
                      "caller_id": null,
                      "will_trigger_at": "2018-10-12T00:00:00Z",
                      "push": false
                    } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```


### Update reminder
----
  Update a reminder with the current user as creator

* **URL:** <br />
  /reminders/:id

* **Method:** <br />
  `PUT`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `id=[integer]`
  `description=[string]`
  `status=[string]`
  `public=[boolean]`
  `creator_id=[integer]`
  `will_trigger_at=[datetime]`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{
                      "id:" 1,
                      "title": "New",
                      "public": true,
                      "status": "New"
                      "creator_id": 1,
                      "caller_id": 2,
                      "will_trigger_at": "2018-10-12T00:00:00Z",
                    } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Reminder History
----
  Get reminder history for currently authenticated user

* **URL:** <br />
  /reminders

* **Method:** <br />
  `GET`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  none

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```[{
                      "id:" 1,
                      "title": "New",
                      "public": true,
                      "status": "New"
                      "creator_id": 1,
                      "caller_id": 2,
                      "will_trigger_at": "2018-10-12T00:00:00Z",
                    }, ... ] ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Get specific reminder
----
  Get reminder of id for currently authenticated user

* **URL:** <br />
  /reminders/:id

* **Method:** <br />
  `GET`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required**
  `id=[integer]`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{
                        reminder: {
                            "id:" 1,
                            "title": "New",
                            "public": true,
                            "status": "New"
                            "creator_id": 1,
                            "caller_id": 2,
                            "will_trigger_at": "2018-10-12T00:00:00Z",
                        }
                    }```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Delete reminder
----
  Delete a reminder with the current user as creator

* **URL:** <br />
  /reminders/:id

* **Method:** <br />
  `DELETE`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `id=[integer]`


* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{ 
                      success: true 
                    } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```


## Twilio

### Get Twilio access token
----
  Gets a Twilio access token for currently authenticated user

* **URL**

  /twilio/access_token

* **Method:**

  `POST`
  
*  **URL Params**

   **Required:**
   `type=[string] ('voice' or 'chat')`
   

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
  "access_token": "eyJ...",
  "type": "voice"
}`
  
* **Error Response:**

  * **Code:** 401 <br />
    **Content:** `{
                      "errors": {
                          [
                            "...",
                            "...",
                            ..
                          ]
                      }
                  }`

### Call masking
To enable call masking, MASKING_ENABLED should be set as an environment variable on the server.
It can be set to anything, but 'true' would be a good choice. Then, when a reminder is triggered,
the server will interface with Twilio to create a proxy session and add the creator and caller
to the proxy session as participants. The number returned to the caller will then be a masked
number returned by Twilio. When the caller calls this number, they will be routed to the reminder
creator. By default, the Twilio proxy session expires three minutes after its creation. It will
also be closed after the call is ended. Additionally, if no interactions are made on the proxy
before the session expires (if the reminding user does not follow through), a push notification
will be sent to the creator.

The same is done for text reminders.

## Push notifications
If a user creates a reminder with push=true, the backend will verify that the user has
an APNs device_token specified. If not, an error will be sent back during reminder creation.

When the reminder triggers, a push notification is sent via Apple with the following alert:
'Don't forget! {reminder title}'

and the reminder in the payload. E.g.:
```
{
    "id:" 1,
    "title": "Wake up",
    "public": true,
    "push": true,
    "status": "triggered"
    "creator_id": 1,
    "caller_id": null,
    "will_trigger_at": "2018-10-12T00:00:00Z",
}
```

## Ratings
### Get unrated reminders
----
  Get triggered reminders where the current user is a party and has not yet rated the interaction

* **URL:** <br />
  /reminders/unrated

* **Method:** <br />
  `GET`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  none

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```[{
                      "id:" 1,
                      "title": "New",
                      "public": true,
                      "status": "New"
                      "creator_id": 1,
                      "caller_id": 2,
                      "will_trigger_at": "2018-10-12T00:00:00Z",
                    }, ... ] ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Rating endpoint
----
  Assign a rating to a reminder that the user is a part of. If the user was creator, then set
  the caller's rating, and if the user was the caller, set the creator rating.

* **URL**

  /reminders/rating

* **Method:**
  `POST`
  
*  **URL Params**

   **Required:**
   `ids=[integer []]`
   `ratings=[integer[], 1 to 5]`
   rating for id[i] is at rating[i]
   

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{ "success": true }`
  
* **Error Response:**

  * **Code:** 400 <br />
    **Content:** `{
                    "errors": {
                      [
                        "Reminder does not exist or you do not have access",
                        "...",
                        ..
                      ]
                    }
                  }`
