defmodule VoyageAi.Error do
  @moduledoc """
  Errores específicos para VoyageAI.
  """

  defmodule RequestError do
    @moduledoc """
    Error que se produce cuando una solicitud a la API falla.
    """

    defexception [:status_code, :body, :message]

    @doc """
    Crea un nuevo error de solicitud.

    ## Parámetros

      * `:status_code` - El código de estado HTTP.
      * `:body` - El cuerpo de la respuesta.
    """
    def new(status_code, body) do
      message = "Error en la solicitud: status_code=#{status_code}, body=#{inspect(body)}"
      %__MODULE__{status_code: status_code, body: body, message: message}
    end

    @impl true
    def message(%__MODULE__{message: message}), do: message
  end

  defmodule ConfigError do
    @moduledoc """
    Error que se produce cuando hay un problema con la configuración.
    """

    defexception [:message]

    @doc """
    Crea un nuevo error de configuración.

    ## Parámetros

      * `:message` - El mensaje de error.
    """
    def new(message) do
      %__MODULE__{message: message}
    end

    @impl true
    def message(%__MODULE__{message: message}), do: message
  end
end
