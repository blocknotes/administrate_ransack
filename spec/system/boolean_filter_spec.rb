# frozen_string_literal: true

RSpec.describe 'Boolean filter' do
  before do
    SpecHelpers.setup_data
  end

  it 'filters the posts by published', :aggregate_failures do
    visit admin_posts_path

    find('.filter-published .selectize-input').click
    find('.filter-published .option[data-value="true"]').click
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bpublished_eq%5D=true.*}
    expect(page).to have_css('a.action-show', text: "A post")
    expect(page).not_to have_css('a.action-show', text: "Last post")
  end
end
