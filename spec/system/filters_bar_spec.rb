# frozen_string_literal: true

RSpec.describe 'Filters bar' do
  it 'checks that filters bar is present (looking for some specific elements)', :aggregate_failures do
    visit admin_posts_path

    expect(page).to have_css('form#post_search')
    expect(page).to have_css('input#q_title_cont')
    expect(page).to have_css('.filter-author')
    expect(page).to have_css('.filter-published')
  end
end
