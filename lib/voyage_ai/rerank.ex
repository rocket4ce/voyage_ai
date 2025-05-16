defmodule VoyageAi.Rerank do
  @moduledoc """
  Respuesta para una solicitud de reranking que envuelve el modelo, uso y resultados.

  ## Ejemplos

      iex> %VoyageAi.Rerank{
      ...>   model: "rerank-2",
      ...>   usage: %VoyageAi.Usage{total_tokens: 0},
      ...>   results: []
      ...> }
  """

  alias VoyageAi.{Usage, Reranking}

  @enforce_keys [:model, :usage, :results]
  defstruct [:model, :usage, :results]

  @doc """
  Crea una nueva estructura de rerank.

  ## Parámetros

    * `:model` - El modelo utilizado para el reranking.
    * `:usage` - La información de uso.
    * `:results` - Los resultados del reranking.
  """
  def new(model, usage, results) do
    %__MODULE__{
      model: model,
      usage: usage,
      results: results
    }
  end

  @doc """
  Analiza los datos de rerank de la respuesta de la API.

  ## Parámetros

    * `:data` - Los datos de rerank de la respuesta de la API.
  """
  def parse(data) do
    model = Map.get(data, "model", "")
    usage = Usage.parse(Map.get(data, "usage", %{}))
    results = Enum.map(Map.get(data, "data", []), &Reranking.parse/1)

    new(model, usage, results)
  end
end
