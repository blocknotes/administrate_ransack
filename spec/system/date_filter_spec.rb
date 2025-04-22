# frozen_string_literal: true

RSpec.describe 'Date filter' do
  before do
    SpecHelpers.setup_data
  end

  it 'filters the posts by date', :aggregate_failures do
    visit admin_posts_path

    date = Date.tomorrow
    fill_in('q[dt_gteq]', with: date)
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bdt_gteq%5D=#{date}.*}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: "Last post")
  end
end
