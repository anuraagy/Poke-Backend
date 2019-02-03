## API Uri
http://167.99.154.236:3001//api/v1/

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
  `description=[string]`
  `status=[string]`
  `public=[boolean]`
  `creator_id=[integer]`
  `will_trigger_at=[datetime]`

* **Success Response:**
  * **Code:** 200 <br />
    **Content:** ```{
                      "id:" 1,
                      "public": true,
                      "status": "New"
                      "creator_id": 1,
                      "caller_id": null,
                      "will_trigger_at": "2018-10-12T00:00:00Z",
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