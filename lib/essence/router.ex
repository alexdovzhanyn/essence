defmodule Essence.Router do
	@moduledoc """
 		Our main server file. Here we configure our routes and call the main logic of our application. 
  """

	use Plug.Router
	use Essence.View
	alias Essence.Url
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

	get "/robots.txt" do
		# We don't really want any of our pages indexed, so lets disallow all
		conn
		|> send_resp(200, "Disallow *")
		|> halt
	end

	get "/" do
		conn
		|> send_resp(200, render("index.html", nil))
		|> halt
	end

	post "/convert" do
		destination = conn.params["url"] |> String.strip

		{_, hostname} = List.first(conn.req_headers)

		%{destination_url: destination_url, shortened_url: shortened_url} =  Url.find_or_create(destination)

		conn
		|> send_resp(200, "{\"shortened_url\": \"#{hostname}/#{shortened_url}\"}")
		|> halt
	end

	get "/:shortened_url" do
		%{destination_url: destination_url} = Url.fetch_by_code(conn.params["shortened_url"])

		# Ensure that the destination URL is at least prepended with http, or else the 301 redirect would send us to an undefined path on our site
		destination_url = if (destination_url =~ "http"), do: destination_url, else: "http://" <> destination_url

		# Plug doesn't seem to have native redirect logic, so we have to use manual http redirects using the "location" HTTP header
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
end