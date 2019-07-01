defmodule CommentUploader.HelpersTest do
  use CommentUploader.DataCase

  alias CommentUploader.Comments
  alias CommentUploader.FileProcessor
  alias CommentUploader.QueryHelper

  describe "query_helper" do
    test "sort by param" do
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Female", month: 4, text: "female text"})
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Male", month: 4, text: "male text"})
      {:ok, response} = QueryHelper.fetch_data("gender")
      assert [%{param: "Male", records: [%{"id" => _, "text" => "male text"}]},
              %{param: "Female", records: [%{"id" => _, "text" => "female text"}]}] = response
    end

    test "broken param" do
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Female", month: 4, text: "female text"})
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Male", month: 4, text: "male text"})
      assert QueryHelper.fetch_data("wrong") == :error
    end
  end

  describe "file_processor" do
    test "process params from list" do
      data = FileProcessor.process_list_data(["Mark", "Male  ", " Moscow", "  OK  ", "1561971793"])
      assert data = %{gender: "Male", city: "Moscow", text: "OK", emote: "Neutral", month: 7, daytime: "Day"}
    end

    test "process params from list with errors" do
      data = FileProcessor.process_list_data(["Mark", "male  ", "  OK  ", "1561971793"])
      assert data == %{}
    end
  end

end
