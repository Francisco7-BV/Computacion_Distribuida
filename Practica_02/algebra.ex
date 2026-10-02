defmodule PrimesFinder.Algebra do

@moduledoc """
  provee las operaciones matematicas y de lista auxilaidiares, se encarga de divir el rango de busquedas,
  dive los intervalos de 1 a n en la cantidad de trabajadores y devuelve una lista de tuplas
  """

  def dividir_intervalo(n, num_workers) do
    tamano = div(n + num_workers - 1, num_workers)

    1..n
    |> Enum.chunk_every(tamano)
    |> Enum.map(fn bloque -> {List.first(bloque), List.last(bloque)} end)
  end


  def ordenar(lista), do: Enum.sort(lista)

end
