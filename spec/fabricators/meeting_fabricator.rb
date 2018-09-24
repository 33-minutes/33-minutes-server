Fabricator(:meeting) do
  title { Faker::Company.bs.capitalize }
  started_at { Faker::Time.backward(1) }
  finished_at { Time.now }
  user { Fabricate(:user) }
  location '50.004444, 36.231389'
end
