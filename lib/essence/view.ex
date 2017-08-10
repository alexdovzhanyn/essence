defmodule Essence.View do
	use Essence.Template

	def render(path, assigns) do
		name = view_name(path)
		apply(__MODULE__, name, [assigns])
	end

	defmacro __using__(options) do
		quote do
			import unquote(__MODULE__)
		end
	end
end