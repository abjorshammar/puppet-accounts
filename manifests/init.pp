class accounts {

  # Create groups
  $groups = hiera('accounts::groups')
  create_resources('accounts::groups', $groups)

  # Create users
  $users = hiera('accounts::users')
  create_resources('accounts::users', $users)
}
