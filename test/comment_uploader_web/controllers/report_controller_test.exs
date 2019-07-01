defmodule CommentUploaderWeb.ReportControllerTest do
  use CommentUploaderWeb.ConnCase

  alias CommentUploader.Comments

  describe "create" do
    test "Shows an error when no parameters for report selected" do
      conn = post(conn, Routes.report_path(conn, :create), %{"comment" => %{"param" => "", "report_f" => ""}})
      assert html_response(conn, 200) =~ "Empty parameters"
    end

    test "Shows an error with only one parameter selected" do
      conn = post(conn, Routes.report_path(conn, :create), %{"comment" => %{"param" => "", "report_f" => "html"}})
      assert html_response(conn, 200) =~ "Empty parameters"
    end

    test "Test of showing report" do
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Female", month: 4, text: "some text"})
      Comments.create_comment(%{city: "some city", daytime: "Morning", emote: "very nice", gender: "Male", month: 4, text: "some text"})
      conn = post(conn, Routes.report_path(conn, :create), %{"comment" => %{"param" => "gender", "report_f" => "html"}})
      assert html_response(conn, 200) =~ "Showing report"
    end
  end

end
