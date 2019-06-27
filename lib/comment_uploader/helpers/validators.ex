defmodule CommentFilter.Validators do
  @moduledoc """
  Содержит валидаторы для changesets
  """
  import Ecto.Changeset

@genders ["female", "male", "undefined"]
@doc """
  Проверяет корректность пола для данных
  """
def validate_gender(changeset) do
  gender = get_field(changeset, :gender)
  if gender in @genders do
    changeset
  else
    add_error(changeset, :gender, ": uncorrect gender")
  end
end

@daystamps ["morning", "day", "evening", "night"]
@doc """
  Проверяет корректность времени суток для данных
  """
def validate_daytime(changeset) do
  time = get_field(changeset, :daytime)
  if time in @daystamps do
    changeset
  else
    add_error(changeset, :daytime, ": uncorrect gender")
  end
end

end
