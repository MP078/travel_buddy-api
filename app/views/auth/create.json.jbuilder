json.message "Successfully registered"
json.user do
  json.id resource.id
  json.email resource.email
  json.name resource.name
  json.profile_image resource.avatar_url
end
