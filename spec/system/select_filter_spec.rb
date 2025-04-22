# frozen_string_literal: true

RSpec.describe 'Select filter' do
  before do
    SpecHelpers.setup_data
  end

  it 'filters the posts by category', :aggregate_failures do
    visit admin_posts_path

    find('.filter-category .selectize-input').click
    find('.filter-category .option[data-value="story"]').click
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bcategory_eq%5D=story.*}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: "Another post")
  end
end
