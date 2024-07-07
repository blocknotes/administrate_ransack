# frozen_string_literal: true

RSpec.describe 'Date filter' do
  let(:post3) { Post.third }

  it 'filters the posts by date', :aggregate_failures do
    visit '/admin/posts'

    date = Date.tomorrow
    fill_in('q[dt_gteq]', with: date)
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bdt_gteq%5D=#{date}.*}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post3.title)
  end
end
