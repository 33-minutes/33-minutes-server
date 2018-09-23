Fabricator(:meeting) do
  title { Faker::Company.bs.capitalize }
  started_at { Faker::Time.backward(1) }
  finished_at { Time.now }
  user { Fabricate(:user) }
  location { { latitude: 22.3407, longitude: 114.2054 } }
end
