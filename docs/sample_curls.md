## Sample Curls for Local Testing

### User APIs
#### Create New User
`curl --location 'localhost:3000/api/v1/users' \
--header 'Content-Type: application/json' \
--data '{
    "name": "mochi"
}'`

### Follower APIs
#### List followers
`curl --location 'localhost:3000/api/v1/followers?user_id=2&limit=10&offset=0'`

#### Show followership details
`curl --location 'localhost:3000/api/v1/followers/2'`

#### List followed users
`curl --location 'localhost:3000/api/v1/followers/followings?user_id=1&limit=10&offset=0'`

#### Follow a user
`curl --location 'localhost:3000/api/v1/followers/follow' \
--header 'Content-Type: application/json' \
--data '{
    "user_id": 90,
    "follower_user_id": 91
}'`

#### Unfollow a user
`curl --location --request DELETE 'localhost:3000/api/v1/followers/140/unfollow'`

### Sleep APIs
#### List a user's sleep records
`curl --location 'localhost:3000/api/v1/sleeps?user_id=2'`

#### Show sleep details
`curl --location 'localhost:3000/api/v1/sleeps/40'`

#### List followed users' sleep records
`curl --location 'localhost:3000/api/v1/sleeps/followings?user_id=2&limit=100&offset=0'`

#### Clock in sleep
`curl --location 'localhost:3000/api/v1/sleeps' \
--header 'Content-Type: application/json' \
--data '{
    "user_id": 1,
    "start": "2025-01-22 22:23:40.400778000 WIB +07:00",
    "end": "2025-01-23 22:23:44.400778000 WIB +07:00"
}'`

#### Update sleep
`curl --location --request PATCH 'localhost:3000/api/v1/sleeps/77' \
--header 'Content-Type: application/json' \
--data '{
    "start": "2025-01-22T20:19:40+07:00",
    "end": "2025-01-23T22:23:44.40+07:00"
}'`

#### Delete sleep
`curl --location --request DELETE 'localhost:3000/api/v1/sleeps/40'`
