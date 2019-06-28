defmodule CommentUploader.FileProcessor do
  @moduledoc """
  Содержит функции для обработки загруженных или подготовки выгружаемых файлов
  """
  require Elixlsx

  alias Elixlsx.Sheet
  alias Elixlsx.Workbook

  @doc """
  По заданному пути обрабатывает csv файл и возвращает даные из него в формате для вставки в базу данных
  """
  def upload_data(path) do
    unless File.exists?(path) do
      IO.puts("error: no file exists!")
    end
    File.stream!(path)
      |> Stream.map(&String.split(&1, ","))
      |> Stream.map(&process_list_data(&1))
  end

  @doc """
  Получает на вход список данных из одной строки .csv-файла и преобразобывает ее в формат для вставки в базу
  """
  def process_list_data(list) do
    cleaned_list = list
      |> Enum.drop(1)
      |> Enum.map(&String.trim(&1))
    # Теперь у нас есть список [пол, город, текст, timestamp]
    # Обработка полей текста и timestamp
    text = Enum.at(cleaned_list, 2)
    emote_val = Veritaserum.analyze(text)
    emote = cond do
      emote_val < -5 -> "Very negative"
      emote_val < 0  -> "Negative"
      emote_val == 0 -> "Neutral"
      emote_val < 5  -> "Positive"
      true           -> "Very positive"
    end
    timestamp = case Integer.parse(Enum.at(cleaned_list, 3)) do
      {timestamp, _} -> timestamp
      :error         -> 0
    end
    datetime = case DateTime.from_unix(timestamp) do
      {:ok, datetime} -> datetime
      {:error, _}     -> :error
    end
    month = DateTime.to_date(datetime).month
    hour = DateTime.to_time(datetime).hour
    daytime = cond do
      hour < 6  -> "Night"
      hour < 12 -> "Morning"
      hour < 18 -> "Day"
      true      -> "Evening"
    end
    %{gender: String.capitalize(Enum.at(cleaned_list, 0)), city: Enum.at(cleaned_list, 1), text: text, emote: emote,
        month: month, daytime: daytime}
  end

  @doc """
  Получает данные для польователя и генерирует по ним excel-файл с отчетом
  """
  def generate_excel_file(data) do
    workbook = %Workbook{sheets:
        Enum.map(data, &generate_sheet(&1))}
    Elixlsx.write_to(workbook, "_temp/report.xlsx")
  end

  @doc """
  Генерирует excel-лист с данными
  """
  def generate_sheet(value) do
    %Sheet{name: "#{value.param} (#{length(value.records)})",
      rows: Enum.map(value.records, &([&1["id"], &1["text"]]))}
  end

  @doc """
  Отправляет файл пользователю
  """
  def init_download(conn, path) do

  end

end
