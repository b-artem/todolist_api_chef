require 'rails_helper'
require 'api/v1/task_update'

RSpec.describe API::V1::TaskUpdateService do
  let(:user) { create :user }
  let(:project) { create(:project, user: user) }
  let(:tasks) { create_list(:task, 5, project: project) }
  let(:last_task) { tasks.last }

  context 'when "change_priority" parameter is present' do
    context 'when "task_params" is empty' do
      let(:task_update) { API::V1::TaskUpdateService.new(task: last_task,
        task_params: {}, change_priority: 'up') }

      it 'changes priority of given task' do
        expect { task_update.call }.to change(last_task, :priority).by(-1)
      end
    end

    context 'when "task_params" is present too' do
      context 'with valid params' do
        let(:task_params) { { name: 'new name' } }
        let(:task_update) { API::V1::TaskUpdateService.new(task: last_task,
          task_params: task_params, change_priority: 'up') }

        # #call uses transaction inside, RSpec #change matcher does not suite here
        it 'changes priority of given task' do
          expect(last_task.priority).to eq 5
          task_update.call
          expect(last_task.reload.priority).to eq 4
        end

        # #call uses transaction inside, RSpec #change matcher does not suite here
        it 'changes task params also' do
          task_update.call
          expect(last_task.reload.name).to eq task_params[:name]
        end
      end

      context 'with invalid params' do
        let(:task_params) { { name: '' } }
        let(:task_update) { API::V1::TaskUpdateService.new(task: last_task,
          task_params: task_params, change_priority: 'up') }

          # #call uses transaction inside, RSpec #change matcher does not suite here
          it 'does NOT change priority of given task' do
            expect(last_task.priority).to eq 5
            task_update.call
            expect(last_task.reload.priority).to eq 5
          end

          # #call uses transaction inside, RSpec #change matcher does not suite here
          it 'does NOT change task params' do
            name = last_task.name
            task_update.call
            expect(last_task.reload.name).to eq name
          end
      end
    end
  end

  context 'when no "change_priority" parameter' do
    let(:task_params) { { name: 'new name' } }
    let(:task_update) { API::V1::TaskUpdateService.new(task: last_task,
      task_params: task_params) }

    it 'changes task params' do
      expect { task_update.call }.to change(last_task, :name).to(task_params[:name])
    end

    it 'does not change task priority' do
      expect { task_update.call }.not_to change(last_task, :priority)
    end
  end
end
