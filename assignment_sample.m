%reading an excell sheet into matlab
clc; clear;
%reading of the table
B=readtable('C:\Users\Administrator\Desktop\archive (6)\BMW_Car_Sales_Classification.xlsx','Sheet','BMW_Car_Sales_Classification','Range','A1:K50001')
% extraction of unique years(2024)
T2024=B(B.Year==2024, : );%extraction of unique years(2024)
T2023=B(B.Year==2023, : );%extraction of unique years(2023)
T2022=B(B.Year==2022, : );%extraction of unique years(2022)
T2021=B(B.Year==2021, : );%extraction of unique years(2021)
T2020=B(B.Year==2020, : );%extraction of unique years(2020)
T2019=B(B.Year==2019, : );%extraction of unique years(2019)
T2018=B(B.Year==2018, : );%extraction of unique years(2018)
T2017=B(B.Year==2017, : );%extraction of unique years(2017)
T2016=B(B.Year==2016, : );%extraction of unique years(2016)
T2015=B(B.Year==2015, : );%extraction of unique years(2015)
T2014=B(B.Year==2014, : );%extraction of unique years(2014)
T2013=B(B.Year==2013, : );%extraction of unique years(2013)
T2012=B(B.Year==2012, : );%extraction of unique years(2012)
T2011=B(B.Year==2011, : );%extraction of unique years(2011)
T2010=B(B.Year==2010, : );%extraction of unique years(2010)
% %coversion of tables into struct
%for T2024
S2024=table2struct(T2024);
%for T2023
S2023=table2struct(T2023);
%for T2022
S2022=table2struct(T2022);
%for T2021
S2021=table2struct(T2021);
%for T2020
S2020=table2struct(T2020);
%for T2019
S2019=table2struct(T2019);
%for T2018
S2018=table2struct(T2018);
%for T2017
S2017=table2struct(T2017);
%for T2016
S2016=table2struct(T2016);
%for T2015
S2015=table2struct(T2015);
%for T2014
S2014=table2struct(T2014);
%for T2013
S2013=table2struct(T2013);
%for T2012
S2012=table2struct(T2012);
%for T2011
S2011=table2struct(T2011);
%for T2010
S2010=table2struct(T2010);
% 
% %generation of a workbook
outputFile = 'C:\Users\Administrator\Desktop\archive (6)\ALL_TABLES.xlsx';
%writing each table to a different sheet
writetable(T2024,outputFile,'Sheet','T2024');
writetable(T2023,outputFile,'Sheet','T2023');
writetable(T2022,outputFile,'Sheet','T2022');
writetable(T2021,outputFile,'Sheet','T2021');
writetable(T2020,outputFile,'Sheet','T2020');
writetable(T2019,outputFile,'Sheet','T2019');
writetable(T2018,outputFile,'Sheet','T2018');
writetable(T2017,outputFile,'Sheet','T2017');
writetable(T2016,outputFile,'Sheet','T2016');
writetable(T2015,outputFile,'Sheet','T2015');
writetable(T2014,outputFile,'Sheet','T2014');
writetable(T2013,outputFile,'Sheet','T2013');
writetable(T2012,outputFile,'Sheet','T2012');
writetable(T2011,outputFile,'Sheet','T2011');
writetable(T2010,outputFile,'Sheet','T2010');


