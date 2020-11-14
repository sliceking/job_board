defmodule JobBoardWeb.PageControllerTest do
  use JobBoardWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Job Board"
  end
end
