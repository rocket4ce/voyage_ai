defmodule VoyageAi.Usage do
  @moduledoc """
  Información de uso devuelta por la API de VoyageAI.

  ## Ejemplos

      iex> %VoyageAi.Usage{total_tokens: 0}
  """

  @enforce_keys [:total_tokens]
  defstruct [:total_tokens]

  @doc """
  Crea una nueva estructura de uso.

  ## Parámetros

    * `:total_tokens` - El número total de tokens utilizados.
  """
  def new(total_tokens) do
    %__MODULE__{total_tokens: total_tokens}
  end

  @doc """
  Analiza los datos de uso de la respuesta de la API.

  ## Parámetros

    * `:data` - Los datos de uso de la respuesta de la API.
  """
  def parse(data) do
    total_tokens = Map.get(data, "total_tokens", 0)
    new(total_tokens)
  end
end
