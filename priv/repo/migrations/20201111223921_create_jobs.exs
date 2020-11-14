defmodule JobBoard.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :title, :string
      add :url, :string
      add :description, :string
      add :location, :string
      add :active, :boolean
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

    create index(:jobs, [:user_id])
  end
end
