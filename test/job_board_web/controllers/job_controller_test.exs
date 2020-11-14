defmodule JobBoardWeb.JobControllerTest do
  use JobBoardWeb.ConnCase
  import JobBoard.AccountsFixtures
  alias JobBoard.Listing
  alias JobBoardWeb.UserAuth

  @create_attrs %{
    description: "some description",
    title: "some title",
    url: "some url",
    location: "some location",
    active: true
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    url: "some updated url",
    location: "some location",
    active: true
  }
  @invalid_attrs %{description: nil, title: nil, url: nil}

  def fixture(:job) do
    user = user_fixture()

    {:ok, job} =
      %{}
      |> Map.put(:user_id, user.id)
      |> Enum.into(@create_attrs)
      |> Listing.create_job()

    job
  end

  setup :register_and_log_in_user

  describe "index" do
    test "lists all jobs", %{conn: conn} do
      conn = get(conn, Routes.job_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Jobs"
    end
  end

  describe "new job" do
    test "renders form", %{conn: conn, user: user} do
      conn = get(conn, Routes.job_path(conn, :new))
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "create job" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      attrs = Map.put(@create_attrs, :user_id, user.id)
      conn = post(conn, Routes.job_path(conn, :create), job: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.job_path(conn, :show, id)

      conn = get(conn, Routes.job_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Job"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.job_path(conn, :create), job: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Job"
    end
  end

  describe "edit job" do
    setup [:create_job]

    test "renders form for editing chosen job", %{conn: conn, job: job, user: user} do
      conn = get(conn, Routes.job_path(conn, :edit, job))
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "update job" do
    setup [:create_job]

    test "redirects when data is valid", %{conn: conn, job: job, user: user} do
      conn = put(conn, Routes.job_path(conn, :update, job), job: @update_attrs)
      assert redirected_to(conn) == Routes.job_path(conn, :show, job)

      conn = get(conn, Routes.job_path(conn, :show, job))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, job: job, user: user} do
      conn = put(conn, Routes.job_path(conn, :update, job), job: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Job"
    end
  end

  describe "delete job" do
    setup [:create_job]

    test "deletes chosen job", %{conn: conn, job: job, user: user} do
      conn = delete(conn, Routes.job_path(conn, :delete, job))
      assert redirected_to(conn) == Routes.job_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.job_path(conn, :show, job))
      end
    end
  end

  defp create_job(_) do
    job = fixture(:job)
    %{job: job}
  end
end
