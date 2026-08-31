defmodule EasyFileWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, and so on.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt uploads)

  def router do
    quote do
      use Phoenix.Router, helpers: false
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: {EasyFileWeb.Layouts, :root}]

      import Plug.Conn
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller, only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      import Phoenix.HTML
      import EasyFileWeb.CoreComponents
      alias EasyFileWeb.Layouts
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
