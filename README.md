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

### Report a user
----

Google login

* **URL**

  /users/report

* **Method:**

  `POST`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**

   **Required:**

   `reporter_id=[integer]`
   `reportee_id=[integer]`
   `reason=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                      "success": true
                  }`

* **Error Response:**


  * **Code:** 401 <br />
    **Content:** `{
                      "succes": false,
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

### Report a user
----
  Report a bad user

* **URL**

  /users/report

* **Method:**

  `POST`
  
*  **URL Params**
    `reporter_id=[integer]`
    `reportee_id=[integer]`
    `reason=[string]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```


### Send a friend request
----
  Send a friend request

* **URL**

  /users/:id/send_friend_request

* **Method:**

  `POST`
  
*  **URL Params**
    `friend_id=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### Accept a friend request
----
  Accept a friend request

* **URL**

  /users/:id/accept_friend_request

* **Method:**

  `POST`
  
*  **URL Params**
    `friend_request=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```


### Decline a friend request
----
  Decline a friend requests

* **URL**

  /users/:id/decline_friend_request

* **Method:**

  `POST`
  
*  **URL Params**
    `friend_request=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### View a list of friend requests received (pending)
----
  View a list of friend requests a user received

* **URL**

  /users/:id/friend_requests_received

* **Method:**

  `GET`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "friend_requests": [
                      { 
                        "id":1,
                        "sender_id":2,
                        "receiver_id":1,
                        "status":"sent",
                        "created_at": "2019-03-07T22:01:15.969Z",
                        "updated_at": "2019-03-07T22:01:15.969Z"
                      },
                      { 
                        "id":2,
                        "sender_id":2,
                        "receiver_id":1,
                        "status":"sent",
                        "created_at": "2019-03-07T22:01:15.969Z",
                        "updated_at": "2019-03-07T22:01:15.969Z"
                      }
                    ]
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```


### View a list of friend requests sent
----
  View a list of friend requests a user sends

* **URL**

  /users/:id/friend_requests_sent

* **Method:**

  `GET`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "friend_requests": [
                      { 
                        "id":1,
                        "sender_id":2,
                        "receiver_id":1,
                        "status":"sent",
                        "created_at": "2019-03-07T22:01:15.969Z",
                        "updated_at": "2019-03-07T22:01:15.969Z"
                      },
                      { 
                        "id":2,
                        "sender_id":2,
                        "receiver_id":1,
                        "status":"sent",
                        "created_at": "2019-03-07T22:01:15.969Z",
                        "updated_at": "2019-03-07T22:01:15.969Z"
                      }
                    ]
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### Search users
----
  Search through all users

* **URL**

  /users/search

* **Method:**

  `GET`
  
*  **URL Params**
  query=[string]

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "results": [
                      {
                        "id":1,
                        "email": "test@test.com",
                        "name":"Test",
                        "bio":null,
                        "active":"",
                        "phone_number":null,
                        "rating":"0.0",
                        "ready_to_remind":false,
                        "facebook_token":null,
                        "google_token":null,
                        "profile_picture":null,
                        "activity_hidden":false,
                        "created_at":"2019-03-03T03:53:05.460Z",
                        "updated_at":"2019-03-03T03:53:05.460Z"
                      },
                      {
                        "id":1,
                        "email": "test@test.com",
                        "name":"Test",
                        "bio":null,
                        "active":"",
                        "phone_number":null,
                        "rating":"0.0",
                        "ready_to_remind":false,
                        "facebook_token":null,
                        "google_token":null,
                        "profile_picture":null,
                        "activity_hidden":false,
                        "created_at":"2019-03-03T03:53:05.460Z",
                        "updated_at":"2019-03-03T03:53:05.460Z"
                      },..
                    ]
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### View friend activity
----
  View friends activity

* **URL**

  /users/:id/friend_activity

* **Method:**

  `GET`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "friend_activity": [
                        "John Smith": {
                            "reminders_created": [
                              {
                                "id:" 1,
                                "title": "New",
                                "public": true,
                                "status": "New"
                                "creator_id": 1,
                                "caller_id": 2,
                                "will_trigger_at": "2018-10-12T00:00:00Z",
                              }
                            ],
                            "reminders_reminded": [
                              {
                                "id:" 1,
                                "title": "New",
                                "public": true,
                                "status": "New"
                                "creator_id": 1,
                                "caller_id": 2,
                                "will_trigger_at": "2018-10-12T00:00:00Z",
                              }
                            ]
                        }
                    ]
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### Hide Profile Activity
----
  Hides a user's profile activity

* **URL**

  /users/:id/hide_profile_activity

* **Method:**

  `POST`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
                  }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "User not found", ... ]"
                    }```

### Show Profile Activity
----
  Shows the user's profile activity

* **URL**

  /users/:id/hide_profile_activity

* **Method:**

  `POST`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "success": true
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