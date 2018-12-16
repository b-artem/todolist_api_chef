require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build :comment }

  it 'has a valid factory' do
    expect(comment).to be_valid
  end

  it { is_expected.to belong_to(:task) }
  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_length_of(:text).is_at_least(1) }
end
