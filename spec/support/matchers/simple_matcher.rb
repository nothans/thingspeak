RSpec::Matchers.define :be_even do
  match do |given|
    given % 2 == 0
  end
end

RSpec::Matchers.define :have_ids_of do |objects|
  match do |given|
    (given.map(&:id)).sort == (objects.map(&:id)).sort
  end
end
