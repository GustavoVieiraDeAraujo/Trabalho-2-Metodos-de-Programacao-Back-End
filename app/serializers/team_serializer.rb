# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :teacher, :students, :tests

  # Retorna o professor responsável pelo time
  def teacher
    user = User.find_by!(id: object.user_id)
    {
      id: user.id,
      name: user.name
    }
  end

  # Retorna um array com informações de todos os alunos do time
  def students
    array = []
    object.student_team.each do |student|
      array.append(
        id: student.user.id,
        name: student.user.name,
        enrollment: student.user.enrollment
      )
    end
    array
  end

  # Retorna um array com informações de todos os testes realizados pelo time
  def tests
    array = []
    object.team_quiz.each do |quiz|
      array.append(
        id: quiz.quiz.id,
        name: quiz.quiz.title,
        subject: quiz.quiz.subject
      )
    end
    array
  end
end
