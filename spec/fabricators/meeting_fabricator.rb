Fabricator(:meeting) do
  started_at { Faker::Time.backward(1) }
  finished_at { Time.now }
  user { Fabricate(:user) }
end
