defmodule VoyageAi.Reranking do
  @moduledoc """
  Respuesta de un reranking individual.

  ## Ejemplos

      iex> %VoyageAi.Reranking{
      ...>   index: 0,
      ...>   document: "Ejemplo",
      ...>   relevance_score: 0.0
      ...> }
  """

  @enforce_keys [:index, :document, :relevance_score]
  defstruct [:index, :document, :relevance_score]

  @doc """
  Crea una nueva estructura de reranking.

  ## Parámetros

    * `:index` - El índice del documento en la lista original.
    * `:document` - El documento.
    * `:relevance_score` - La puntuación de relevancia.
  """
  def new(index, document, relevance_score) do
    %__MODULE__{
      index: index,
      document: document,
      relevance_score: relevance_score
    }
  end

  @doc """
  Analiza los datos de reranking de la respuesta de la API.

  ## Parámetros

    * `:data` - Los datos de reranking de la respuesta de la API.
  """
  def parse(data) do
    index = Map.get(data, "index", 0)
    document = Map.get(data, "document", "")
    relevance_score = Map.get(data, "relevance_score", 0.0)

    new(index, document, relevance_score)
  end
end
