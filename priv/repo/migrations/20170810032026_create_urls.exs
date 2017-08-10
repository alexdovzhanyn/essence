defmodule Essence.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
  	create table(:urls) do
  		add :destination_url, :string
  		add :shortened_url, :string
  	end
  end
end
