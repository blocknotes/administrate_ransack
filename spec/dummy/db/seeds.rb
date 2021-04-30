puts 'Seeds:'

unless Tag.any?
  puts 'Tags...'
  (11..35).each do |i|
    Tag.create!(name: "Tag #{i}")
  end
end

unless Author.any?
  puts 'Authors...'
  (11..20).each do |i|
    age = 21 + 3 * (i - 10)
    attrs = { name: "Author #{i}", age: age, email: "some@email#{i}.com" }
    attrs[:profile] = Profile.new(description: "Profile description for Author #{i}") if (i % 3).zero?
    Author.create!(attrs)
  end
end

unless Post.any?
  puts 'Posts...'
  authors = Author.pluck(:id)
  tags = Tag.pluck(:id)
  (11..40).each do |i|
    attrs = { author: Author.find(authors.sample), title: "Post #{i}" }
    attrs[:tags] = Tag.find(tags.sample(3)) if (i % 2).zero?
    Post.create!(attrs)
  end
end

puts 'done.'
