db.createUser(
  {
    user: "admin",
    pwd: "safe4now",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
