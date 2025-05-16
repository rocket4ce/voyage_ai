defmodule VoyageAi.Config do
  @moduledoc """
  Configuración para VoyageAi.

  ## Ejemplos

      iex> VoyageAi.configure(api_key: "pa-...")
      :ok
  """

  @default_host "https://api.voyageai.com"
  @default_version "v1"
  @default_timeout 15000

  defstruct [
    :api_key,
    :host,
    :version,
    :timeout
  ]

  @doc """
  Inicializa una nueva configuración.

  ## Parámetros

    * `:api_key` - La clave API para VoyageAI (por defecto: `System.get_env("VOYAGEAI_API_KEY")`)
    * `:host` - El host de la API (por defecto: `System.get_env("VOYAGEAI_HOST")` o `"https://api.voyageai.com"`)
    * `:version` - La versión de la API (por defecto: `System.get_env("VOYAGEAI_VERSION")` o `"v1"`)
    * `:timeout` - El tiempo de espera en milisegundos (por defecto: `15000`)
  """
  def new(options \\ []) do
    api_key = Keyword.get(options, :api_key, System.get_env("VOYAGEAI_API_KEY"))
    host = Keyword.get(options, :host, System.get_env("VOYAGEAI_HOST") || @default_host)

    version =
      Keyword.get(options, :version, System.get_env("VOYAGEAI_VERSION") || @default_version)

    timeout = Keyword.get(options, :timeout, @default_timeout)

    %__MODULE__{
      api_key: api_key,
      host: host,
      version: version,
      timeout: timeout
    }
  end

  @doc """
  Obtiene la configuración actual.
  """
  def get do
    Application.get_env(:voyage_ai, :config, new())
  end

  @doc """
  Configura la librería con los parámetros proporcionados.

  ## Parámetros

    * `:api_key` - La clave API para VoyageAI (por defecto: `System.get_env("VOYAGEAI_API_KEY")`)
    * `:host` - El host de la API (por defecto: `System.get_env("VOYAGEAI_HOST")` o `"https://api.voyageai.com"`)
    * `:version` - La versión de la API (por defecto: `System.get_env("VOYAGEAI_VERSION")` o `"v1"`)
    * `:timeout` - El tiempo de espera en milisegundos (por defecto: `15000`)

  ## Ejemplos

      iex> VoyageAi.Config.configure(api_key: "pa-...")
      :ok
  """
  def configure(options \\ []) do
    config = new(options)
    Application.put_env(:voyage_ai, :config, config)
    :ok
  end
end
