class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can %i[read create update destroy], Project, user_id: user.id
      can %i[read create update destroy], Task, project: { user_id: user.id }
      can %i[read create destroy], Comment, task: { project: { user_id: user.id } }
    end
  end
end
