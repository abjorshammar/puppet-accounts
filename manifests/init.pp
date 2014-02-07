class accounts (
  $groups = '',
  $users  = ''
  ) {

  # Create groups
  if $groups != '' {
    create_resources('accounts::groups', $groups)
  }
  # Create users
  if $users != '' {
    create_resources('accounts::users', $users)
  }
}