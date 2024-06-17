
### Nenormalizirana tablica

| Id  | Naslov     | Zanr    | Godina | Tip  | Medij | Cijena | Zakasnina | Datum Posudbe         | Clan       | Clanski Broj |
| --- | ---------- | ------- | ------ | ---- | ----- | ------ | --------- | --------------------- | ---------- | ------------- |
| 1   | Deadpool   | komedija| 2016   | hit  | dvd   | 8.00   | 20.00     | 10.06.2024. - 13.06.2024. | Ivo Ivic   | 023081680     |
| 2   | Star wars  | SF      | 1986   | staro| dvd   | 4.00   | 6.00      | 10.06.2024. - 12.06.2024. | Pavo Pavic | 452345245     |


## 1 NF

### Filmovi

| Id  | Naslov    | Zanr    | Godina | Tip  | Medij | Cijena | Zakasnina |
| --- | --------- | ------- | ------ | ---- | ----- | ------ | --------- |
| 1   | Deadpool  | komedija| 2016   | hit  | dvd   | 8.00   | 10.00     |

### Clanovi

| Id  | Ime       | Adresa  | Telefon  | Clanski Broj |
| --- | --------- | ------- | -------- | ------------- |
| 1   | Ivo Ivic  | Ulica 23| 098585955| 023081680     |

### Posudbe

| Id  | Datum Posudbe | Datum Povrata | Zakasnina | Film Id | Clan Id |
| --- | ------------- | -------------- | --------- | ------- | ------- |
| 1   | 10.06.2024.   | 13.06.2024.    | 2         | 1       | 1       |

## 2 NF

### Filmovi

| Id  | Naslov    | Zanr Id | Godina | Tip  | Medij Id | Cijena | Zakasnina |
| --- | --------- | ------- | ------ | ---- | -------- | ------ | --------- |
| 1   | Deadpool  | 1       | 2016   | hit  | 2        | 8.00   | 10.00     |

### Clanovi

| Id  | Ime       | Adresa  | Telefon  | Clanski Broj |
| --- | --------- | ------- | -------- | ------------- |
| 1   | Ivo Ivic  | Ulica 23| 098585955| 023081680     |

### Posudbe

| Id  | Datum Posudbe | Datum Povrata | Zakasnina | Film Id | Clan Id |
| --- | ------------- | -------------- | --------- | ------- | ------- |
| 1   | 10.06.2024.   | 13.06.2024.    | 2         | 1       | 1       |

### Zanrovi

| Id  | Name      |
| --- | --------- |
| 1   | komedija  |
| 2   | akcija    |
| 3   | SF        |

### Mediji

| Id  | Type      |
| --- | --------- |
| 1   | kazeta    |
| 2   | DVD       |
| 3   | BlueRay   |

## 3 NF

### Filmovi

| Id  | Naslov    | Godina | Zanr Id | Cjenik Id |
| --- | --------- | ------ | ------- | --------- |
| 1   | Deadpool  | 2016   | 1       | 3         |
| 2   | Deadpool 2| 2018   | 1       | 1         |
| 3   | Deadpool 3| 2024   | 1       | 2         |

### Zanrovi

| Id  | Name      |
| --- | --------- |
| 1   | komedija  |
| 2   | akcija    |
| 3   | SF        |

### Clanovi

| Id  | Ime       | Adresa  | Telefon  | Clanski Broj |
| --- | --------- | ------- | -------- | ------------- |
| 1   | Ivo Ivic  | Ulica 23| 098585955| 023081680     |

### Cjenik

| Id  | Tip Filma  | Cijena | Zakasnina po Danu |
| --- | ---------- | ------ | ----------------- |
| 1   | standardni | 5.00   | 5.00              |
| 2   | hit        | 8.00   | 10.00             |
| 3   | stari      | 4.00   | 3.00              |

### Posudbe

| Id  | Datum Posudbe | Datum Povrata | Clan Id | Zaliha Id |
| --- | ------------- | -------------- | ------- | --------- |
| 1   | 10.06.2024.   | 13.06.2024.    | 1       | 2         |

### Zaliha

| Id  | Film Id | Medij Id | Kolicina |
| --- | ------- | -------- | -------- |
| 1   | 1       | 1        | 20       |
| 2   | 1       | 2        | 23       |
| 3   | 1       | 3        | 32       |
| 4   | 2       | 1        | 254      |
| 5   | 2       | 2        | 52       |

### Mediji

| Id  | Tip      | Koeficijent |
| --- | -------- | ----------- |
| 1   | kazeta   | 1           |
| 2   | DVD      | 1.2         |
| 3   | BlueRay  | 1.5         |