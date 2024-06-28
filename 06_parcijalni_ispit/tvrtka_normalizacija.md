
### Nenormalizirana tablica

| Id  | Radnik | Pozicija | Plaća | Voditelj | Odjel |
| --- | ------ | -------- | ----- | -------- | ----- |



## 1 NF

### Radnik

| Id  | Pozicija | Plaća | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | -------- | ----- | --- | --- | ------ | ------- | ---------------- | 


### Odjel

| Id  | Naziv | Voditelj | 
| --- | ----- | -------- | 



## 2 NF

### Radnik

| Id  | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | --- | --- | ------ | ------- | ---------------- | 


### Pozicija

| Id  | Naziv | Plaća | Max_iznos | Min_iznos | 
| --- | ----- | ----- | --------- | --------- |


### Odjel

| Id  | Naziv | Voditelj | 
| --- | ----- | -------- |



## 3 NF

### Radnik

| Id  | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | --- | --- | ------ | ------- | ---------------- |


### Plaća

| Id  | Radnik_id | Pozicija_id | Iznos | Datum_od | Datum_do | 
| --- | --------- | ----------- | ----- | -------- | -------- | 


### Pozicija

| Id  | Naziv | Max_iznos | Min_iznos | 
| --- | ----- | --------- | --------- |


### Radnik_odjel

| Id  | Radnik_id | Odjel_id | Voditelj | Datum_od | Datum_do | 
| --- | --------- | -------- | -------- | -------- | -------- |


### Odjel

| Id  | Naziv | 
| --- | ----- |
