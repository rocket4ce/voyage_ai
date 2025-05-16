defmodule VoyageAi.Client do
  @moduledoc """
  Cliente para interactuar con la API de VoyageAI.

  ## Ejemplos

      iex> client = VoyageAi.Client.new(api_key: "pa-...")
      iex> VoyageAi.Client.embed(client, "Un ejemplo de texto.")
      %VoyageAi.Embed{...}
  """

  alias VoyageAi.{Model, Embed, Rerank, Error}

  @doc """
  Crea un nuevo cliente.

  ## Parámetros

    * `:api_key` - La clave API para VoyageAI (por defecto: `VoyageAi.config().api_key`).
    * `:host` - El host de la API (por defecto: `VoyageAi.config().host`).
    * `:version` - La versión de la API (por defecto: `VoyageAi.config().version`).
    * `:timeout` - El tiempo de espera en milisegundos (por defecto: `VoyageAi.config().timeout`).
  """
  def new(options \\ []) do
    config = VoyageAi.config()

    api_key = Keyword.get(options, :api_key, config.api_key)
    host = Keyword.get(options, :host, config.host)
    version = Keyword.get(options, :version, config.version)
    timeout = Keyword.get(options, :timeout, config.timeout)

    if is_nil(api_key) do
      raise Error.ConfigError.new("api_key es requerido o VOYAGEAI_API_KEY debe estar presente")
    end

    %{
      api_key: api_key,
      host: host,
      version: version,
      timeout: timeout
    }
  end

  @doc """
  Genera embeddings para el texto proporcionado.

  ## Parámetros

    * `client` - El cliente VoyageAI.
    * `input` - El texto o lista de textos para generar embeddings.
    * `options` - Opciones adicionales.
      * `:model` - El modelo a utilizar (por defecto: `VoyageAi.Model.voyage()`).
      * `:input_type` - El tipo de entrada (`:query` o `:document`).
      * `:truncation` - Si se debe truncar el texto.
      * `:output_dimension` - La dimensión de salida.

  ## Ejemplos

      iex> client = VoyageAi.Client.new(api_key: "pa-...")
      iex> VoyageAi.Client.embed(client, "Un ejemplo de texto.")
      %VoyageAi.Embed{...}

      iex> client = VoyageAi.Client.new(api_key: "pa-...")
      iex> VoyageAi.Client.embed(client, ["Texto 1", "Texto 2"])
      %VoyageAi.Embed{...}
  """
  def embed(client, input, options \\ []) do
    model = Keyword.get(options, :model, Model.voyage())
    input_type = Keyword.get(options, :input_type)
    truncation = Keyword.get(options, :truncation)
    output_dimension = Keyword.get(options, :output_dimension)

    payload =
      %{
        input: arrayify(input),
        model: model
      }
      |> maybe_add(:input_type, input_type)
      |> maybe_add(:truncation, truncation)
      |> maybe_add(:output_dimension, output_dimension)

    case post(client, "/embeddings", payload) do
      {:ok, data} -> Embed.parse(data)
      {:error, error} -> raise error
    end
  end

  @doc """
  Reordena los documentos según su relevancia para la consulta.

  ## Parámetros

    * `client` - El cliente VoyageAI.
    * `query` - La consulta.
    * `documents` - Los documentos a reordenar.
    * `options` - Opciones adicionales.
      * `:model` - El modelo a utilizar (por defecto: `VoyageAi.Model.rerank()`).
      * `:top_k` - El número máximo de resultados a devolver.
      * `:truncation` - Si se debe truncar el texto.

  ## Ejemplos

      iex> client = VoyageAi.Client.new(api_key: "pa-...")
      iex> VoyageAi.Client.rerank(client, "¿Quién es el mejor para llamar para un inodoro?", [
      ...>   "John es músico.",
      ...>   "Paul es fontanero.",
      ...>   "George es profesor.",
      ...>   "Ringo es médico."
      ...> ])
      %VoyageAi.Rerank{...}
  """
  def rerank(client, query, documents, options \\ []) do
    model = Keyword.get(options, :model, Model.rerank())
    top_k = Keyword.get(options, :top_k)
    truncation = Keyword.get(options, :truncation)

    payload =
      %{
        query: query,
        documents: documents,
        model: model
      }
      |> maybe_add(:top_k, top_k)
      |> maybe_add(:truncation, truncation)

    case post(client, "/rerank", payload) do
      {:ok, data} -> Rerank.parse(data)
      {:error, error} -> raise error
    end
  end

  # Funciones privadas

  defp post(client, path, payload) do
    url = "#{client.host}/#{client.version}#{path}"

    headers = [
      {"Authorization", "Bearer #{client.api_key}"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    options = [recv_timeout: client.timeout]

    case HTTPoison.post(url, Jason.encode!(payload), headers, options) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code in 200..299 ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, Error.RequestError.new(status_code, body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, Error.RequestError.new(0, reason)}
    end
  end

  defp arrayify(input) when is_list(input), do: input
  defp arrayify(input), do: [input]

  defp maybe_add(map, _key, nil), do: map
  defp maybe_add(map, key, value), do: Map.put(map, key, value)
end
