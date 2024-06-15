import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

class CountryData {
  String country;
  int confirmed;
  int deaths;
  int recovery;
  int active;

  CountryData(String line) {
    String[] parts = line.split(",");
    this.country = parts[0].trim();
    this.confirmed = Integer.parseInt(parts[1].trim());
    this.deaths = Integer.parseInt(parts[2].trim());
    this.recovery = Integer.parseInt(parts[3].trim());
    this.active = Integer.parseInt(parts[4].trim());
  }
}

public class Main {
  public static void main(String[] args) throws IOException {
    try (Scanner scanner = new Scanner(System.in)) {
      String input = scanner.nextLine();
      String[] parts = input.split(" ");
      int n1 = Integer.parseInt(parts[0]);
      int n2 = Integer.parseInt(parts[1]);
      int n3 = Integer.parseInt(parts[2]);
      int n4 = Integer.parseInt(parts[3]);

      List<String> lines = Files.readAllLines(Paths.get("dados.csv"));

      List<CountryData> countries = lines.stream()
          .map(CountryData::new)
          .collect(Collectors.toList());

      int sumActiveConfirmedGTEQn1 = countries.stream()
          .filter(c -> c.confirmed >= n1)
          .mapToInt(c -> c.active)
          .sum();

      System.out.println(sumActiveConfirmedGTEQn1);

      int sumDeathsInTopN2Active = countries.stream()
          .sorted(Comparator.comparingInt(c -> -c.active))
          .limit(n2)
          .sorted(Comparator.comparingInt(c -> c.confirmed))
          .limit(n3)
          .mapToInt(c -> c.deaths)
          .sum();

      System.out.println(sumDeathsInTopN2Active);

      List<String> topN4ConfirmedCountries = countries.stream()
          .sorted(Comparator.comparingInt(c -> -c.confirmed))
          .limit(n4)
          .map(c -> c.country)
          .sorted()
          .collect(Collectors.toList());

      topN4ConfirmedCountries.forEach(System.out::println);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
