# frozen_string_literal: true

RSpec.describe 'String filter', type: :system do
  let(:post2) { Post.second }

  it 'filters the posts by title', :aggregate_failures do
    visit '/admin/posts'

    fill_in('q[title_cont]', with: 'another')
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post2.title)
  end
end
