defmodule PrimesFinder.Worker do
  @moduledoc """

  Proceso encargado de encontrar primos en subintervalos con la logica de la criba
  de Eratostenes
  """


  def start(server_pid, {a, b}) do
    # Creación del proceso con la funcion spawn
    spawn(fn ->
      primos = buscar_primos(a, b)
      # Envío del mensaje al coordinador
      send(server_pid, {:ok, primos})
    end)
  end

  # Funcion para buscar primos en un rango especifico
  defp buscar_primos(a, b) when b < 2, do: []
  defp buscar_primos(a, b) do
    a_real = max(2, a)
    limite_raiz = :math.sqrt(b) |> trunc()

    # si el intervalo es mas 3 de necesitamos los primos base
    primos_base =
      if limite_raiz >= 2 do
        criba_recursiva(Enum.to_list(2..limite_raiz))
      else
        []
      end

    # Utilizamos los primos base para filtrarnuestro propio intervalo
    Enum.reduce(primos_base, Enum.to_list(a_real..b), fn p, acumulador ->
      # Rechazamos todos los múltiplos del primo 'p' que no sean el propio 'p'
      Enum.reject(acumulador, fn x -> x != p and rem(x, p) == 0 end)
    end)
  end

  @doc """
  implementacion recursiva de la criba. Toma el primer numero y elimina del resto de la lista
  """
  defp criba_recursiva([]), do: []
  defp criba_recursiva([p | resto]) do
    # Filtramos la cola eliminando los múltiplos de p y aplicamos recursion
    resto_filtrado = Enum.reject(resto, fn x -> rem(x, p) == 0 end)
    [p | criba_recursiva(resto_filtrado)]
  end
end
