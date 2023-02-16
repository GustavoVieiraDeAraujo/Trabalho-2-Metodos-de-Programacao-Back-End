# Representa as estatísticas de respostas de um usuário no sistema
class Statistic < ApplicationRecord
  # Valida se os valores de respostas estão corretos
  validate :right_value

  # Garante que as contagens de perguntas respondidas, respostas certas e erradas são não negativas
  validates :questions_answered, :right_answers, :wrong_answers, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false

  # Associa uma estatística a um usuário
  has_one :user

  # Verifica se a soma das respostas corretas e incorretas bate com a quantidade de perguntas respondidas
  def right_value
    return unless right_answers && wrong_answers && !questions_answered.nil?
    return unless right_answers + wrong_answers != questions_answered

    errors.add(:base, 'A soma dos resultados não bate com a quantidade de questões respondidas')
  end
end
