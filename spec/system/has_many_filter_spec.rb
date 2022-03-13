# frozen_string_literal: true

RSpec.describe 'Has many filter', type: :system do
  let(:post2) { Post.second }
  let(:tag) { Tag.find_by!(name: 'A test tag') }

  it 'filters the posts by tag (with Selectize)', :aggregate_failures do
    visit '/admin/posts'

    find('.filter-tags .selectize-input').click
    find(".filter-tags .option[data-value='#{tag.id}']").click
    find('input[type="submit"]').click

    expected_param = CGI.escape("q[tags_id_in][]")
    expect(page).to have_current_path %r{/admin/posts\?.+#{expected_param}=#{tag.id}}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: post2.title)
  end

  it 'filters the tags by post', :aggregate_failures do
    visit '/admin/tags'

    find("#q_posts_id_in_#{post2.id}").set(true)
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: tag.name)
  end
end
