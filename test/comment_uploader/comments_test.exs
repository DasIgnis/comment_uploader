defmodule CommentUploader.CommentsTest do
  use CommentUploader.DataCase

  alias CommentUploader.Comments

  describe "comments" do
    alias CommentUploader.Comments.Comment

    @valid_attrs %{city: "some city", daytime: "Morning", emote: "very nice", gender: "Female", month: 4, text: "some text"}
    @update_attrs %{city: "some updated city", daytime: "Evening", emote: "not so nice", gender: "Male", month: 3, text: "some updated text"}
    @invalid_attrs %{city: nil, daytime: nil, emote: nil, gender: nil, month: nil, text: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comments.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Comments.create_comment(@valid_attrs)
      assert comment.city == "some city"
      assert comment.daytime == "Morning"
      assert comment.emote == "very nice"
      assert comment.gender == "Female"
      assert comment.month == 4
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.city == "some updated city"
      assert comment.daytime == "Evening"
      assert comment.emote == "not so nice"
      assert comment.gender == "Male"
      assert comment.month == 3
      assert comment.text == "some updated text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
