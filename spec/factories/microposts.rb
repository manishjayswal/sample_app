FactoryBot.define do
    factory :micropost do
        user
        content { "lore ipsum" }
    end
end