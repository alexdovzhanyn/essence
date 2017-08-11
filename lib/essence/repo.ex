defmodule Essence.Repo do
	@moduledoc """
  	A wrapper for Ecto.Repo
  """

	use Ecto.Repo,
		otp_app: :essence

end