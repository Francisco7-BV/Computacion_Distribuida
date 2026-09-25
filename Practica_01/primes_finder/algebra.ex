defmodule PrimesFinder.Algebra do

  @moduledoc "Operaciones auxiliares para dividir en intervalos y ordenar listas."

  def dividir_intervalo(n, num_workers) do
    tamano = div(n + num_workers - 1, num_workers)

    1..n
    |> Enum.chunk_every(tamano)
    |> Enum.map(fn bloque -> {List.first(bloque), List.last(bloque)} end)
  end


  def ordenar(lista), do: Enum.sort(lista)

end