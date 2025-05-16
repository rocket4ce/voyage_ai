defmodule VoyageAiTest do
  use ExUnit.Case
  doctest VoyageAi

  alias VoyageAi.{Config, Model, Usage, Embed, Rerank, Reranking}

  describe "Config" do
    test "new/1 crea una nueva configuración con valores por defecto" do
      config = Config.new()
      assert config.host == "https://api.voyageai.com"
      assert config.version == "v1"
      assert config.timeout == 15000
    end

    test "new/1 crea una nueva configuración con valores personalizados" do
      config =
        Config.new(
          api_key: "test-key",
          host: "https://test.example.com",
          version: "v2",
          timeout: 30000
        )

      assert config.api_key == "test-key"
      assert config.host == "https://test.example.com"
      assert config.version == "v2"
      assert config.timeout == 30000
    end
  end

  describe "Model" do
    test "proporciona constantes para los modelos disponibles" do
      assert Model.voyage() == "voyage-3"
      assert Model.rerank() == "rerank-2"
    end
  end

  describe "Usage" do
    test "new/1 crea una nueva estructura de uso" do
      usage = Usage.new(42)
      assert usage.total_tokens == 42
    end

    test "parse/1 analiza los datos de uso" do
      usage = Usage.parse(%{"total_tokens" => 42})
      assert usage.total_tokens == 42
    end
  end

  describe "Embed" do
    test "new/3 crea una nueva estructura de embedding" do
      usage = Usage.new(42)
      embed = Embed.new("test-model", usage, [[0.1, 0.2, 0.3]])
      assert embed.model == "test-model"
      assert embed.usage == usage
      assert embed.embeddings == [[0.1, 0.2, 0.3]]
    end

    test "embedding/2 obtiene un embedding específico" do
      usage = Usage.new(42)
      embed = Embed.new("test-model", usage, [[0.1, 0.2, 0.3], [0.4, 0.5, 0.6]])
      assert Embed.embedding(embed) == [0.1, 0.2, 0.3]
      assert Embed.embedding(embed, 1) == [0.4, 0.5, 0.6]
    end
  end

  describe "Reranking" do
    test "new/3 crea una nueva estructura de reranking" do
      reranking = Reranking.new(0, "test-document", 0.75)
      assert reranking.index == 0
      assert reranking.document == "test-document"
      assert reranking.relevance_score == 0.75
    end
  end

  describe "Rerank" do
    test "new/3 crea una nueva estructura de rerank" do
      usage = Usage.new(42)
      reranking = Reranking.new(0, "test-document", 0.75)
      rerank = Rerank.new("test-model", usage, [reranking])
      assert rerank.model == "test-model"
      assert rerank.usage == usage
      assert rerank.results == [reranking]
    end
  end
end
