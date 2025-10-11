# frozen_string_literal: true

RSpec.describe RepoTemplater do
  it 'has a name' do
    expect(RepoTemplater::NAME).not_to be_nil
  end

  it 'has a slug' do
    expect(RepoTemplater::SLUG).not_to be_nil
  end

  it 'has a description' do
    expect(RepoTemplater::DESCRIPTION).not_to be_nil
  end

  it 'has a version' do
    expect(RepoTemplater::VERSION).not_to be_nil
  end

  it 'has an author' do
    expect(RepoTemplater::AUTHOR).not_to be_nil
  end

  it 'has an author email' do
    expect(RepoTemplater::AUTHOR_EMAIL).not_to be_nil
  end

  it 'has a author website' do
    expect(RepoTemplater::AUTHOR_URI).not_to be_nil
  end

  it 'has a license' do
    expect(RepoTemplater::LICENSE).not_to be_nil
  end

  it 'has a copyright year' do
    expect(RepoTemplater::YEAR).not_to be_nil
  end
end
