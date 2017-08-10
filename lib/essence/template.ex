defmodule Essence.Template do
	@templates "web/templates"

	defmacro __using__(options) do
		quote do
			require EEx
			import unquote(__MODULE__)
			@before_compile unquote(__MODULE__)
		end
	end

	defmacro __before_compile__(_env) do
		templates = find_templates()

		ast = templates |> Enum.map(fn(path) -> compile(path) end)

		quote do
			unquote(ast)
		end
	end

	def view_name(@templates <> path), do: view_name(path)
	def view_name("/" <> path), do: view_name(path)
	def view_name(path) do
		path
		|> String.downcase
		|> String.replace("/", "_")
		|> String.replace(".eex", "")
		|> String.to_atom
	end

	defp find_templates(), do: find_templates(@templates)
	defp find_templates(root) do
		Path.wildcard("#{root}/*.eex")
	end

	defp compile(path) do
		name = view_name(path)
		block = EEx.compile_file(path)

		quote do
			@file unquote(path)
			@external_resource unquote(path)

			def unquote(name)(var!(assigns)) do
				_ = var!(assigns)
				unquote(block)
			end
		end
	end
end