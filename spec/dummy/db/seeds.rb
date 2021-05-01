puts 'Seeds:'

puts 'Tags...'
(11..16).each do |i|
  Tag.find_or_create_by!(name: "Tag #{i}")
end

puts 'Authors...'
(11..20).each do |i|
  age = 21 + 3 * (i - 10)
  attrs = { name: "Author #{i}", age: age, email: "some@email#{i}.com" }
  attrs[:profile] = Profile.new(description: "Profile description for Author #{i}") if (i % 3).zero?
  Author.find_or_create_by!(attrs)
end

puts 'Posts...'
authors = Author.pluck(:id)
tags = Tag.pluck(:id)
(11..40).each do |i|
  attrs = {
    title: "Post #{i}",
    author: Author.find(authors.sample),
    position: rand(100),
    created_at: Time.now - rand(3600).seconds
  }
  attrs[:category] = 'news' if (i % 4).zero?
  attrs[:dt] = Time.now - rand(30).days if (i % 3).zero?
  attrs[:tags] = Tag.find(tags.sample(2)) if (i % 2).zero?
  Post.find_or_create_by!(attrs)
end

puts 'done.'
