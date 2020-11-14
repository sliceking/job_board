defmodule JobBoard.Listing.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :location, :string
    field :active, :boolean
    belongs_to :user, JobBoard.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:title, :url, :description, :location, :active, :user_id])
    |> validate_required([:title, :url, :description, :location, :active, :user_id])
    |> assoc_constraint(:user)
  end
end
