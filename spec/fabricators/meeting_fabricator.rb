Fabricator(:meeting) do
  title { Faker::Company.bs.capitalize }
  started_at { Faker::Time.backward(1) }
  finished_at { Time.now }
  user { Fabricate(:user) }
end
