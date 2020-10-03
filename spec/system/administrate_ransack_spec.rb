# frozen_string_literal: true

RSpec.describe 'Administrate Ransack', type: :system do
  it 'checks that filters bar is present' do
    visit '/admin/posts'

    expect(page).to have_css('form#post_search')
    expect(page).to have_css('select#q_author_id_eq')
    expect(page).to have_css('input#q_title_cont')
    expect(page).to have_css('select#q_published_eq')
  end
end
