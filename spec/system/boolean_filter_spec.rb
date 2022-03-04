# frozen_string_literal: true

RSpec.describe 'Boolean filter', type: :system do
  let(:post1) { Post.first }
  let(:post2) { Post.second }

  it 'filters the posts by published', :aggregate_failures do
    visit '/admin/posts'

    find('.filter-published .selectize-input').click
    find('.filter-published .option[data-value="true"]').click
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bpublished_eq%5D=true.*}
    expect(page).to have_css('a.action-show', text: post1.title)
    expect(page).not_to have_css('a.action-show', text: post2.title)
  end
end
