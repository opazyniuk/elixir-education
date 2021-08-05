defmodule PrimitiveBankWeb.PageController do
  use PrimitiveBankWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
