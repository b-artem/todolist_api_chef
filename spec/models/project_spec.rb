require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build :project }

  it 'has a valid factory' do
    expect(project).to be_valid
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }
end
