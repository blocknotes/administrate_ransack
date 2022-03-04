# frozen_string_literal: true

RSpec.describe 'Has many filter', type: :system do
  let(:post2) { Post.second }
  let(:tag) { Tag.find_by!(name: 'A test tag') }

  it 'filters the posts by tag', :aggregate_failures do
    visit '/admin/posts'

    find("#q_tags_id_in_#{tag.id}").set(true)
    find('input[type="submit"]').click

    expected_param = CGI.escape("q[tags_id_in][]")
    expect(page).to have_current_path %r{/admin/posts\?.+#{expected_param}=#{tag.id}}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post2.title)
  end
end
