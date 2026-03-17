FactoryBot.define do
  factory :api_key do
    api_key { "0S5G2O7FAB5K0J6Z" }
    write_flag { true }
    association :channel
    association :user
  end
end
