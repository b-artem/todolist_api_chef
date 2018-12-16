class API::V1::TaskUpdateService
  DIRECTIONS = %w[up down].freeze

  def initialize(task:, task_params:, change_priority: nil)
    @task = task
    @task_params = task_params
    @change_priority = change_priority
  end

  def call
    return @task.update_attributes(@task_params) unless @change_priority
    @task.transaction do
      update_all_except_priority
      update_priority
    end
  rescue ActiveRecord::RecordInvalid
    return false
  end

  private

  def update_priority
    unless DIRECTIONS.include?(@change_priority)
      @task.errors.add(:priority, I18n.t('models.task.wrong_priority'))
      return raise ActiveRecord::RecordInvalid
    end
    @change_priority == 'up' ? @task.move_higher : @task.move_lower
  end

  def update_all_except_priority
    @task.update!(@task_params.except(:priority))
  end
end
