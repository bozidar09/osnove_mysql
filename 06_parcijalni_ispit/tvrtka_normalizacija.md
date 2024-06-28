
### Nenormalizirana tablica

| Id  | Zaposlenik | Pozicija | Plaća | Voditelj | Odjel |
| --- | ---------- | -------- | ----- | -------- | ----- |



## 1 NF

### Zaposlenik

| Id  | Zaposlenik | Pozicija | Plaća | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | ---------- | -------- | ----- | --- | --- | ------ | ------- | ---------------- | 


### Odjel

| Id  | Naziv | Voditelj | 
| --- | ----- | -------- | 



## 2 NF

### Zaposlenik

| Id  | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | --- | --- | ------ | ------- | ---------------- | 


### Plaća

| Id  | Osnovica | Zaposlenik_id | Datum_od | Datum_do | 
| --- | -------- | ------------- | -------- | -------- | 


### Pozicija

| Id  | Naziv | Koeficijent | Datum_od | Datum_do | 
| --- | ----- | ----------- | -------- | -------- |


### Odjel

| Id  | Naziv | Voditelj | 
| --- | ----- | -------- |



## 3 NF

### Zaposlenik

| Id  | Ime | OIB | Adresa | Telefon | Datum_zaposlenja |
| --- | --- | --- | ------ | ------- | ---------------- |


### Plaća

| Id  | Osnovica | Zaposlenik_id | Datum_od | Datum_do | 
| --- | -------- | ------------- | -------- | -------- | 


### Pozicija

| Id  | Naziv | Koeficijent | 
| --- | ----- | ----------- |


### Pozicija_popis

| Id  | Zaposlenik_id | Pozicija_id | Datum_od | Datum_do | 
| --- | ------------- | ----------- | -------- | -------- |


### Odjel

| Id  | Naziv | 
| --- | ----- |


### Odjel_zaposlenik

| Id  | Odjel_id | Zaposlenik_id | Datum_od | Datum_do | 
| --- | -------- | ------------- | -------- | -------- |


### Voditelj

| Id  | Odjel_id | Zaposlenik_id | Datum_od | Datum_do | 
| --- | -------- | ------------- | -------- | -------- |
