defmodule JobBoardWeb.PageController do
  use JobBoardWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
