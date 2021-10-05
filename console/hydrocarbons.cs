using System;

enum Typ { Alkan, Alken, Alkin }

static class Stale {

  public static readonly string [] koncowki = { "an", "en", "yn" };

  public static readonly string [] nazwy =
    new string[] { "met", "et", "prop", "but", "pent",
                   "heks","hept","okt","non","dek" };

  public static readonly int granicaGazu = 5;
  public static readonly int granicaOleju = 4;

  public static readonly string blad = "błąd";

}

static class Funkcje {

  public static string LiczbaAtomow(int n){
    return 1 >= n ? "" : n.ToString();
  }

  public static void PokazNazwe(string nazwa){
    Console.WriteLine("Nazwa: " + nazwa);
  }

  public static void PokazWzor(string wzor){
    Console.WriteLine("Wzór: " + wzor);
  }

  public static void PokazStanSkupienia(string stan){
    Console.WriteLine("Stan skupienia: " + stan);
  }

  public static string NazwaZSzeregu(int wegiel){
    return Stale.nazwy[(int)wegiel - 1];
  }

  public static string WegielWodor(int wegiel){
    return (wegiel > 0 ? "C" : "") + Funkcje.LiczbaAtomow(wegiel) +
           "H" + Funkcje.LiczbaAtomow(2 * wegiel + 1);
  }

  public static void PokazNazweIWzor(string nazwa, string wzor){
    Funkcje.PokazNazwe(nazwa);
    Funkcje.PokazWzor(wzor);
  }

  public static void PokazWszystko(string nazwa, string wzor, string stanSkupienia){
    Funkcje.PokazNazweIWzor(nazwa,wzor);
    Funkcje.PokazStanSkupienia(stanSkupienia);
  }

  public static void Linia(){
    Console.WriteLine("---------------------------------");
  }

  public static void PokazWeglowodor(int wegiel,Typ typ){

    Console.WriteLine("*Węglowodór*");

    string nazwa, wzor, stan;

    // Nie istnieją alkeny i alkiny z 1 atomem węgla
    if (1 == wegiel && Typ.Alkan != typ) {
      nazwa = wzor = stan = Stale.blad;
    } else {
      nazwa = Funkcje.NazwaZSzeregu(wegiel) + Stale.koncowki[(int)typ];
      stan = wegiel < Stale.granicaGazu ? "gaz" : "ciecz";
      int wodor = wegiel * 2;
      if(Typ.Alken != typ) { wodor += (Typ.Alkan == typ ? 2 : -2); }
      wzor = "C" + Funkcje.LiczbaAtomow(wegiel) + "H" + wodor;
    }

    Funkcje.PokazWszystko(nazwa,wzor,stan);

  }

  public static void PokazAlkohol(int wegiel){

    Console.WriteLine("*Alkohol*");

    string nazwa = Funkcje.NazwaZSzeregu(wegiel) + "anol";
    string wzor = Funkcje.WegielWodor(wegiel) + "OH";
    string stan = (wegiel < Stale.granicaOleju ? "lotna" : "oleista") + " ciecz";

    Funkcje.PokazWszystko(nazwa,wzor,stan);

  }

  public static void PokazKwas(int wegiel){

    Console.WriteLine("*Kwas*");

    int w = wegiel - 1;
    string nazwa = "Kwas " + Funkcje.NazwaZSzeregu(wegiel) + Stale.koncowki[0] + "owy";

    string innaNazwa;
    switch (wegiel) {
      case 1: innaNazwa = "mrówkowy"; break;
      case 2: innaNazwa = "octowy"; break;
      case 3: innaNazwa = "propionowy"; break;
      case 4: innaNazwa = "masłowy"; break;
      case 5: innaNazwa = "walerianowy"; break;
      default: innaNazwa = ""; break;
    }

    if (innaNazwa != "") { nazwa += " (" + innaNazwa + ")"; }

    string wzor = Funkcje.WegielWodor(w) + "COOH";

    Funkcje.PokazNazweIWzor(nazwa,wzor);

  }

}

class Program {

  static void Main(string[] args) {

    Funkcje.Linia();
    Funkcje.PokazWeglowodor(4,Typ.Alkin);
    Funkcje.Linia();
    Funkcje.PokazAlkohol(5);
    Funkcje.Linia();
    Funkcje.PokazKwas(1);
    Funkcje.Linia();

  }

}
