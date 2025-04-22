# frozen_string_literal: true

RSpec.describe 'Has many filter' do
  let(:tag) { Tag.find_by!(name: 'A test tag') }

  before do
    SpecHelpers.setup_data
  end

  it 'filters the posts by tag (with Selectize)', :aggregate_failures do
    visit admin_posts_path

    find('.filter-tags .selectize-input').click
    find(".filter-tags .option[data-value='#{tag.id}']").click
    find('input[type="submit"]').click

    expected_param = CGI.escape("q[tags_id_in][]")
    expect(page).to have_current_path %r{/admin/posts\?.+#{expected_param}=#{tag.id}}
    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: "Another post")
  end

  it 'filters the tags by post', :aggregate_failures do
    visit admin_tags_path

    post = Post.find_by!(title: "Another post")
    find("#q_posts_id_in_#{post.id}").set(true)
    find('input[type="submit"]').click

    expect(page).to have_css('.js-table-row', count: 1)
    expect(page).to have_css('.js-table-row a.action-show', text: tag.name)
  end
end
