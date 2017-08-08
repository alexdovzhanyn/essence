defmodule Essence.Router do
	use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

	def init(options) do
		options
	end

	def start_link do
		IO.puts "Initializing Cowboy Server on port 4000"
		{:ok, _} = Plug.Adapters.Cowboy.http Essence.Router, [], [port: 4000]
	end

	get "/convert" do
		value = "Connection Established. URL shortening will be implemented in the future."
		conn
		|> send_resp(200, value)
		|> halt
	end

	match _ do
		conn
		|> send_resp(200, "Please enter a URL to convert")
		|> halt
	end
end