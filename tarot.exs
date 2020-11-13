wielkie = [ "Głupiec", "Mag", "Papieżyca", "Cesarzowa", "Cesarz",
            "Papież", "Kochankowie", "Rydwan", "Sprawiedliwość",
            "Eremita", "Koło Fortuny", "Siła", "Wisielec", "Śmierć",
            "Umiarkowanie", "Diabeł", "Wieża Boga", "Gwiazda",
            "Księżyc", "Słońce", "Sąd Ostateczny", "Świat" ]


ark = [ "Jedynka", "Dwójka", "Trójka", "Czwórka", "Piątka", "Szóstka",
         "Siódemka", "Ósemka", "Dziewiątka", "Dziesiątka", "Paź", "Rycerz",
         "Królowa", "Król" ]


kolory = ["Pałek", "Kielichów", "Mieczy", "Denarów"]


defmodule Tarot do
  def comb(_,[]) do
    []
  end

  def comb(kolor,[karta|karty]) do
    [karta <> " " <> kolor | comb(kolor,karty)]
  end
end

małe = List.foldr(kolory, [], fn(x,acc) -> Tarot.comb(x,ark) ++ acc end)

karty = wielkie ++ małe

kt = karty |> Enum.take_random(3)

kt |> IO.inspect
