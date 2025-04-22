# frozen_string_literal: true

RSpec.describe 'String filter' do
  before do
    SpecHelpers.setup_data
  end

  it 'filters the posts by title', :aggregate_failures do
    visit admin_posts_path

    fill_in('q[title_cont]', with: 'another')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts?.*q%5Btitle_cont%5D=another}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: "Another post")
  end
end
