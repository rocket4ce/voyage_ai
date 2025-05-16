defmodule VoyageAi.Embed do
  @moduledoc """
  Respuesta para una solicitud de embeddings que envuelve el modelo, uso y embeddings.

  ## Ejemplos

      iex> %VoyageAi.Embed{
      ...>   model: "voyage-3",
      ...>   usage: %VoyageAi.Usage{total_tokens: 0},
      ...>   embeddings: []
      ...> }
  """

  alias VoyageAi.Usage

  @enforce_keys [:model, :usage, :embeddings]
  defstruct [:model, :usage, :embeddings]

  @doc """
  Crea una nueva estructura de embedding.

  ## Parámetros

    * `:model` - El modelo utilizado para generar los embeddings.
    * `:usage` - La información de uso.
    * `:embeddings` - Los embeddings generados.
  """
  def new(model, usage, embeddings) do
    %__MODULE__{
      model: model,
      usage: usage,
      embeddings: embeddings
    }
  end

  @doc """
  Analiza los datos de embedding de la respuesta de la API.

  ## Parámetros

    * `:data` - Los datos de embedding de la respuesta de la API.
  """
  def parse(data) do
    model = Map.get(data, "model", "")
    usage = Usage.parse(Map.get(data, "usage", %{}))

    embeddings =
      Enum.map(Map.get(data, "data", []), fn embedding_data ->
        Map.get(embedding_data, "embedding", [])
      end)

    new(model, usage, embeddings)
  end

  @doc """
  Obtiene un embedding específico por índice.

  ## Parámetros

    * `:index` - El índice del embedding a obtener (por defecto: 0).

  ## Ejemplos

      iex> embed = %VoyageAi.Embed{
      ...>   model: "voyage-3",
      ...>   usage: %VoyageAi.Usage{total_tokens: 0},
      ...>   embeddings: [[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]]
      ...> }
      iex> VoyageAi.Embed.embedding(embed)
      [0.1, 0.2, 0.3]
      iex> VoyageAi.Embed.embedding(embed, 1)
      [0.4, 0.5, 0.6]
  """
  def embedding(embed, index \\ 0) do
    Enum.at(embed.embeddings, index, [])
  end
end
