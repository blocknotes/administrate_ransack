# frozen_string_literal: true

RSpec.describe 'String filter' do
  let(:post2) { Post.second }
  let(:author11) { Author.find(11) }

  it 'filters the authors by name or email', :aggregate_failures do
    visit '/admin/authors'

    fill_in('q[name_or_email_cont]', with: '@bbb')
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: author11.name)

    fill_in('q[name_or_email_cont]', with: 'A test')
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: author11.name)
  end

  it 'filters the authors by name not contain', :aggregate_failures do
    visit '/admin/authors'

    fill_in('q[name_not_cont]', with: 'A test')
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 10)
    expect(page).not_to have_css('.js-table-row a.action-show', text: author11.name)
  end

  it 'filters the posts by title', :aggregate_failures do
    visit '/admin/posts'

    fill_in('q[title_cont]', with: 'another')
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post2.title)
  end
end
