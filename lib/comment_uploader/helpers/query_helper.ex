defmodule CommentUploader.QueryHelper do
  @moduledoc """
  Содержит функции обработки запросов к базе по разным параметрам
  """
  import Ecto.Query
  alias CommentUploader.Comments.Comment
  alias CommentUploader.Repo

  @allowed_params ["city", "daytime", "emote", "gender", "month"]
  @doc """
    Вызов нужного запроса и приведение данных к виду, готовому для вывода пользователю
  """
  def fetch_data(param) do
    #json_build_object требует psql версии 9.4 и выше
    if param in @allowed_params do
      field_name = String.to_atom(param)
      query = from c in Comment,
              group_by: field(c, ^field_name),
              select: %{param: field(c, ^field_name),
                        records: fragment("json_agg(json_build_object(\'id\', ?, \'text\', ?))", c.id, c.text)}

      {:ok, Repo.all(query)}
    else
      :error
    end
  end

end
