json.success true
json.message "Registration successful"
json.user do
  json.extract! @resource, :id, :email, :name, :username
  json.avatar_url @resource.avatar_url
end
