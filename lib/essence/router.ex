defmodule Essence.Router do
	use Plug.Router
	use Essence.View
	import Ecto.Query
	alias Essence.Url
	alias Essence.Repo
  require Logger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  plug :match
  plug :dispatch

	def init(options) do
		options
	end

	def start_link do
		IO.puts "Initializing Cowboy Server on port 4000"
		{:ok, _} = Plug.Adapters.Cowboy.http Essence.Router, [], [port: 4000]
	end

	get "/" do
		conn
		|> send_resp(200, render("index.html", nil))
		|> halt
	end

	get "/robots.txt" do
		conn
		|> send_resp(200, "Disallow *")
		|> halt
	end

	post "/convert" do
		destination = conn.params["url"]

		{_, hostname} = List.first(conn.req_headers)

		%{destination_url: destination_url, shortened_url: shortened_url} =  find_or_create_url(destination)

		send_resp(conn, 200, render("converted.html", %{destination_url: destination, shortened_url: "#{hostname}/#{shortened_url}"}))
		|> halt
	end

	get "/:shortened_url" do
		%{destination_url: destination_url} = fetch_url_by_code(conn.params["shortened_url"])

		conn
		|> put_resp_header("location", destination_url)
		|> send_resp(301, "Redirecting...")
		|> halt
	end

	match _ do
		conn
		|> send_resp(404, "Not found")
		|> halt
	end

	defp find_or_create_url(destination) do
		# Don't create another record for this destination if we've already created one
		if !fetch_url_by_destination(destination) do
			shortened = :crypto.strong_rand_bytes(8) |> Base.url_encode64 |> binary_part(0, 8)

			# Generate and verify our url record
			url = %Url{}
			changeset = Url.changeset(url, %{destination_url: destination, shortened_url: shortened})

			Repo.insert(changeset)
		end

		fetch_url_by_destination(destination)
	end

	# This returns the url from our database if the destination has been defined before
	defp fetch_url_by_destination(url) do
		query = from u in "urls", 
						where: u.destination_url == ^url,
						select: %{id: u.id, destination_url: u.destination_url, shortened_url: u.shortened_url}

  	Repo.one(query)
	end

	defp fetch_url_by_code(shortened_url) do
		query = from u in "urls", 
						where: u.shortened_url == ^shortened_url,
						select: %{id: u.id, destination_url: u.destination_url, shortened_url: u.shortened_url}

		Repo.one(query)
	end
end