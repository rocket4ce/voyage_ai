defmodule VoyageAi.Model do
  @moduledoc """
  Modelos disponibles para VoyageAI.
  """

  # Modelos de embeddings
  @voyage_3 "voyage-3"
  @voyage_3_large "voyage-3-large"
  @voyage_3_lite "voyage-3-lite"
  @voyage_finance_2 "voyage-finance-2"
  @voyage_multilingual_2 "voyage-multilingual-2"
  @voyage_law_2 "voyage-law-2"
  @voyage_code_2 "voyage-code-2"

  # Modelos de reranking
  @rerank_2 "rerank-2"
  @rerank_2_lite "rerank-2-lite"

  # Alias para facilitar el uso
  @voyage @voyage_3
  @voyage_lite @voyage_3_lite
  @voyage_finance @voyage_finance_2
  @voyage_multilingual @voyage_multilingual_2
  @voyage_law @voyage_law_2
  @voyage_code @voyage_code_2
  @rerank @rerank_2
  @rerank_lite @rerank_2_lite

  # Modelos de embeddings
  def voyage_3, do: @voyage_3
  def voyage_3_large, do: @voyage_3_large
  def voyage_3_lite, do: @voyage_3_lite
  def voyage_finance_2, do: @voyage_finance_2
  def voyage_multilingual_2, do: @voyage_multilingual_2
  def voyage_law_2, do: @voyage_law_2
  def voyage_code_2, do: @voyage_code_2

  # Modelos de reranking
  def rerank_2, do: @rerank_2
  def rerank_2_lite, do: @rerank_2_lite

  # Alias para facilitar el uso
  def voyage, do: @voyage
  def voyage_lite, do: @voyage_lite
  def voyage_finance, do: @voyage_finance
  def voyage_multilingual, do: @voyage_multilingual
  def voyage_law, do: @voyage_law
  def voyage_code, do: @voyage_code
  def rerank, do: @rerank
  def rerank_lite, do: @rerank_lite
end
