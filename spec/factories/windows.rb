FactoryBot.define do
  factory :window do
    association :channel
    position { 1 }
    html { "<iframe ::OPTIONS::></iframe>" }
    col { 0 }
    content_id { 1 }
  end
end
