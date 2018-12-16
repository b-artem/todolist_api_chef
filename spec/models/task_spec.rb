require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build :task }
  let(:created_task) { create :task }

  it 'has a valid factory' do
    expect(task).to be_valid
  end

  it { is_expected.to belong_to(:project) }
  it { is_expected.to have_many(:comments) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1) }

  it 'is not done by default' do
    expect(created_task.done).to be_falsey
  end
end
