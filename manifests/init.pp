class accounts {
  $users = hiera('accounts::users')
  create_resources('accounts::users', $users)
}
