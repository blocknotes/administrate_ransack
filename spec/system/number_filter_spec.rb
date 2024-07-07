# frozen_string_literal: true

RSpec.describe 'Number filter' do
  let(:post3) { Post.third }

  it 'filters the posts by position', :aggregate_failures do
    visit '/admin/posts'

    fill_in('q[position_eq]', with: '234')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bposition_eq%5D=234.*}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post3.title)
  end
end
