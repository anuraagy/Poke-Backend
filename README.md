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
                        },
                        "activity": {
                          "reminders_created": [
                              {
                                  "id": 1,
                                  "title": "Wake Me Up",
                                  "description": "Make sure I don't sleep through my exam pls",
                                  "status": "New",
                                  "public": true,
                                  "push": false,
                                  "automated": false,
                                  "did_proxy_interact": false,
                                  "proxy_session_sid": null,
                                  "creator_id": 2,
                                  "caller_id": null,
                                  "caller_rating": null,
                                  "creator_rating": null,
                                  "will_trigger_at": "2019-04-15T00:00:00.000Z",
                                  "triggered_at": null,
                                  "job_id": 1,
                                  "created_at": "2019-04-09T20:24:58.511Z",
                                  "updated_at": "2019-04-09T20:24:58.548Z"
                              }
                          ],
                          "reminders_reminded": []
                      }
                    }
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Get user profile via email
----
  Gets user with email=email profile

* **URL**

  /users/:email

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
                        "activity": {
                          "reminders_created": [
                              {
                                  "id": 1,
                                  "title": "Wake Me Up",
                                  "description": "Make sure I don't sleep through my exam pls",
                                  "status": "New",
                                  "public": true,
                                  "push": false,
                                  "automated": false,
                                  "did_proxy_interact": false,
                                  "proxy_session_sid": null,
                                  "creator_id": 2,
                                  "caller_id": null,
                                  "caller_rating": null,
                                  "creator_rating": null,
                                  "will_trigger_at": "2019-04-15T00:00:00.000Z",
                                  "triggered_at": null,
                                  "job_id": 1,
                                  "created_at": "2019-04-09T20:24:58.511Z",
                                  "updated_at": "2019-04-09T20:24:58.548Z"
                              }
                          ],
                          "reminders_reminded": []
                      }
                    }
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Get user profile via id
----
  Gets user with id=id profile

* **URL**

  /users/profile_by_id/:id

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
                        "activity": {
                          "reminders_created": [
                              {
                                  "id": 1,
                                  "title": "Wake Me Up",
                                  "description": "Make sure I don't sleep through my exam pls",
                                  "status": "New",
                                  "public": true,
                                  "push": false,
                                  "automated": false,
                                  "did_proxy_interact": false,
                                  "proxy_session_sid": null,
                                  "creator_id": 2,
                                  "caller_id": null,
                                  "caller_rating": null,
                                  "creator_rating": null,
                                  "will_trigger_at": "2019-04-15T00:00:00.000Z",
                                  "triggered_at": null,
                                  "job_id": 1,
                                  "created_at": "2019-04-09T20:24:58.511Z",
                                  "updated_at": "2019-04-09T20:24:58.548Z"
                              }
                          ],
                          "reminders_reminded": []
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

### Get followed friends list
----
  Gets list of friends that a user is following. only accessible to current user.

* **URL**

  /users/:id/followed_friends

* **Method:**

  `GET`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "friends": [
                        {
                            "id": 2,
                            "email": "aj2@bienz.org",
                            "name": "AJ Bienz 2",
                            "bio": null,
                            "active": "t",
                            "phone_number": "12602233174",
                            "ready_to_remind": false,
                            "facebook_token": null,
                            "google_token": null,
                            "profile_picture": null,
                            "activity_hidden": false,
                            "device_token": null,
                            "created_at": "2019-04-09T20:05:40.029Z",
                            "updated_at": "2019-04-09T20:05:40.029Z"
                        }
                    ]
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "There is no user with that id", ... ]"
                    }```

### Get friends list
----
  Gets friends list for specified user

* **URL**

  /users/:id/friends

* **Method:**

  `GET`
  
*  **URL Params**

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{
                    "friends": [
                        {
                            "id": 2,
                            "email": "aj2@bienz.org",
                            "name": "AJ Bienz 2",
                            "bio": null,
                            "active": "t",
                            "phone_number": "12602233174",
                            "ready_to_remind": false,
                            "facebook_token": null,
                            "google_token": null,
                            "profile_picture": null,
                            "activity_hidden": false,
                            "device_token": null,
                            "created_at": "2019-04-09T20:05:40.029Z",
                            "updated_at": "2019-04-09T20:05:40.029Z"
                        }
                    ]
                }`

* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ "There is no user with that id", ... ]"
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

### Unfriend a user
----
  Unfriend user with id=friend_id

* **URL**

  /users/:id/unfriend

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
                      "errors": "[ "You are not friends with this user", ... ]"
                    }```

### Unfollow a user
----
  Unfollow user with id=friend_id. user must be friend of currently authenticated user.
  id param is current user id.

* **URL**

  /users/:id/unfollow

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
                      "errors": "[ "You are not friends with this user", ... ]"
                    }```

### Follow a user
----
  Follow user with id=friend_id. user must be friend of currently authenticated user.
  id param is current user id.

* **URL**

  /users/:id/follow

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
                      "errors": "[ "You are not friends with this user", ... ]"
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

## Comments

### Create a comment
----
  Creates a comment

* **URL:** <br />
  /comments/

* **Method:** <br />
  `POST`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `user_id=[integer]`
  `reminder_id=[integer]`
  `content=[string]`



* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{ success: true } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Deletes a comment
----
  Deletes a comment

* **URL:** <br />
  /comments/:id

* **Method:** <br />
  `DELETE`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `id=[integer]`


* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{ success: true } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

## Likes

### Create a like
----
  Creates a like

* **URL:** <br />
  /likes/

* **Method:** <br />
  `POST`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `user_id=[integer]`
  `reminder_id=[integer]`


* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{ success: true } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```

### Deletes a like
----
  Deletes a like

* **URL:** <br />
  /likes/:id

* **Method:** <br />
  `DELETE`

* **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**: <br />
  **Required:**
  `id=[integer]`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{ success: true } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
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
  `automated=[boolean]`
  `friend_id=[integer]`

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
                      "push": false,
                      "automated": false,
                      "friend_id": null
                    } ```
 
* **Error Response:**
  * **Code:** 400, 404, etc <br />
    **Content:** ```{
                      "errors": "[ ... ]"
                    }```


### Create reminder with friend specified
Create a reminder with friend_id set to the id of the friend you wish to have remind you.
When the reminder triggers, the friend will receive a push notification with the following data
in the body/payload:
```{
{
    "type": "friend_reminder",
    "phone_number": "1xxxxxxxxxx",
    "reminder": {
        "id": 9,
        "title": "Wake Me Up",
        "description": "Make sure I don't sleep through my exam pls",
        ...
    }
}
}```
When the friend interacts with the reminder, they should be shown the reminder details and
promted to call the phone_number in the body.

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
----
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
  
  * **Headers**: <br />
  `Authorization: Bearer <auth_token>`

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


### Comments endpoint
----
  Get comments for a reminder

* **URL**

  /reminders/:id/comments

* **Method:**
  `POST`
  
  * **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**

   **Required:**
   `id=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{ 
                    "comments": [
                      { content: "Comment 1", user_id: 1, reminder_id: 1 }
                     ]
                  }`
  
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

### Likes endpoint
----
  Get likes for a reminder

* **URL**

  /reminders/:id/likes

* **Method:**
  `POST`
  
  * **Headers**: <br />
  `Authorization: Bearer <auth_token>`

*  **URL Params**

   **Required:**
   `id=[integer]`

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{ 
                    "likes": [
                      { user_id: 1, reminder_id: 1 }
                     ]
                  }`
  
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
