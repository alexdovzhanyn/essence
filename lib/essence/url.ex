defmodule Essence.Url do
	use Ecto.Schema

	schema "urls" do
		field :destination_url
		field :shortened_url
	end

	def changeset(url, params \\ %{}) do
	  url
	  |> Ecto.Changeset.cast(params, [:destination_url, :shortened_url])
	  |> Ecto.Changeset.validate_required([:destination_url, :shortened_url])
	end
end