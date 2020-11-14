defmodule JobBoard.ListingTest do
  use JobBoard.DataCase
  import JobBoard.AccountsFixtures
  alias JobBoard.Listing

  describe "jobs" do
    alias JobBoard.Listing.Job

    @valid_attrs %{
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
      location: "some updated location",
      active: false
    }
    @invalid_attrs %{description: nil, title: nil, url: nil, location: nil}

    def job_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, job} =
        attrs
        |> Map.put(:user_id, user.id)
        |> Enum.into(@valid_attrs)
        |> Listing.create_job()

      job
    end

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Listing.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Listing.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      user = user_fixture()

      attrs =
        %{}
        |> Map.put(:user_id, user.id)
        |> Enum.into(@valid_attrs)

      assert {:ok, %Job{} = job} = Listing.create_job(attrs)
      assert job.description == "some description"
      assert job.title == "some title"
      assert job.url == "some url"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listing.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      assert {:ok, %Job{} = job} = Listing.update_job(job, @update_attrs)
      assert job.description == "some updated description"
      assert job.title == "some updated title"
      assert job.url == "some updated url"
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Listing.update_job(job, @invalid_attrs)
      assert job == Listing.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Listing.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Listing.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Listing.change_job(job)
    end
  end
end
