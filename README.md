# VoyageAi

[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/rocket4ce/voyage_ai)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/rocket4ce/voyage_ai/blob/main/LICENSE)

Cliente Elixir para [VoyageAI](https://www.voyageai.com)

## Instalación

```elixir
def deps do
  [
    {:voyage_ai, "~> 0.1.0"}
  ]
end
```

## Uso

### Configuración

```elixir
VoyageAi.configure(
  api_key: "pa-...", # o configura ENV["VOYAGEAI_API_KEY"]
  host: "https://api.voyageai.com",
  version: "v1",
  timeout: 15000
)
```

### Embeddings

#### Generando un Embedding Individual

```elixir
input = "Un zorro marrón rápido salta sobre el perro perezoso."

client = VoyageAi.Client.new()
# o client = VoyageAi.Client.new(api_key: "pa-...")

embed = VoyageAi.Client.embed(client, input)
embed.model # "..."
embed.usage # %VoyageAi.Usage{total_tokens: ...}
embedding = VoyageAi.Embed.embedding(embed) # [0.0, ...]
```

#### Generando Múltiples Embeddings

```elixir
input = [
  "John es músico.",
  "Paul es fontanero.",
  "George es profesor.",
  "Ringo es médico."
]

client = VoyageAi.Client.new()

embed = VoyageAi.Client.embed(client, input)
embed.model # "..."
embed.usage # %VoyageAi.Usage{total_tokens: ...}
embed.embeddings # [[0.0, ...], ...]
```

### Reranking

```elixir
query = "¿Quién es el mejor para llamar para un inodoro?"

documents = [
  "John es músico.",
  "Paul es fontanero.",
  "George es profesor.",
  "Ringo es médico."
]

client = VoyageAi.Client.new()

rerank = VoyageAi.Client.rerank(client, query, documents, top_k: 3)
rerank.model # "..."
rerank.usage # %VoyageAi.Usage{total_tokens: ...}
rerank.results # [%VoyageAi.Reranking{index: 0, relevance_score: 0.5, ...}]
```

## Ejemplo Completo

```elixir
defmodule Example do
  alias VoyageAi.Client

  @documents [
    "John es músico.",
    "Paul es fontanero.",
    "George es profesor.",
    "Ringo es médico.",
    "Lisa es abogada.",
    "Stuart es pintor.",
    "Brian es escritor.",
    "Jane es chef.",
    "Bill es enfermero.",
    "Susan es carpintera."
  ]

  def run do
    client = Client.new()

    # Generar embeddings para todos los documentos
    embed = Client.embed(client, @documents, input_type: "document")

    # Buscar documentos relevantes
    search("¿Qué hacen George y Ringo?", client, embed)
    search("¿Quién trabaja en el campo médico?", client, embed)
  end

  defp search(query, client, embed) do
    # Calcular distancia euclidiana entre embeddings
    query_embedding = Client.embed(client, query, input_type: "query") |> VoyageAi.Embed.embedding()

    # Encontrar documentos más cercanos
    nearest_docs =
      Enum.zip(@documents, embed.embeddings)
      |> Enum.sort_by(fn {_doc, doc_embedding} ->
        euclidean_distance(query_embedding, doc_embedding)
      end)
      |> Enum.take(4)
      |> Enum.map(fn {doc, _} -> doc end)

    # Reordenar por relevancia
    results = Client.rerank(client, query, nearest_docs, top_k: 2).results

    IO.puts("Query: #{query}")
    Enum.each(results, fn reranking ->
      document = Enum.at(nearest_docs, reranking.index)
      IO.puts("Documento: #{document} (relevancia: #{reranking.relevance_score})")
    end)
  end

  defp euclidean_distance(src, dst) do
    Enum.zip(src, dst)
    |> Enum.map(fn {a, b} -> :math.pow(a - b, 2) end)
    |> Enum.sum()
    |> :math.sqrt()
  end
end
```

## Documentación

La documentación completa puede generarse con [ExDoc](https://github.com/elixir-lang/ex_doc):

```bash
mix docs
```

Una vez publicado, la documentación estará disponible en [HexDocs](https://hexdocs.pm/voyage_ai).
