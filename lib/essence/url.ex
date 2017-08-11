defmodule Essence.Url do
	@moduledoc """
  	The Url module is responsible for creating an interface to interact with the Urls in our database.
  """

	use Ecto.Schema
	alias Essence.Repo
	alias Essence.Url
	import Ecto.Query

	schema "urls" do
		field :destination_url
		field :shortened_url
	end

	def changeset(url, params \\ %{}) do
	  url
	  |> Ecto.Changeset.cast(params, [:destination_url, :shortened_url])
	  |> Ecto.Changeset.validate_required([:destination_url, :shortened_url])
	end

	def find_or_create(destination) do
		# Don't create another record for this destination if we've already created one
		if !fetch_by_destination(destination) do
			shortened = :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)

			# Generate and verify our url record
			url = %Url{}
			changeset = Url.changeset(url, %{destination_url: destination, shortened_url: shortened})

			Repo.insert(changeset)
		end

		fetch_by_destination(destination)
	end

	def fetch_by_code(shortened_url) do
		query = from u in "urls", 
						where: u.shortened_url == ^shortened_url,
						select: %{id: u.id, destination_url: u.destination_url, shortened_url: u.shortened_url}

		Repo.one(query)
	end

	def fetch_by_destination(url) do
		query = from u in "urls", 
						where: u.destination_url == ^url,
						select: %{id: u.id, destination_url: u.destination_url, shortened_url: u.shortened_url}

  	Repo.one(query)
	end
end