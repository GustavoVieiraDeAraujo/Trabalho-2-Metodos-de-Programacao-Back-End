# Serializador para a classe User.
class UserSerializer < ActiveModel::Serializer
  # Atributos serializados
  #
  # @!attribute [rw] id
  #   @return [Integer] o ID do usuário
  # @!attribute [rw] name
  #   @return [String] o nome do usuário
  # @!attribute [rw] enrollment
  #   @return [Integer] o número de matrícula do usuário
  # @!attribute [rw] is_admin
  #   @return [Boolean] se o usuário é um administrador
  # @!attribute [rw] is_student
  #   @return [Boolean] se o usuário é um estudante
  # @!attribute [rw] is_teacher
  #   @return [Boolean] se o usuário é um professor
  attributes :id, :name, :email, :enrollment, :authentication_token, :is_admin, :is_student, :is_teacher
end
