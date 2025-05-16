defmodule VoyageAi do
  @moduledoc """
  Cliente Elixir para la API de VoyageAI.

  Este módulo proporciona funcionalidades para generar embeddings y reordenar documentos
  utilizando la API de VoyageAI.

  ## Configuración

  ```elixir
  VoyageAi.configure(
    api_key: "pa-...",
    host: "https://api.voyageai.com",
    version: "v1",
    timeout: 15000
  )
  ```

  O utilizando variables de entorno:

  ```
  VOYAGEAI_API_KEY=pa-...
  VOYAGEAI_HOST=https://api.voyageai.com
  VOYAGEAI_VERSION=v1
  ```
  """

  alias VoyageAi.Config

  @doc """
  Devuelve la configuración actual.

  ## Ejemplos

      iex> is_map(VoyageAi.config())
      true
  """
  def config do
    Config.get()
  end

  @doc """
  Configura la librería con los parámetros proporcionados.

  ## Parámetros

    * `:api_key` - La clave API para VoyageAI (por defecto: `System.get_env("VOYAGEAI_API_KEY")`)
    * `:host` - El host de la API (por defecto: `System.get_env("VOYAGEAI_HOST")` o `"https://api.voyageai.com"`)
    * `:version` - La versión de la API (por defecto: `System.get_env("VOYAGEAI_VERSION")` o `"v1"`)
    * `:timeout` - El tiempo de espera en milisegundos (por defecto: `15000`)

  ## Ejemplos

      iex> VoyageAi.configure(api_key: "pa-...")
      :ok
  """
  def configure(options \\ []) do
    Config.configure(options)
  end
end
