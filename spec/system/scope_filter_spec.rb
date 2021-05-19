# frozen_string_literal: true

RSpec.describe 'Scope filter', type: :system do
  let(:posts) { Post.where(category: 'news') }

  it 'filters the posts by category (using the scope)' do
    visit '/admin/posts'

    fill_in('q[by_category]', with: 'news')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bby_category%5D=news.*}
    expect(posts.count).to be_positive
    expect(page).to have_css('.js-table-row', count: posts.count)
    posts.each do |post|
      expect(page).to have_css('.js-table-row a.action-show', text: post.title)
    end
  end
end
