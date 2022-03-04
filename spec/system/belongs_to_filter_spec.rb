# frozen_string_literal: true

RSpec.describe 'Belongs to filter', type: :system do
  let(:author) { Author.find_by!(name: 'A test author') }
  let(:posts) { Post.where(author: author) }

  it 'filters the posts by author' do
    visit '/admin/posts'

    find('.filter-author .selectize-input').click
    find(".filter-author .option[data-value='#{author.id}']").click
    find('input[type="submit"]').click

    expected_param = CGI.escape("q[author_id_eq]")
    expect(page).to have_current_path %r{/admin/posts\?.*#{expected_param}=#{author.id}}
    expect(page).to have_css('.js-table-row', count: posts.size)
    posts.each do |post|
      expect(page).to have_css('.js-table-row a.action-show', text: post.title)
    end
  end
end
