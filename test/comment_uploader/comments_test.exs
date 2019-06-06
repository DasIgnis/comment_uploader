defmodule CommentUploader.CommentsTest do
  use CommentUploader.DataCase

  alias CommentUploader.Comments

  describe "comments" do
    alias CommentUploader.Comments.Comment

    @valid_attrs %{city: "some city", daytime: "some daytime", emote: 42, gender: "some gender", month: 42, text: "some text"}
    @update_attrs %{city: "some updated city", daytime: "some updated daytime", emote: 43, gender: "some updated gender", month: 43, text: "some updated text"}
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
      assert comment.daytime == "some daytime"
      assert comment.emote == 42
      assert comment.gender == "some gender"
      assert comment.month == 42
      assert comment.text == "some text"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.city == "some updated city"
      assert comment.daytime == "some updated daytime"
      assert comment.emote == 43
      assert comment.gender == "some updated gender"
      assert comment.month == 43
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
