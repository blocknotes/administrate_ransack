# frozen_string_literal: true

RSpec.describe 'Administrate Ransack', type: :system do
  let(:author) { Author.create!(email: 'some_email@example.com', name: 'John Doe', age: 30) }
  let!(:post) { Post.create!(title: 'A post', author: author, category: 'news', published: true) }
  let!(:post2) { Post.create!(title: 'Another post', author: author, category: 'story') }

  after do
    post.destroy
    post2.destroy
    author.destroy
  end

  it 'checks that filters bar is present' do
    visit '/admin/posts'

    # Look for some filter elements
    expect(page).to have_css('form#post_search')
    expect(page).to have_css('select#q_author_id_eq')
    expect(page).to have_css('input#q_title_cont')
    expect(page).to have_css('select#q_published_eq')
  end

  # check string filters
  it 'filters the posts by title' do
    visit '/admin/posts'

    expect(page).to have_css('a.action-show', text: post.title)
    expect(page).to have_css('a.action-show', text: post2.title)

    fill_in('q[title_cont]', with: 'another')
    find('input[type="submit"]').click

    expect(page).not_to have_css('a.action-show', text: post.title)
    expect(page).to have_css('a.action-show', text: post2.title)
  end

  # check boolean filters
  it 'filters the posts by title' do
    visit '/admin/posts'

    expect(page).to have_css('a.action-show', text: post.title)
    expect(page).to have_css('a.action-show', text: post2.title)

    select('Yes', from: 'q[published_eq]')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bpublished_eq%5D=true.*}
    expect(page).to have_css('a.action-show', text: post.title)
    expect(page).not_to have_css('a.action-show', text: post2.title)
  end

  # check select filters
  it 'filters the posts by category' do
    visit '/admin/posts'

    expect(page).to have_css('a.action-show', text: post.title)
    expect(page).to have_css('a.action-show', text: post2.title)

    select('story', from: 'q[category_eq]')
    find('input[type="submit"]').click

    expect(page).to have_current_path %r{/admin/posts\?.+q%5Bcategory_eq%5D=story.*}
    expect(page).not_to have_css('a.action-show', text: post.title)
    expect(page).to have_css('a.action-show', text: post2.title)
  end
end
