import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Scanner;

class CountryData {
  String country;
  int confirmed;
  int deaths;
  int recovery;
  int active;

  public CountryData(String country, int confirmed, int deaths, int recovery, int active) {
    this.country = country;
    this.confirmed = confirmed;
    this.deaths = deaths;
    this.recovery = recovery;
    this.active = active;
  }
}

public class Main {
  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    String input = scanner.nextLine();
    String[] inputValues = input.split(" ");

    int n1 = Integer.parseInt(inputValues[0]);
    int n2 = Integer.parseInt(inputValues[1]);
    int n3 = Integer.parseInt(inputValues[2]);
    int n4 = Integer.parseInt(inputValues[3]);

    List<CountryData> countries = new ArrayList<>();

    try (BufferedReader br = new BufferedReader(new FileReader("dados.csv"))) {
      String line;

      while ((line = br.readLine()) != null) {
        String[] values = line.split(",");
        String country = values[0];
        int confirmed = Integer.parseInt(values[1]);
        int deaths = Integer.parseInt(values[2]);
        int recovery = Integer.parseInt(values[3]);
        int active = Integer.parseInt(values[4]);

        countries.add(new CountryData(country, confirmed, deaths, recovery, active));
      }
    } catch (IOException e) {
      e.printStackTrace();
    }

    int sumActive = 0;
    for (CountryData country : countries) {
      if (country.confirmed >= n1) {
        sumActive += country.active;
      }
    }
    System.out.println(sumActive);

    countries.sort((a, b) -> Integer.compare(b.active, a.active));
    List<CountryData> topActiveCountries = countries.subList(0, Math.min(n2, countries.size()));

    topActiveCountries.sort(Comparator.comparingInt(a -> a.confirmed));
    int sumDeaths = 0;
    for (int i = 0; i < Math.min(n3, topActiveCountries.size()); i++) {
      sumDeaths += topActiveCountries.get(i).deaths;
    }
    System.out.println(sumDeaths);

    countries.sort((a, b) -> Integer.compare(b.confirmed, a.confirmed));
    List<CountryData> topConfirmedCountries = countries.subList(0, Math.min(n4, countries.size()));

    topConfirmedCountries.sort(Comparator.comparing(a -> a.country));
    for (CountryData country : topConfirmedCountries) {
      System.out.println(country.country);
    }

    scanner.close();
  }
}
