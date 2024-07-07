# frozen_string_literal: true

RSpec.describe 'Boolean filter' do
  let(:first_post) { Post.first }
  let(:second_post) { Post.second }

  it 'filters the posts by published', :aggregate_failures do
    visit '/admin/posts'

    find('.filter-published .selectize-input').click
    find('.filter-published .option[data-value="true"]').click
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bpublished_eq%5D=true.*}
    expect(page).to have_css('a.action-show', text: first_post.title)
    expect(page).not_to have_css('a.action-show', text: second_post.title)
  end
end
