# frozen_string_literal: true

RSpec.describe 'Number filter' do
  let(:post3) { Post.third }
  let(:author1) { Author.first }

  it 'filters the authors by age range', :aggregate_failures do
    visit '/admin/authors'

    fill_in('q[age_lteq]', with: '28')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/authors\?.+q%5Bage_lteq%5D=28.*}
    expect(page).to have_css('.js-table-row', count: 2)
    expect(page).to have_css('.js-table-row a.action-show', text: author1.name)
  end

  it 'filters the posts by position', :aggregate_failures do
    visit '/admin/posts'

    fill_in('q[position_eq]', with: '234')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bposition_eq%5D=234.*}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post3.title)
  end
end
