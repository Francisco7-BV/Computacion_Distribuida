defmodule PrimesFinder.Server do
  @moduledoc """
  Proceso que divide trabajo, crea trabajadores y recolecta resultado
  """

  alias PrimesFinder.Algebra
  alias PrimesFinder.Worker

  @doc """
  Inicia el servidor orquestador.
  Recibe el numero de trabajadores y el limite N
  """
  def start(num_workers, n) do
    # Divide el intervalo
    intervalos = Algebra.dividir_intervalo(n, num_workers)
    total = length(intervalos)
    
    # Crea los procesos trabajadores y asignar a cada uno su bloque
    Enum.each(intervalos, fn intervalo ->
      Worker.start(self(), intervalo)
    end)

    # Recibe los resultados mediante paso de mensajes
    # Pasa una lista vacia y el numero de trabajadores a espera
    total
    |> recolectar_resultados([])
    |> List.flatten()
    |> Algebra.ordenar()
  end


  defp recolectar_resultados(0, acumulado), do: acumulado


  defp recolectar_resultados(faltantes, acumulado) do
    receive do
      {:ok, primos_del_worker} ->

        recolectar_resultados(faltantes - 1, [primos_del_worker | acumulado])
    after

      10_000 ->
        IO.puts("Tiempo de espera agotado, no todos los trabajadores respondieron")
        acumulado
    end
  end
end
