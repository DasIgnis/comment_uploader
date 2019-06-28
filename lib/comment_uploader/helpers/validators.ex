defmodule CommentFilter.Validators do
  @moduledoc """
  Содержит валидаторы для changesets
  """
  import Ecto.Changeset

@genders ["Female", "Male"]
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

@daystamps ["Morning", "Day", "Evening", "Night"]
@doc """
  Проверяет корректность времени суток для данных
  """
def validate_daytime(changeset) do
  time = get_field(changeset, :daytime)
  if time in @daystamps do
    changeset
  else
    add_error(changeset, :daytime, ": uncorrect daytime")
  end
end

end
